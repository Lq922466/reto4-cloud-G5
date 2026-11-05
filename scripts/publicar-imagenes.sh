#!/usr/bin/env bash
set -euo pipefail
# Publica en Docker Hub las imágenes construidas por preparar-imagenes.sh.
# REQUIERE AUTORIZACIÓN. La sesión de Docker Hub se abre antes, de forma
# interactiva, y este script la cierra siempre al terminar.
# Uso: publicar-imagenes.sh CONFIG_SSH CUENTA/REPOSITORIO
if [[ $# != 2 || "$2" != */* ]]; then
    printf 'Uso: %s CONFIG_SSH CUENTA/REPOSITORIO\n' "$0" >&2
    exit 2
fi
config=$1 target=$2 local_image=reto4-g5/f1-definitiva
remote() { ssh -n -F "$config" -o BatchMode=yes -o StrictHostKeyChecking=yes "$@"; }
trap 'remote manager-g5 docker logout >/dev/null || true' EXIT

hostname
date -Is
for version in 1.0 2.0; do
    printf '\n$ [manager-g5] docker tag y docker push %s:%s\n' "$target" "$version"
    remote manager-g5 "docker tag '$local_image:$version' '$target:$version' && docker push '$target:$version'" | tail -n 1
done
remote manager-g5 docker logout

# Una descarga anónima desde un worker confirma que Swarm podrá obtenerlas.
for version in 1.0 2.0; do
    printf '\n$ [worker3-g5] docker pull %s:%s (sin sesión de Docker Hub)\n' "$target" "$version"
    remote worker3-g5 "docker pull -q '$target:$version' && docker image inspect --format '{{index .RepoDigests 0}}' '$target:$version' && docker run --rm --entrypoint cat '$target:$version' /etc/reto4-version"
done
