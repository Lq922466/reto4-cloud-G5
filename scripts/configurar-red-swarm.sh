#!/usr/bin/env bash
set -euo pipefail
# Qué hace: crea las redes overlay del grupo: red-g5 (ingress) y red-app-g5, ambas con MTU 1450.
# Cuándo:   en el manager, antes de publicar el primer servicio. Lo llama formar-swarm.sh.
# Efecto:   MODIFICA las redes de Swarm. Si ya existen correctas, no las toca.
# Solo un manager puede crear redes de Swarm.
if [[ $(docker info --format '{{.Swarm.ControlAvailable}}') != true ]]; then
    printf 'Ejecutar en un manager de Swarm.\n' >&2
    exit 1
fi
# red-g5 sustituye a la red ingress por defecto. La MTU 1450 deja sitio a los 50 bytes de la
# encapsulación overlay, para que los paquetes no se fragmenten en una red física de 1500.
if docker network inspect red-g5 >/dev/null 2>&1; then
    actual=$(docker network inspect --format '{{.Driver}} {{.Ingress}} {{index .Options "com.docker.network.driver.mtu"}}' red-g5)
    if [[ "$actual" != 'overlay true 1450' ]]; then
        printf 'red-g5 ya existe con una configuración distinta: %s\n' "$actual" >&2
        exit 1
    fi
else
    # La red ingress no se puede cambiar mientras haya servicios publicados.
    if [[ -n $(docker service ls -q) ]]; then
        printf 'Configurar la red ingress antes de desplegar servicios.\n' >&2
        exit 1
    fi
    if docker network inspect ingress >/dev/null 2>&1; then
        # Docker pide confirmación al retirar la red ingress, y aquí se responde de forma automática.
        printf 'y\n' | docker network rm ingress
    fi
    docker network create --driver overlay --ingress \
        --opt com.docker.network.driver.mtu=1450 red-g5
fi
# red-app-g5 es la red overlay propia a la que se conecta el servicio web.
if docker network inspect red-app-g5 >/dev/null 2>&1; then
    actual=$(docker network inspect --format '{{.Driver}} {{.Ingress}} {{index .Options "com.docker.network.driver.mtu"}}' red-app-g5)
    if [[ "$actual" != 'overlay false 1450' ]]; then
        printf 'red-app-g5 ya existe con una configuración distinta: %s\n' "$actual" >&2
        exit 1
    fi
else
    docker network create --driver overlay \
        --opt com.docker.network.driver.mtu=1450 red-app-g5
fi
