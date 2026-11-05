#!/usr/bin/env bash
set -euo pipefail
# Sustituye la imagen del servicio por la 1.0 publicada y espera a que converja.
# REQUIERE AUTORIZACIÓN: modifica el servicio de Swarm.
# Uso: desplegar-f1.sh CONFIG_SSH CUENTA/REPOSITORIO
if [[ $# != 2 ]]; then
    printf 'Uso: %s CONFIG_SSH CUENTA/REPOSITORIO\n' "$0" >&2
    exit 2
fi
config=$1 target=$2
root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
remote() { ssh -n -F "$config" -o BatchMode=yes -o StrictHostKeyChecking=yes manager-g5 "$@"; }

workdir=$(remote mktemp -d)
cleanup() { remote "rm -rf -- '$workdir'" || true; }
trap cleanup EXIT
tar -C "$root/app" -cf - stack.yml desplegar.sh |
    ssh -F "$config" -o BatchMode=yes -o StrictHostKeyChecking=yes manager-g5 "tar -C '$workdir' -xf -"
hostname
date -Is
printf '\n$ [manager-g5] bash app/desplegar.sh %s:1.0\n' "$target"
remote "bash '$workdir/desplegar.sh' '$target:1.0'"
for _ in $(seq 1 60); do
    state=$(remote 'docker service inspect --format "{{if .UpdateStatus}}{{.UpdateStatus.State}}{{else}}completed{{end}}" reto4_web')
    replicas=$(remote 'docker service ls --filter name=reto4_web --format "{{.Replicas}}"')
    spec=$(remote 'docker service inspect --format "{{.Spec.TaskTemplate.ContainerSpec.Image}}" reto4_web')
    # El servicio conserva el estado de su última actualización hasta que empieza la nueva.
    [[ "$state" == completed && "$replicas" == 4/4 && "$spec" == "$target:1.0"* ]] && break
    case "$state" in paused|rollback_paused) printf 'Actualización interrumpida: %s\n' "$state" >&2; exit 1 ;; esac
    sleep 5
done
printf 'Estado de la actualización: %s, réplicas %s\n' "$state" "$replicas"
[[ "$state" == completed && "$replicas" == 4/4 && "$spec" == "$target:1.0"* ]]
bash "$root/scripts/verificar-despliegue.sh" "$config" "$target" 1.0
