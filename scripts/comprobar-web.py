#!/usr/bin/env python3
"""Comprueba un sitio estático: referencias locales, anclas y archivos sin usar.

Respeta mayúsculas como el sistema de archivos de la imagen. No accede a la red.
Uso: comprobar-web.py DIRECTORIO
"""
import re
import sys
from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import unquote, urlsplit


class Pagina(HTMLParser):
    def __init__(self):
        super().__init__()
        self.ids, self.refs, self.placeholders = set(), [], 0

    def handle_starttag(self, tag, attrs):
        for name, value in attrs:
            if name in ("id", "name") and value:
                self.ids.add(value)
            if name in ("href", "src") and value is not None:
                if value == "#":
                    self.placeholders += 1
                else:
                    self.refs.append(value)


def main(raiz):
    raiz = Path(raiz).resolve()
    errores, usados, paginas = [], set(), {}
    for ruta in sorted(raiz.glob("*.html")):
        pagina = Pagina()
        pagina.feed(ruta.read_text(encoding="utf-8"))
        paginas[ruta.name] = pagina
    # Las rutas de imágenes también se citan desde JavaScript y CSS.
    for ruta in list(raiz.glob("*.js")) + list(raiz.glob("*.css")):
        usados.add(ruta.relative_to(raiz).as_posix())
        for ref in re.findall(r"img/[\w.-]+", ruta.read_text(encoding="utf-8")):
            usados.add(ref)
            if not (raiz / ref).is_file():
                errores.append(f"{ruta.name}: falta {ref}")

    for nombre, pagina in paginas.items():
        usados.add(nombre)
        for ref in pagina.refs:
            partes = urlsplit(ref)
            if partes.scheme or partes.netloc:
                continue
            if partes.path == "/identidad.txt":
                continue  # Lo genera cada contenedor al arrancar.
            destino = unquote(partes.path) or nombre
            if not (raiz / destino).is_file():
                errores.append(f"{nombre}: falta {ref}")
                continue
            usados.add(destino)
            if partes.fragment and destino in paginas:
                if partes.fragment not in paginas[destino].ids:
                    errores.append(f"{nombre}: ancla inexistente {ref}")
        print(f"{nombre}: {len(pagina.refs)} referencias, {pagina.placeholders} enlaces '#'")

    archivos = {p.relative_to(raiz).as_posix() for p in raiz.rglob("*") if p.is_file()}
    sin_usar = sorted(archivos - usados)
    if sin_usar:
        print("Sin referencia estática:", ", ".join(sin_usar))
    for error in errores:
        print("ERROR", error)
    print(f"Resultado: {len(paginas)} páginas, {len(archivos)} archivos, {len(errores)} errores")
    return 1 if errores else 0


if __name__ == "__main__":
    if len(sys.argv) != 2:
        sys.exit("Uso: comprobar-web.py DIRECTORIO")
    sys.exit(main(sys.argv[1]))
