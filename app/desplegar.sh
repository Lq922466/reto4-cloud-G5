#!/usr/bin/env bash
set -euo pipefail
# Qué hace: despliega la pila reto4 en Swarm con la imagen 1.0 publicada en Docker Hub.
# Cuándo:   en un manager. Lo llama scripts/desplegar-f1.sh, que además espera y comprueba el resultado.
# Uso:      desplegar.sh CUENTA/IMAGEN:1.0
# Efecto:   MODIFICA el servicio reto4_web, réplica a réplica.
if [[ $# != 1 || "$1" != *:1.0 ]]; then
    printf 'Uso: %s CUENTA_DOCKER_HUB/IMAGEN:1.0\n' "$0" >&2
    exit 2
fi
# stack.yml toma la imagen de esta variable.
export WEB_IMAGE="$1"
directory=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
docker stack deploy --compose-file "$directory/stack.yml" reto4
