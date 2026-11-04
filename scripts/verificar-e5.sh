#!/usr/bin/env bash
set -euo pipefail
umask 077
export AWS_PAGER=""
# Ejecutar desde la raíz del worktree operativo, antes o después de E5.
if [[ $# != 1 ]]; then
    printf 'Uso: %s DIRECTORIO_PRIVADO_DE_RESPALDO\n' "$0" >&2
    exit 2
fi
backup=$1
jq -e -s '
    length == 2 and .[0].lineage == .[1].lineage and .[0].serial == .[1].serial
' "$backup/terraform.tfstate" <(terraform -chdir=terraform state pull) >/dev/null
account=$(aws sts get-caller-identity --query Account --output text)
[[ "$account" == "$(cat "$backup/aws-account.txt")" ]] || {
    printf 'La cuenta AWS difiere de la registrada antes de E5.\n' >&2
    exit 1
}

nodes=$(terraform -chdir=terraform output -json nodes)
mapfile -t ids < <(jq -r '.[].id' <<< "$nodes")
[[ ${#ids[@]} == 4 ]]
hostname
date -Is
printf '\n$ aws ec2 describe-instance-status (us-east-1)\n'
health=$(aws ec2 describe-instance-status --region us-east-1 --include-all-instances \
    --instance-ids "${ids[@]}" --output json)
jq -r '.InstanceStatuses[] | [.InstanceId,.InstanceState.Name,.SystemStatus.Status,.InstanceStatus.Status] | @tsv' <<< "$health"
jq -e '[.InstanceStatuses[] | select(.InstanceState.Name=="running" and
    .SystemStatus.Status=="ok" and .InstanceStatus.Status=="ok")] | length == 4' <<< "$health" >/dev/null

printf '\n$ aws ec2 describe-instances (direcciones actuales)\n'
live=$(aws ec2 describe-instances --region us-east-1 --instance-ids "${ids[@]}" --output json)
jq -e --argjson nodes "$nodes" '
    [.Reservations[].Instances[]] as $live |
    all($nodes[]; . as $n | any($live[]; .InstanceId==$n.id and
        .PrivateIpAddress==$n.private_ip and (.PublicIpAddress | type=="string")))
' <<< "$live" >/dev/null
jq -r '.Reservations[].Instances[] | [.InstanceId,.PrivateIpAddress,.PublicIpAddress] | @tsv' <<< "$live"

manager_id=$(jq -er '."manager-g5".id' <<< "$nodes")
manager_ip=$(jq -er --arg id "$manager_id" '.Reservations[].Instances[] | select(.InstanceId==$id) | .PublicIpAddress' <<< "$live")
config=$(mktemp)
trap 'rm -f -- "$config"' EXIT
python3 - "$backup/ssh.local" "$config" "$manager_ip" <<'PY'
import ipaddress
import re
import sys
from pathlib import Path

source, target, ip = sys.argv[1:]
ip = str(ipaddress.IPv4Address(ip))
text, count = re.subn(r"(?m)(^Host manager-g5\n    HostName )\S+", lambda m: m[1] + ip, Path(source).read_text())
assert count == 1
Path(target).write_text(text)
PY

remote() { ssh -n -F "$config" -o StrictHostKeyChecking=yes -o ConnectTimeout=8 "$@"; }
for node in manager-g5 worker{1..3}-g5; do
    printf '\n$ ssh %s (identidad y estado local de Swarm)\n' "$node"
    remote "$node" 'hostname; date -Is; docker info --format "{{.Swarm.LocalNodeState}} {{.Swarm.ControlAvailable}}"'
done
# La elección de líder puede cambiar después del reinicio. Usar un manager alcanzable.
manager=manager-g5
printf '\n$ docker node ls; docker network inspect; docker service ls; docker service ps\n'
status=$(remote "$manager" 'docker node ls --format "{{.Hostname}} {{.Status}} {{.Availability}} {{.ManagerStatus}}"')
printf '%s\n' "$status"
[[ $(grep -c ' Ready Active' <<< "$status") == 4 ]]
[[ $(grep -Ec ' (Reachable|Leader)$' <<< "$status") == 3 ]]
[[ $(grep -c ' Leader$' <<< "$status") == 1 ]]
networks=$(remote "$manager" 'docker network inspect --format "{{.Name}} {{.Driver}} ingress={{.Ingress}} MTU={{index .Options \"com.docker.network.driver.mtu\"}}" red-g5 red-app-g5')
printf '%s\n' "$networks"
grep -qx 'red-g5 overlay ingress=true MTU=1450' <<< "$networks"
grep -qx 'red-app-g5 overlay ingress=false MTU=1450' <<< "$networks"
replicas=$(remote "$manager" 'docker service ls --filter name=reto4_web --format "{{.Replicas}}"')
printf 'reto4_web %s\n' "$replicas"
[[ "$replicas" == 4/4 ]]
remote "$manager" 'docker service ps --filter desired-state=running reto4_web'
while IFS= read -r ip; do
    printf '\n$ curl http://%s/identidad.txt\n' "$ip"
    date -Is
    curl -fsS --max-time 5 "http://$ip/identidad.txt"
done < <(jq -r '.Reservations[].Instances[].PublicIpAddress' <<< "$live")
