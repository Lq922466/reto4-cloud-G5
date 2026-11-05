#!/usr/bin/env python3
"""Revisa las líneas añadidas entre dos commits en busca de secretos y archivos sensibles.

Sale con error si encuentra algo. Comprueba antes que el propio detector funciona.
Uso: revisar-secretos.py COMMIT_BASE COMMIT_FINAL
"""
import re
import subprocess
import sys

SECRETOS = re.compile(
    r"AKIA[0-9A-Z]{16}|ASIA[0-9A-Z]{16}|BEGIN [A-Z ]*PRIVATE|SWMTKN-1-|dckr_pat_|dckr_oat_"
    r"|ghp_[A-Za-z0-9]|gho_[A-Za-z0-9]|ghs_[A-Za-z0-9]|github_pat_|aws_session_token|aws_secret"
    r"|Bearer [A-Za-z0-9._-]{10}|eyJ[A-Za-z0-9_-]{20}|\"auth\"\s*:\s*\"|\b[0-9]{12}\b|arn:aws:"
)
ARCHIVOS = re.compile(r"tfstate|tfplan|\.pem$|\.key$|ssh\.local|\.tfvars$|config\.json|(^|/)\.env")
EXCEPCIONES = re.compile(r"\.example\.tfvars$")


def git(*args):
    return subprocess.run(["git", *args], capture_output=True, text=True, errors="replace", check=True).stdout


def main(base, final):
    for muestra in ("dckr_pat_abc", "eyJhbGciOiJSUzI1NiIsInR5cCI6", "cuenta 123456789012"):
        assert SECRETOS.search(muestra), muestra
    assert not SECRETOS.search("sha256:622d83436cb97412b761")

    archivos = git("diff", "--name-only", base, final).split("\n")
    # Los binarios se excluyen: sus bytes dan coincidencias falsas. Las capturas se revisan a la vista.
    # Estos scripts contienen patrones de detección y muestras de prueba, y darían falsos positivos.
    excluidos = [f":!{ruta}" for ruta in ("scripts/revisar-secretos.py", "scripts/capturas-norma.py", "scripts/comprobar-laboratorio.sh")]
    texto = git("diff", "--no-color", base, final, "--", ".", *excluidos)
    anadidas = [l for l in texto.splitlines() if l.startswith("+") and not l.startswith("+++")]
    hallazgos = [l[:70] for l in anadidas if SECRETOS.search(l)]
    sensibles = [f for f in archivos if ARCHIVOS.search(f) and not EXCEPCIONES.search(f)]
    binarios = [f for f in archivos if f.endswith((".png", ".PNG", ".jpg"))]

    print(f"Líneas añadidas revisadas: {len(anadidas)}. Archivos: {len([f for f in archivos if f])}.")
    print(f"Imágenes no revisadas por este script: {len(binarios)}.")
    print(f"Coincidencias: {len(hallazgos)} {hallazgos[:5]}")
    print(f"Archivos sensibles: {sensibles}")
    return 1 if hallazgos or sensibles else 0


if __name__ == "__main__":
    if len(sys.argv) != 3:
        sys.exit(__doc__)
    sys.exit(main(sys.argv[1], sys.argv[2]))
