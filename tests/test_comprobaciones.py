"""Regresiones de las comprobaciones: solo ejecutan AWS, curl, SSH y Terraform simulados."""

import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[1]
MOCK = r'''
import json, os, sys
from pathlib import Path

name = Path(sys.argv[0]).name
args = sys.argv[1:]
with open(os.environ["MOCK_CALLS"], "a") as f:
    f.write(json.dumps({"name": name, "args": args}) + "\n")
if name == "aws":
    operation = args[1]
    if os.environ.get("MOCK_AWS_DENY") in ("all", operation):
        print("AccessDenied for account " + "123456" + "789012", file=sys.stderr)
        sys.exit(1)
    key = {"describe-instances": "MOCK_EC2", "describe-instance-status": "MOCK_HEALTH", "describe-security-groups": "MOCK_SG"}[operation]
    print(os.environ[key])
elif name == "curl":
    if "https://checkip.amazonaws.com" in args:
        print(os.environ.get("MOCK_IP", "192.0.2.10"))
    elif "-w" in args:
        print("200", end="")
    else:
        print(os.environ.get("MOCK_BODY", "version=1.0\ncontenedor=prueba"))
elif name == "ssh":
    if os.environ.get("MOCK_SSH_FAIL"):
        print("Connection timed out", file=sys.stderr)
        sys.exit(255)
    print(os.environ["MOCK_SWARM"])
elif name == "terraform":
    if os.environ.get("MOCK_TF_FAIL"):
        print("detalle privado de error", file=sys.stderr)
        sys.exit(1)
    print(os.environ["MOCK_NODES"])
else:
    raise AssertionError(name)
'''


