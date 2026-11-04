#!/usr/bin/env bash
set -euo pipefail
# Construye una versión con los archivos estáticos reales de la web F1.
if [[ $# != 3 || ( "$3" != 1.0 && "$3" != 2.0 ) ]]; then
    printf 'Uso: %s DIRECTORIO_WEB IMAGEN VERSION\n' "$0" >&2
    exit 2
fi
test -s "$1/index.html"
app=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
context=$(mktemp -d)
trap 'rm -rf -- "$context"' EXIT
mkdir "$context/sitio"
cp -- "$app/Dockerfile" "$app/40-identidad.sh" "$context/"
cp -R -- "$1/." "$context/sitio/"
docker build --build-arg "WEB_VERSION=$3" --tag "$2:$3" "$context"
