#!/usr/bin/env bash
set -euo pipefail
# Ejecutar en el manager antes de publicar el primer servicio.
if [[ $(docker info --format '{{.Swarm.ControlAvailable}}') != true ]]; then
    printf 'Ejecutar en un manager de Swarm.\n' >&2
    exit 1
fi
if docker network inspect red-g5 >/dev/null 2>&1; then
    actual=$(docker network inspect --format '{{.Driver}} {{.Ingress}} {{index .Options "com.docker.network.driver.mtu"}}' red-g5)
    if [[ "$actual" != 'overlay true 1450' ]]; then
        printf 'red-g5 ya existe con una configuración distinta: %s\n' "$actual" >&2
        exit 1
    fi
else
    if [[ -n $(docker service ls -q) ]]; then
        printf 'Configurar la red ingress antes de desplegar servicios.\n' >&2
        exit 1
    fi
    if docker network inspect ingress >/dev/null 2>&1; then
        printf 'y\n' | docker network rm ingress
    fi
    docker network create --driver overlay --ingress \
        --opt com.docker.network.driver.mtu=1450 red-g5
fi
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