class ComprobacionesTest(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        for name in ("scripts", "config", "terraform", "bin"):
            (self.root / name).mkdir()
        for name in ("comprobar-laboratorio.sh", "generar-config-ssh.sh", "lib-ssh-config.sh"):
            shutil.copyfile(ROOT / "scripts" / name, self.root / "scripts" / name)
        shutil.copyfile(ROOT / "config/ssh_config.example", self.root / "config/ssh_config.example")
        self.config = self.root / "config/ssh.local"
        self.config.write_text("configuracion anterior\n")
        self.calls = self.root / "calls.jsonl"
        self.env = dict(os.environ, PATH=str(self.root / "bin") + os.pathsep + os.environ["PATH"], MOCK_CALLS=str(self.calls))
        self.env.pop("TF_STATE_PATH", None)
        for name in ("aws", "curl", "ssh", "terraform"):
            p = self.root / "bin" / name
            p.write_text(f"#!{sys.executable}\n" + MOCK)
            p.chmod(0o700)

        expected = [
            ("manager-g5", "i-0e6ebf2af63facc60", "172.31.28.10"),
            ("worker1-g5", "i-066a1ad3b7a8e0db9", "172.31.17.168"),
            ("worker2-g5", "i-0ed6d9c9957251a18", "172.31.29.192"),
            ("worker3-g5", "i-0446409b26cf0a662", "172.31.31.183"),
        ]
        self.nodes = {}
        instances, health = [], []
        for index, (name, identity, private) in enumerate(expected):
            public = f"198.51.100.{index + 1}"
            self.nodes[name] = {"id": identity, "private_ip": private, "public_ip": public}
            instances.append({"InstanceId": identity, "PrivateIpAddress": private, "PublicIpAddress": public,
                              "State": {"Name": "running"}, "Tags": [{"Key": "Name", "Value": name}]})
            health.append({"InstanceId": identity, "SystemStatus": {"Status": "ok"}, "InstanceStatus": {"Status": "ok"}})
        self.env.update(MOCK_EC2=json.dumps({"Reservations": [{"Instances": instances}]}),
                        MOCK_HEALTH=json.dumps({"InstanceStatuses": health}), MOCK_NODES=json.dumps(self.nodes))
        self.set_cidrs(["192.0.2.10/32", "203.0.113.22/32"])
        self.swarm_nodes = [{"Hostname": name, "Status": "Ready", "Availability": "Active",
                             "ManagerStatus": "Leader" if name == "manager-g5" else ""} for name, _, _ in expected]
        self.services = [{"Name": "reto4_web", "Replicas": "4/4", "Mode": "replicated", "Image": "innnx/reto4-f1:1.0"}]
        self.networks = [{"Name": "red-g5", "Driver": "overlay", "Ingress": True, "MTU": "1450"},
                         {"Name": "red-app-g5", "Driver": "overlay", "Ingress": False, "MTU": "1450"}]
        self.set_swarm()

    def set_cidrs(self, cidrs):
        self.env["MOCK_SG"] = json.dumps({"SecurityGroups": [{"GroupId": "sg-prueba", "IpPermissions": [
            {"FromPort": 22, "ToPort": 22, "IpRanges": [{"CidrIp": c} for c in cidrs]}]}]})

    def set_swarm(self):
        lines = ["manager-g5", "2026-11-09T13:00:00+01:00"]
        for label, rows in [("NODOS", self.swarm_nodes), ("SERVICIOS", self.services), ("REDES", self.networks)]:
            lines += ["# " + label] + [json.dumps(row) for row in rows]
        self.env["MOCK_SWARM"] = "\n".join(lines)

    def run_script(self, name, *args):
        return subprocess.run(["bash", str(self.root / "scripts" / name), *map(str, args)],
                              cwd=self.root, env=self.env, text=True, capture_output=True, timeout=15)

    def recorded_calls(self):
        return [json.loads(line) for line in self.calls.read_text().splitlines()] if self.calls.exists() else []

    def test_laboratorio_accepts_other_authorized_ssh_origins(self):
        result = self.run_script("comprobar-laboratorio.sh")
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertNotIn("revoke-security-group-ingress", result.stdout)
        ssh = next(c for c in self.recorded_calls() if c["name"] == "ssh")
        self.assertTrue(ssh["args"][-1].startswith("set -e\n"))
        for call in self.recorded_calls():
            if call["name"] == "aws":
                self.assertTrue(call["args"][1].startswith("describe-"))

    def test_laboratorio_accepts_cidr_covering_the_control_machine(self):
        self.set_cidrs(["192.0.2.0/24", "203.0.113.22/32"])
        result = self.run_script("comprobar-laboratorio.sh")
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertNotIn("authorize-security-group-ingress", result.stdout)

    def test_laboratorio_missing_ssh_origin_only_proposes_addition(self):
        self.set_cidrs(["203.0.113.22/32"])
        result = self.run_script("comprobar-laboratorio.sh")
        self.assertEqual(result.returncode, 2)
        self.assertIn("authorize-security-group-ingress", result.stdout)
        self.assertNotIn("revoke-security-group-ingress", result.stdout)

    def test_laboratorio_rejects_world_open_ssh_without_removing_it(self):
        self.set_cidrs(["0.0.0.0/0"])
        result = self.run_script("comprobar-laboratorio.sh")
        self.assertEqual(result.returncode, 2)
        self.assertIn("SSH está abierto a Internet", result.stdout)
        self.assertNotIn("revoke-security-group-ingress", result.stdout)

    def test_laboratorio_rejects_three_managers(self):
        for node in self.swarm_nodes[1:3]:
            node["ManagerStatus"] = "Reachable"
        self.set_swarm()
        result = self.run_script("comprobar-laboratorio.sh")
        self.assertEqual(result.returncode, 2)
        self.assertIn("NO CORRECTO: C3", result.stdout)

    def test_laboratorio_rejects_http_200_without_application_identity(self):
        self.env["MOCK_BODY"] = "<html>Error de aplicación</html>"
        result = self.run_script("comprobar-laboratorio.sh")
        self.assertEqual(result.returncode, 2)
        self.assertIn("identidad de la aplicación ausente", result.stdout)

    def test_laboratorio_rejects_wrong_replicas_and_mtu(self):
        self.services[0]["Replicas"] = "3/4"
        self.networks[0]["MTU"] = "1500"
        self.set_swarm()
        result = self.run_script("comprobar-laboratorio.sh")
        self.assertEqual(result.returncode, 2)
        self.assertIn("NO CORRECTO: D2", result.stdout)
        self.assertIn("NO CORRECTO: Red red-g5", result.stdout)

    def test_laboratorio_aws_denial_does_not_leak_account_or_call_ssh(self):
        for operation in ("all", "describe-security-groups"):
            with self.subTest(operation=operation):
                self.env["MOCK_AWS_DENY"] = operation
                self.calls.unlink(missing_ok=True)
                result = self.run_script("comprobar-laboratorio.sh")
                self.assertEqual(result.returncode, 3)
                self.assertNotIn("123456" + "789012", result.stdout + result.stderr)
                self.assertFalse(any(c["name"] == "ssh" for c in self.recorded_calls()))

    def test_laboratorio_ssh_failure_does_not_claim_success(self):
        self.env["MOCK_SSH_FAIL"] = "1"
        result = self.run_script("comprobar-laboratorio.sh")
        self.assertEqual(result.returncode, 2)
        self.assertIn("Sin acceso SSH", result.stdout)
        self.assertNotIn("Resultado: todo correcto", result.stdout)

    def test_missing_state_preserves_previous_ssh_configuration(self):
        result = self.run_script("generar-config-ssh.sh")
        self.assertEqual(result.returncode, 1)
        self.assertEqual(self.config.read_text(), "configuracion anterior\n")
        self.assertFalse(self.recorded_calls())

    def test_explicit_state_is_resolved_before_terraform_chdir(self):
        (self.root / "operativo.tfstate").write_text("estado de prueba\n")
        result = self.run_script("generar-config-ssh.sh", "operativo.tfstate")
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        call = next(c for c in self.recorded_calls() if c["name"] == "terraform")
        self.assertIn("-state=" + str(self.root / "operativo.tfstate"), call["args"])
        self.assertIn("HostName 198.51.100.1", self.config.read_text())
        self.assertIn("HostName 172.31.17.168", self.config.read_text())
        self.assertEqual(self.config.stat().st_mode & 0o777, 0o600)

    def test_incomplete_outputs_preserve_previous_ssh_configuration(self):
        state = self.root / "operativo.tfstate"
        state.write_text("estado de prueba\n")
        del self.nodes["worker3-g5"]
        self.env["MOCK_NODES"] = json.dumps(self.nodes)
        result = self.run_script("generar-config-ssh.sh", state)
        self.assertEqual(result.returncode, 1)
        self.assertEqual(self.config.read_text(), "configuracion anterior\n")

    def test_terraform_failure_preserves_config_and_private_error(self):
        state = self.root / "operativo.tfstate"
        state.write_text("estado de prueba\n")
        self.env.update(TF_STATE_PATH=str(state), MOCK_TF_FAIL="1")
        result = self.run_script("generar-config-ssh.sh")
        self.assertEqual(result.returncode, 1)
        self.assertEqual(self.config.read_text(), "configuracion anterior\n")
        self.assertNotIn("detalle privado de error", result.stdout + result.stderr)


if __name__ == "__main__":
    unittest.main()
