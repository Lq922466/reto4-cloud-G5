#!/usr/bin/env python3
"""Comprueba la coherencia de los documentos de entrega. No accede a la red ni cambia nada.

Revisa enlaces y anclas, que el índice cubra las evidencias, y que REVISION.md, el índice y la checklist
tengan los mismos 42 criterios con el mismo estado. Ejecutar desde la raíz del repositorio.
"""
import re
import sys
import urllib.parse
from pathlib import Path

DOCS = [
    "README.md", "REVISION.md", "PROYECTO.md", "GESTION.md", "diagramas/arquitectura.md",
    "evidencias/INDICE.md", "evidencias/capturas-terminal/INDICE.md", "evidencias/auditoria/INFORME.md",
    "evidencias/auditoria/E4-E8.md", "entrega/INFORME-F9-estructura.md", "entrega/PENDIENTES.md",
    "entrega/DEFENSA.md", "entrega/CHECKLIST-FINAL.md", "entrega/CONTRASTE-GUIA-RUBRICA.md", "practica-individual/README.md",
]
AGRUPADAS = ("capturas-terminal", "F3-despliegue", "F3-actualizacion", "F4-E2", "F4-E3", "F4-E6")


def ancla(titulo):
    titulo = re.sub(r"[`*]", "", titulo.strip().lower())
    return re.sub(r"\s", "-", re.sub(r"[^\w\s-]", "", titulo))


def sin_codigo(texto):
    return re.sub(r"```.*?```", "", texto, flags=re.S)


def main():
    errores = []
    enlazados = set()
    for doc in DOCS:
        ruta = Path(doc)
        if not ruta.exists():
            errores.append(f"Falta {doc}")
            continue
        for destino in re.findall(r"\]\(([^)\s]+)\)", sin_codigo(ruta.read_text())):
            if destino.startswith("http"):
                continue
            camino, _, fragmento = destino.partition("#")
            objetivo = (ruta.parent / urllib.parse.unquote(camino)).resolve() if camino else ruta.resolve()
            enlazados.add(objetivo)
            if not objetivo.exists():
                errores.append(f"{doc}: enlace roto {destino}")
            elif fragmento and objetivo.suffix == ".md":
                titulos = re.findall(r"(?m)^#+\s+(.*)$", sin_codigo(objetivo.read_text()))
                if urllib.parse.unquote(fragmento) not in {ancla(t) for t in titulos}:
                    errores.append(f"{doc}: ancla inexistente {destino}")

    raiz = Path("evidencias").resolve()
    for archivo in sorted(raiz.rglob("*")):
        relativo = archivo.relative_to(raiz)
        if archivo.is_file() and archivo.name != "INDICE.md" and relativo.parts[0] not in AGRUPADAS:
            if archivo not in enlazados:
                errores.append(f"Evidencia sin enlazar en los documentos: {relativo}")
    indice_capturas = (raiz / "capturas-terminal/INDICE.md").read_text()
    for imagen in sorted((raiz / "capturas-terminal").glob("*.png")):
        if imagen.name not in indice_capturas:
            errores.append(f"Captura sin indexar: {imagen.name}")

    def estados(texto):
        return {c: e.strip() for c, e in re.findall(r"(?m)^\| ([FABCDEG]\d+) \| (?:(?:Definitiva|Provisional|Entorno) \| )?([^|]+) \|", texto)}

    matriz = estados(Path("REVISION.md").read_text().split("## Capturas que faltan")[0])
    indice = estados(Path("evidencias/INDICE.md").read_text().split("## Auditoría")[0])
    if len(matriz) != 42:
        errores.append(f"La matriz tiene {len(matriz)} criterios, no 42")
    for criterio, estado in matriz.items():
        if indice.get(criterio) != estado:
            errores.append(f"{criterio}: REVISION dice «{estado}» y el índice «{indice.get(criterio)}»")

    texto = Path("entrega/CHECKLIST-FINAL.md").read_text()
    secciones = {
        "Listo": texto.split("## Listos")[1].split("## Demostrados")[0],
        "Demostrado, falta captura conforme": texto.split("## Demostrados")[1].split("## Parciales")[0],
        "Parcial": texto.split("## Parciales")[1].split("## Pendientes")[0],
        "Pendiente": texto.split("## Pendientes")[1].split("## Antes de entregar")[0],
    }
    for criterio, estado in matriz.items():
        if estado not in secciones or not re.search(rf"(?m)^\| {criterio} \|", secciones[estado]):
            errores.append(f"{criterio}: no está en la sección correcta de la checklist")

    for error in errores:
        print("ERROR", error)
    grupos = {}
    for estado in matriz.values():
        grupos[estado] = grupos.get(estado, 0) + 1
    print(f"Criterios: {len(matriz)} {grupos}. Errores: {len(errores)}.")
    return 1 if errores else 0


if __name__ == "__main__":
    sys.exit(main())
