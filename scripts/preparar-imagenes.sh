#!/usr/bin/env bash
set -euo pipefail
# Construye las versiones 1.0 y 2.0 en un nodo con Docker y las prueba en
# contenedores temporales sin puertos publicados. No modifica servicios de Swarm.
# Uso: preparar-imagenes.sh CONFIG_SSH NODO IMAGEN
if [[ $# != 3 ]]; then
    printf 'Uso: %s CONFIG_SSH NODO IMAGEN\n' "$0" >&2
    exit 2
fi
config=$1 node=$2 image=$3
root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
remote() { ssh -F "$config" -o BatchMode=yes -o StrictHostKeyChecking=yes "$node" "$@"; }

hostname
date -Is
git -C "$root" log -1 --format='Commit de partida: %h %s'
python3 "$root/scripts/comprobar-web.py" "$root/app/f1"

workdir=$(remote mktemp -d)
cleanup() { remote "rm -rf -- '$workdir'" || true; }
trap cleanup EXIT
tar -C "$root" -cf - app/Dockerfile app/40-identidad.sh app/construir.sh \
    app/construir-f1.sh app/f1 app/f1-release | remote "tar -C '$workdir' -xf -"

for version in 1.0 2.0; do
    printf '\n$ [%s] bash app/construir-f1.sh %s %s\n' "$node" "$image" "$version"
    remote "cd '$workdir' && bash app/construir-f1.sh '$image' '$version'" 2>&1 | tail -n 4
    printf '\n$ [%s] prueba de %s:%s\n' "$node" "$image" "$version"
    remote bash -s -- "$image:$version" "$version" <<'REMOTE'
set -euo pipefail
image=$1 version=$2
name=reto4-prueba-$version
trap 'docker rm -f "$name" >/dev/null 2>&1 || true' EXIT
hostname; date -Is
docker run -d --name "$name" --network bridge "$image" >/dev/null
for _ in $(seq 1 30); do
    health=$(docker inspect --format '{{.State.Health.Status}}' "$name")
    [[ "$health" == healthy ]] && break
    sleep 1
done
printf 'healthcheck=%s\n' "$health"
[[ "$health" == healthy ]]
ip=$(docker inspect --format '{{.NetworkSettings.Networks.bridge.IPAddress}}' "$name")
get() { curl -fsS --max-time 5 "http://$ip/$1"; }
identity=$(get identidad.txt)
printf '%s\n' "$identity"
grep -qx "version=$version" <<< "$identity"
for page in index.html entradas.html sorteo.html contacto.html acceso.html app.js style.css img/logo_f1_bilbao.PNG; do
    printf '%s %s\n' "$(curl -s -o /dev/null --max-time 5 -w '%{http_code}' "http://$ip/$page")" "$page"
    get "$page" >/dev/null
done
get index.html | grep -F "Versión $version"
# La página de estado solo existe a partir de 2.0.
status=$(curl -s -o /dev/null --max-time 5 -w '%{http_code}' "http://$ip/estado-cloud.html")
printf '%s estado-cloud.html\n' "$status"
if [[ "$version" == 2.0 ]]; then [[ "$status" == 200 ]]; else [[ "$status" == 404 ]]; fi
docker exec "$name" sh -c 'stat -c "%a %U %n" /usr/share/nginx/html/index.html /usr/share/nginx/html/img; find /usr/share/nginx/html -type f | wc -l'
docker image inspect --format 'imagen={{.Id}} tamaño={{.Size}}' "$image"
REMOTE
done
printf '\n$ [%s] docker ps -a --filter name=reto4-prueba\n' "$node"
remote 'docker ps -a --filter name=reto4-prueba --format "{{.Names}}"'
printf '$ [%s] docker service ls\n' "$node"
remote 'docker service ls --format "{{.Name}} {{.Replicas}} {{.Image}}"'
