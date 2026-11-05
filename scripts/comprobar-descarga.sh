#!/usr/bin/env bash
set -euo pipefail
# Fase 2. Descarga ambas etiquetas en los workers sin sesión de Docker Hub y las
# compara con las imágenes construidas en manager-g5. No modifica servicios.
# Uso: comprobar-descarga.sh CONFIG_SSH CUENTA/REPOSITORIO
if [[ $# != 2 ]]; then
    printf 'Uso: %s CONFIG_SSH CUENTA/REPOSITORIO\n' "$0" >&2
    exit 2
fi
config=$1 target=$2 local_image=reto4-g5/f1-definitiva
remote() { local node=$1; shift; ssh -n -F "$config" -o BatchMode=yes -o StrictHostKeyChecking=yes "$node" "$@"; }
# Huella del contenido servido. identidad.txt no entra: se genera al arrancar.
content='cd /usr/share/nginx/html && find . -type f | sort | xargs sha256sum | sha256sum | cut -d" " -f1'
fingerprint() { remote "$1" "docker run --rm --entrypoint sh '$2' -c '$content'"; }

hostname
date -Is
status=0
for version in 1.0 2.0; do
    reference=$(fingerprint manager-g5 "$local_image:$version")
    digest=$(remote manager-g5 "docker image inspect --format '{{index .RepoDigests 0}}' '$target:$version'")
    printf '\nVersión %s\nConstruida en manager-g5: contenido=%s\nPublicada: %s\n' "$version" "$reference" "$digest"
    for node in worker1-g5 worker2-g5 worker3-g5; do
        printf '$ [%s] docker pull %s:%s\n' "$node" "$target" "$version"
        remote "$node" "docker pull -q '$target:$version'"
        pulled=$(remote "$node" "docker image inspect --format '{{index .RepoDigests 0}}' '$target:$version'")
        found=$(remote "$node" "docker run --rm --entrypoint cat '$target:$version' /etc/reto4-version")
        actual=$(fingerprint "$node" "$target:$version")
        printf '%s %s contenido=%s\n' "$pulled" "$found" "$actual"
        if [[ "$pulled" != "$digest" || "$found" != "version=$version" || "$actual" != "$reference" ]]; then
            printf 'ERROR: %s no coincide con la versión %s publicada.\n' "$node" "$version"
            status=1
        fi
    done
done
printf '\n$ [manager-g5] docker service ls\n'
remote manager-g5 'docker service ls --format "{{.Name}} {{.Replicas}} {{.Image}}"'
exit "$status"
