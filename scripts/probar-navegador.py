#!/usr/bin/env python3
"""Recorre la web F1 en Chromium y comprueba lo que recibe el visitante.

Falla si hay errores de JavaScript, recursos locales que no cargan, imágenes
rotas, formularios que envían datos o una versión distinta de la esperada.
Requiere el paquete playwright. Uso: probar-navegador.py URL VERSION [CAPTURA.png]
"""
import sys
from urllib.parse import urljoin, urlsplit

from playwright.sync_api import sync_playwright

PAGINAS = ["index.html", "entradas.html", "sorteo.html", "contacto.html", "acceso.html"]


def probar(base, version, captura):
    errores = []
    origen = urlsplit(base).netloc
    with sync_playwright() as p:
        navegador = p.chromium.launch()
        pagina = navegador.new_page(viewport={"width": 1280, "height": 900})
        pagina.on("pageerror", lambda e: errores.append(f"JS: {e}"))
        pagina.on("dialog", lambda d: d.dismiss())
        pagina.on(
            "requestfailed",
            lambda r: urlsplit(r.url).netloc == origen and errores.append(f"Fallo: {r.url}"),
        )
        pagina.on(
            "response",
            lambda r: urlsplit(r.url).netloc == origen and r.status >= 400
            and errores.append(f"HTTP {r.status}: {r.url}"),
        )
        envios = []
        pagina.on("request", lambda r: r.method != "GET" and envios.append(r.url))

        rutas = PAGINAS + (["estado-cloud.html"] if version == "2.0" else [])
        for ruta in rutas:
            pagina.goto(urljoin(base, ruta), wait_until="networkidle")
            rotas = pagina.evaluate(
                "[...document.images].filter(i => !i.complete || !i.naturalWidth).map(i => i.src)"
            )
            errores.extend(f"Imagen rota en {ruta}: {src}" for src in rotas)
            print(f"{ruta}: título «{pagina.title()}», {pagina.evaluate('document.images.length')} imágenes")

        pagina.goto(urljoin(base, "index.html"), wait_until="networkidle")
        if f"Versión {version}" not in pagina.inner_text("body"):
            errores.append(f"La portada no muestra Versión {version}")
        for ancla in ("circuito", "horarios", "escuderias"):
            if pagina.locator(f'a[href="#{ancla}"]').count() != 1 or pagina.locator(f"#{ancla}").count() != 1:
                errores.append(f"Menú sin destino #{ancla}")

        pagina.goto(urljoin(base, "sorteo.html"), wait_until="networkidle")
        for indice, selector in enumerate(("#piloto1", "#piloto2", "#piloto3")):
            pagina.select_option(selector, index=indice + 1)
        pagina.click("#btnComprobarSorteo")
        if "Aciertos" not in pagina.inner_text("#resultadoSorteoContainer"):
            errores.append("El sorteo no devolvió resultado")

        pagina.goto(urljoin(base, "entradas.html"), wait_until="networkidle")
        pagina.click("#calcularPrecio")
        print("Precio calculado:", pagina.input_value("#precio"))
        pagina.check("#aceptaCondiciones")
        pagina.click("#btnComprar")
        if envios:
            errores.append(f"Se enviaron datos: {envios}")

        if version == "2.0":
            pagina.goto(urljoin(base, "estado-cloud.html"), wait_until="networkidle")
            estado = pagina.inner_text("#identidad")
            print("Estado de réplica:", " ".join(estado.split()))
            if "version=2.0" not in estado:
                errores.append("estado-cloud.html no muestra la versión 2.0")

        if captura:
            pagina.goto(urljoin(base, "index.html"), wait_until="networkidle")
            pagina.locator("aside[aria-label='Información de despliegue']").scroll_into_view_if_needed()
            pagina.screenshot(path=captura, full_page=False)
        navegador.close()

    for error in errores:
        print("ERROR", error)
    print(f"Resultado {base} versión {version}: {len(rutas)} páginas, {len(errores)} errores")
    return 1 if errores else 0


if __name__ == "__main__":
    if len(sys.argv) not in (3, 4):
        sys.exit(__doc__)
    sys.exit(probar(sys.argv[1], sys.argv[2], sys.argv[3] if len(sys.argv) == 4 else None))
