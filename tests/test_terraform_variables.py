"""Comprueba validación de accesos SSH con Terraform local, sin proveedores ni AWS."""
import json
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[1]


@unittest.skipUnless(shutil.which("terraform"), "Terraform no está instalado")
class VariablesSSHTest(unittest.TestCase):
    def plan(self, main_cidr="192.0.2.10/32", additional=None):
        with tempfile.TemporaryDirectory() as temp:
            folder = Path(temp)
            shutil.copyfile(ROOT / "terraform/variables.tf", folder / "variables.tf")
            values = {
                "ssh_cidr": main_cidr,
                "ssh_public_keys": ["ssh-ed25519 AAAA prueba-local"],
                "ssh_additional_cidrs": additional or {},
            }
            (folder / "prueba.auto.tfvars.json").write_text(json.dumps(values))
            return subprocess.run(
                ["terraform", "-chdir=" + temp, "plan", "-input=false", "-lock=false", "-no-color"],
                text=True, capture_output=True, timeout=20,
            )

    def test_preserves_multiple_restricted_origins(self):
        result = self.plan(additional={"203.0.113.0/24": "Acceso de aula"})
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

    def test_rejects_world_open_primary_ssh(self):
        result = self.plan(main_cidr="0.0.0.0/0")
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("SSH requiere un CIDR IPv4 restringido", result.stderr)

    def test_rejects_world_open_additional_ssh(self):
        result = self.plan(additional={"0.0.0.0/0": "No autorizado"})
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("Cada acceso SSH adicional", result.stderr)

    def test_rejects_malformed_primary_cidr(self):
        result = self.plan(main_cidr="999.999.999.999/32")
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("SSH requiere un CIDR IPv4 restringido", result.stderr)
