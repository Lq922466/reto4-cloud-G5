#!/usr/bin/env bash
set -euo pipefail

if [[ $# != 2 || ( "$2" != 1.0 && "$2" != 2.0 ) ]]; then
    printf 'Uso: %s IMAGEN VERSION\n' "$0" >&2
    exit 2
fi

app=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
release=$(mktemp -d)
trap 'rm -rf -- "$release"' EXIT
cp -R -- "$app/f1/." "$release/"
if [[ "$2" == 2.0 ]]; then
    cp -- "$app/f1-release/estado-cloud.html" "$release/"
    sed -i 's|<!-- RETO4_CLOUD_RELEASE -->|<p>Versión 2.0 · <a href="estado-cloud.html">Consultar estado de la réplica</a></p>|' "$release/index.html"
else
    sed -i 's|<!-- RETO4_CLOUD_RELEASE -->|<p>Versión 1.0</p>|' "$release/index.html"
fi

bash "$app/construir.sh" "$release" "$1" "$2"
