#!/usr/bin/env bash
set -euo pipefail
# Qué hace: construye la imagen de una versión a partir de archivos estáticos.
# Uso:      construir.sh DIRECTORIO_WEB IMAGEN 1.0|2.0
# Efecto:   crea una imagen local. Rechaza enlaces simbólicos y archivos que parezcan sensibles.
if [[ $# != 3 || ( "$3" != 1.0 && "$3" != 2.0 ) ]]; then
    printf 'Uso: %s DIRECTORIO_WEB IMAGEN VERSION\n' "$0" >&2
    exit 2
fi
# Comprueba que el directorio contiene una web.
source=$(cd -- "$1" && pwd -P)
test -s "$source/index.html"
# El contenido de sitio se sirve públicamente. Usar solo una exportación estática.
blocked=$(find "$source" \( -type l -o -name .git -o -name '.env*' -o -name .aws \
    -o -name .ssh -o -name .npmrc -o -name credentials -o -iname '*.pem' \
    -o -iname '*.key' -o -iname '*.tfstate*' -o -iname '*.tfplan' \) -print -quit)
if [[ -n "$blocked" ]]; then
    printf 'La exportación contiene archivos excluidos o enlaces simbólicos.\n' >&2
    exit 1
fi
# El contexto de construcción es temporal y solo contiene lo necesario.
app=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
context=$(mktemp -d)
trap 'rm -rf -- "$context"' EXIT
mkdir "$context/sitio"
cp -- "$app/Dockerfile" "$app/40-identidad.sh" "$context/"
cp -R -- "$source/." "$context/sitio/"
docker build --build-arg "WEB_VERSION=$3" --tag "$2:$3" "$context"
