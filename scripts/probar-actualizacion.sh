#!/usr/bin/env bash
set -euo pipefail
export AWS_PAGER=""
# Fase 3, E7. Actualiza a 2.0 y vuelve a 1.0 con una sonda independiente por IP.
# REQUIERE AUTORIZACIÓN: modifica el servicio de Swarm. El servicio termina en 1.0.
# Uso: probar-actualizacion.sh CONFIG_SSH CUENTA/REPOSITORIO DIRECTORIO_REGISTROS
if [[ $# != 3 ]]; then
    printf 'Uso: %s CONFIG_SSH CUENTA/REPOSITORIO DIRECTORIO_REGISTROS\n' "$0" >&2
    exit 2
fi
config=$1 target=$2 logs=$3
root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
remote() { ssh -n -F "$config" -o BatchMode=yes -o StrictHostKeyChecking=yes manager-g5 "$@"; }
source "$root/scripts/lib-sondas.sh"

iniciar_sondas
hostname
date -Is
sleep 5
printf '\n$ [manager-g5] docker service update --image %s:2.0 reto4_web\n' "$target"
remote "docker service update --quiet --detach=false --image '$target:2.0' reto4_web" >/dev/null
date -Is
sleep 5
bash "$root/scripts/verificar-despliegue.sh" "$config" "$target" 2.0
probar_navegador actualizada-2.0 2.0

printf '\n$ [manager-g5] docker service rollback reto4_web\n'
remote 'docker service rollback --quiet --detach=false reto4_web' >/dev/null
date -Is
sleep 5
bash "$root/scripts/verificar-despliegue.sh" "$config" "$target" 1.0
probar_navegador rollback-1.0 1.0
resumir_sondas
