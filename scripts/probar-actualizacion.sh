#!/usr/bin/env bash
set -euo pipefail
export AWS_PAGER=""
# E7: actualiza a 2.0 y vuelve a 1.0 con una sonda independiente por cada IP pública.
# REQUIERE AUTORIZACIÓN: modifica el servicio de Swarm. El servicio termina en 1.0.
# Uso: probar-actualizacion.sh CONFIG_SSH CUENTA/REPOSITORIO DIRECTORIO_REGISTROS
if [[ $# != 3 ]]; then
    printf 'Uso: %s CONFIG_SSH CUENTA/REPOSITORIO DIRECTORIO_REGISTROS\n' "$0" >&2
    exit 2
fi
config=$1 target=$2 logs=$3
root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
remote() { ssh -n -F "$config" -o BatchMode=yes -o StrictHostKeyChecking=yes manager-g5 "$@"; }
mkdir -p "$logs"

mapfile -t ips < <(aws ec2 describe-instances --region us-east-1 \
    --filters 'Name=tag:Name,Values=manager-g5,worker?-g5' 'Name=instance-state-name,Values=running' \
    --query 'Reservations[].Instances[].PublicIpAddress' --output text | tr '\t' '\n')
[[ ${#ips[@]} == 4 ]]
probes=()
stop_probes() { ((${#probes[@]})) && kill "${probes[@]}" 2>/dev/null || true; }
trap stop_probes EXIT
for ip in "${ips[@]}"; do
    bash "$root/scripts/sondear-web.sh" "http://$ip/identidad.txt" > "$logs/sonda-$ip.txt" &
    probes+=("$!")
done

hostname
date -Is
sleep 5
printf '\n$ [manager-g5] docker service update --image %s:2.0 reto4_web\n' "$target"
remote "docker service update --quiet --detach=false --image '$target:2.0' reto4_web" >/dev/null
date -Is
sleep 5
bash "$root/scripts/verificar-despliegue.sh" "$config" "$target" 2.0

printf '\n$ [manager-g5] docker service rollback reto4_web\n'
remote 'docker service rollback --quiet --detach=false reto4_web' >/dev/null
date -Is
sleep 5
bash "$root/scripts/verificar-despliegue.sh" "$config" "$target" 1.0
stop_probes
wait 2>/dev/null || true

printf '\nResumen de las sondas (una petición por segundo y por IP):\n'
for ip in "${ips[@]}"; do
    file="$logs/sonda-$ip.txt"
    printf '%s OK=%s FALLO=%s versión 1.0=%s versión 2.0=%s\n' "$ip" \
        "$(grep -c ' OK ' "$file" || true)" "$(grep -c ' FALLO' "$file" || true)" \
        "$(grep -c 'version=1.0' "$file" || true)" "$(grep -c 'version=2.0' "$file" || true)"
done
