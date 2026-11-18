#!/usr/bin/env bash
set -euo pipefail
# Fase 1. Publica en Docker Hub las imágenes construidas por preparar-imagenes.sh.
# REQUIERE AUTORIZACIÓN. La sesión de Docker Hub se abre antes, de forma
# interactiva, y este script la cierra siempre al terminar.
# Uso: publicar-imagenes.sh CONFIG_SSH CUENTA/REPOSITORIO
if [[ $# != 2 || ! "$2" =~ ^[a-z0-9][a-z0-9._-]*/[a-z0-9][a-z0-9._-]*$ ]]; then
    printf 'Uso: %s CONFIG_SSH CUENTA/REPOSITORIO\n' "$0" >&2
    exit 2
fi
config=$1 target=$2 local_image=reto4-g5/f1-definitiva
remote() { ssh -n -F "$config" -o BatchMode=yes -o StrictHostKeyChecking=yes manager-g5 "$@"; }
# Solo comprueba si existe la entrada de Docker Hub. No lee ni muestra el token.
session() { remote 'grep -c "index.docker.io" ~/.docker/config.json 2>/dev/null || true'; }
logout_hub() { remote docker logout >/dev/null || true; }

hostname
date -Is
if [[ $(session) == 0 || -z $(session) ]]; then
    printf 'No hay sesión de Docker Hub en manager-g5.\n' >&2
    exit 1
fi
trap logout_hub EXIT
for version in 1.0 2.0; do
    printf '\n$ [manager-g5] docker tag %s:%s %s:%s\n' "$local_image" "$version" "$target" "$version"
    remote "docker tag '$local_image:$version' '$target:$version'"
    printf '$ [manager-g5] docker push %s:%s\n' "$target" "$version"
    remote "docker push '$target:$version'" | tail -n 1
    remote "docker image inspect --format '{{json .RepoDigests}}' '$target:$version'"
done
logout_hub
trap - EXIT
printf '\n$ [manager-g5] docker logout\n'
printf 'Entradas de Docker Hub tras cerrar la sesión: %s\n' "$(session)"
[[ $(session) == 0 || -z $(session) ]]
