#!/usr/bin/env python3
"""Regresiones de sondas y verificación usando procesos y respuestas locales simuladas.

No ejecuta AWS, SSH, Docker ni peticiones de red reales.
"""
import os
from pathlib import Path
import signal
import subprocess
import unittest


ROOT = Path(__file__).resolve().parents[1]
MOCKS = r'''
ssh() {
    [[ "${MOCK_SSH_FAIL:-0}" == 0 ]] || return 73
    local cmd=${!#}
    case "$cmd" in
        'hostname; docker node ls '*)
            printf 'manager-g5\nmanager-g5 Ready Active Leader\nworker1-g5 Ready Active \nworker2-g5 Ready Active \nworker3-g5 Ready Active \n' ;;
        'docker service ls '*) printf '4/4\n' ;;
        'docker service inspect '*) printf 'innnx/reto4-f1:1.0\n' ;;
        'docker service ps '*)
            for n in 1 2 3 4; do
                printf 'reto4_web.%s innnx/reto4-f1:1.0 worker1-g5 %s 10 seconds ago\n' "$n" "${MOCK_TASK_STATE:-Running}"
            done ;;
        *) printf 'Orden SSH inesperada en prueba local.\n' >&2; return 91 ;;
    esac
}
aws() {
    [[ "${MOCK_AWS_FAIL:-0}" == 0 ]] || return 74
    printf '192.0.2.10\t192.0.2.11\t192.0.2.12\t192.0.2.13\n'
}
curl() {
    if [[ "$*" == *'%{http_code}'* ]]; then
        printf 200
    elif [[ "${MOCK_BALANCE:-one}" == two ]]; then
        case "$*" in
            *192.0.2.10*|*192.0.2.12*) printf 'version=1.0\ncontenedor=replica-a\n' ;;
            *) printf 'version=1.0\ncontenedor=replica-b\n' ;;
        esac
    else
        printf '%s\n' "$MOCK_BODY"
    fi
}
export -f ssh aws curl
'''


def environment(**changes):
    values = dict(os.environ, MOCK_BODY="version=1.0\ncontenedor=replica-a")
    values.update(changes)
    return values


class SondeoTests(unittest.TestCase):
    def sample(self, body):
        process = subprocess.Popen(
            ["bash", "-c", MOCKS + '\nexec bash scripts/sondear-web.sh http://prueba.invalid/identidad.txt'],
            cwd=ROOT,
            env=environment(MOCK_BODY=body),
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            start_new_session=True,
        )
        try:
            stdout, stderr = process.communicate(timeout=0.2)
        except subprocess.TimeoutExpired:
            os.killpg(process.pid, signal.SIGTERM)
            stdout, stderr = process.communicate(timeout=2)
        self.assertEqual(stderr, "")
        self.assertTrue(stdout, "La sonda no registró ninguna muestra")
        return stdout

    def test_accepts_both_releases_during_update(self):
        for version in ("1.0", "2.0"):
            with self.subTest(version=version):
                self.assertIn(" OK ", self.sample(f"version={version}\ncontenedor=replica-a"))

    def test_rejects_http_success_with_error_page(self):
        self.assertIn(" FALLO IDENTIDAD", self.sample("<html>Error de aplicación</html>"))

    def test_rejects_empty_container_identity(self):
        self.assertIn(" FALLO IDENTIDAD", self.sample("version=1.0\ncontenedor="))


class VerificacionTests(unittest.TestCase):
    def verify(self, **changes):
        return subprocess.run(
            ["bash", "-c", MOCKS + "\nbash scripts/verificar-despliegue.sh /config-falso innnx/reto4-f1 1.0"],
            cwd=ROOT, env=environment(**changes), capture_output=True, text=True, timeout=5,
        )

    def test_rejects_single_container_responses(self):
        result = self.verify()
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("no se ha demostrado balanceo", result.stderr)

    def test_rejects_pending_tasks(self):
        result = self.verify(MOCK_TASK_STATE="Pending", MOCK_BALANCE="two")
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("tareas Running", result.stderr)

    def test_accepts_running_tasks_and_distinct_replicas(self):
        result = self.verify(MOCK_BALANCE="two")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("contenedor=replica-a", result.stdout)
        self.assertIn("contenedor=replica-b", result.stdout)

    def test_rejects_incomplete_identity(self):
        result = self.verify(MOCK_BODY="version=1.0\ncontenedor=")
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("identidad incompleta", result.stderr)

    def test_propagates_ssh_failure(self):
        self.assertEqual(self.verify(MOCK_SSH_FAIL="1").returncode, 73)

    def test_rejects_failed_aws_query(self):
        self.assertNotEqual(self.verify(MOCK_AWS_FAIL="1").returncode, 0)


class SupervisarTests(unittest.TestCase):
    def supervise(self, alive, empty=False):
        script = r'''
set -euo pipefail
root=$PWD
logs=$(mktemp -d)
cleanup() { parar_sondas; rm -rf -- "$logs"; }
source scripts/lib-sondas.sh
trap cleanup EXIT
ips=(192.0.2.10)
if [[ "$MOCK_EMPTY" == 0 ]]; then
    printf '%s OK version=1.0 contenedor=replica-a\n' "$(date -Is)" > "$logs/sonda-192.0.2.10.txt"
else
    : > "$logs/sonda-192.0.2.10.txt"
fi
if [[ "$MOCK_ALIVE" == 1 ]]; then
    sleep 30 &
    probes=($!)
else
    true &
    probes=($!)
    wait "${probes[0]}"
fi
watch=0; summary=0
vigilar_sondas || watch=$?
resumir_sondas || summary=$?
printf 'watch=%s summary=%s\n' "$watch" "$summary"
'''
        return subprocess.run(
            ["bash", "-c", script], cwd=ROOT, capture_output=True, text=True,
            env=environment(MOCK_ALIVE=str(int(alive)), MOCK_EMPTY=str(int(empty))), timeout=5,
        )

    def test_rejects_dead_probe_even_when_last_sample_was_ok(self):
        result = self.supervise(False)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("watch=1 summary=1", result.stdout)
        self.assertIn("ha terminado", result.stderr)

    def test_accepts_live_probe_with_valid_sample(self):
        result = self.supervise(True)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("watch=0 summary=0", result.stdout)

    def test_rejects_probe_without_samples(self):
        result = self.supervise(True, empty=True)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("watch=1 summary=1", result.stdout)
        self.assertIn("no ha registrado muestras", result.stderr)


if __name__ == "__main__":
    unittest.main()
