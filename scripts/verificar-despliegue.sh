#!/usr/bin/env bash
set -euo pipefail
export AWS_PAGER=""
# Comprobación de solo lectura del servicio web. Usa las IP públicas actuales de EC2.
# Uso: verificar-despliegue.sh CONFIG_SSH IMAGEN VERSION
if [[ $# != 3 ]]; then
    printf 'Uso: %s CONFIG_SSH IMAGEN VERSION\n' "$0" >&2
    exit 2
fi
config=$1 image=$2 version=$3
remote() { ssh -n -F "$config" -o BatchMode=yes -o StrictHostKeyChecking=yes manager-g5 "$@"; }

hostname
date -Is
printf '\n$ docker node ls; docker service ls; docker service ps\n'
remote 'hostname; docker node ls --format "{{.Hostname}} {{.Status}} {{.Availability}} {{.ManagerStatus}}"'
replicas=$(remote 'docker service ls --filter name=reto4_web --format "{{.Replicas}}"')
spec=$(remote 'docker service inspect --format "{{.Spec.TaskTemplate.ContainerSpec.Image}}" reto4_web')
printf 'reto4_web réplicas=%s imagen=%s\n' "$replicas" "$spec"
[[ "$replicas" == 4/4 ]]
[[ "$spec" == "$image:$version" || "$spec" == "$image:$version@"* ]]
remote 'docker service ps --filter desired-state=running --format "{{.Name}} {{.Image}} {{.Node}} {{.CurrentState}}" reto4_web'

printf '\n$ IP públicas actuales en EC2\n'
mapfile -t ips < <(aws ec2 describe-instances --region us-east-1 \
    --filters 'Name=tag:Name,Values=manager-g5,worker?-g5' 'Name=instance-state-name,Values=running' \
    --query 'Reservations[].Instances[].PublicIpAddress' --output text | tr '\t' '\n')
[[ ${#ips[@]} == 4 ]]
identities=$(mktemp)
trap 'rm -f -- "$identities"' EXIT
for ip in "${ips[@]}"; do
    code=$(curl -s -o /dev/null --max-time 5 -w '%{http_code}' "http://$ip/")
    # Tres peticiones por IP: la malla de enrutamiento reparte entre réplicas.
    for _ in 1 2 3; do
        body=$(curl -fsS --max-time 5 "http://$ip/identidad.txt")
        grep -qx "version=$version" <<< "$body"
        grep '^contenedor=' <<< "$body" >> "$identities"
    done
    printf '%s HTTP %s\n' "$ip" "$code"
    [[ "$code" == 200 ]]
done
printf '\n12 peticiones, todas en versión %s. Respuestas por contenedor:\n' "$version"
sort "$identities" | uniq -c
