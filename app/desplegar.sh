#!/usr/bin/env bash
set -euo pipefail
# La primera instalación parte de la imagen 1.0 publicada por el grupo.
if [[ $# != 1 || "$1" != *:1.0 ]]; then
    printf 'Uso: %s CUENTA_DOCKER_HUB/IMAGEN:1.0\n' "$0" >&2
    exit 2
fi
export WEB_IMAGE="$1"
directory=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
docker stack deploy --compose-file "$directory/stack.yml" reto4
