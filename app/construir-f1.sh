#!/usr/bin/env bash
set -euo pipefail
# Qué hace: prepara la versión 1.0 o 2.0 de la web definitiva y construye su imagen.
# Cuándo:   en un nodo con Docker. Lo llama scripts/preparar-imagenes.sh.
# Uso:      construir-f1.sh IMAGEN 1.0|2.0
# Efecto:   crea una imagen local en ese nodo. No publica nada ni cambia el servicio.

if [[ $# != 2 || ( "$2" != 1.0 && "$2" != 2.0 ) ]]; then
    printf 'Uso: %s IMAGEN VERSION\n' "$0" >&2
    exit 2
fi

app=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
# Se trabaja en una copia temporal, para no modificar app/f1.
release=$(mktemp -d)
trap 'rm -rf -- "$release"' EXIT
cp -R -- "$app/f1/." "$release/"
# La versión 2.0 añade la página de estado de la réplica. Ambas muestran su versión en la portada.
if [[ "$2" == 2.0 ]]; then
    cp -- "$app/f1-release/estado-cloud.html" "$release/"
    sed -i 's|<!-- RETO4_CLOUD_RELEASE -->|<p>Versión 2.0 · <a href="estado-cloud.html">Consultar estado de la réplica</a></p>|' "$release/index.html"
else
    sed -i 's|<!-- RETO4_CLOUD_RELEASE -->|<p>Versión 1.0</p>|' "$release/index.html"
fi

# El constructor común revisa el contenido y crea la imagen.
bash "$app/construir.sh" "$release" "$1" "$2"
