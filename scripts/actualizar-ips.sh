#!/usr/bin/env bash
set -euo pipefail
export AWS_PAGER=""
# Qué hace: lee de EC2 las IP actuales de los cuatro nodos y regenera la configuración SSH.
# Cuándo:   cada vez que se reinicia Learner Lab o se detiene y arranca una instancia, porque
#           las IP públicas cambian. Las privadas no cambian y Swarm las sigue usando.
# Efecto:   en AWS solo lee. Escribe config/ssh.local y config/ssh_config.aplicado.
# Salida:   0 si todo va bien, 3 si AWS deniega la consulta (sesión del laboratorio terminada o
#           credenciales antiguas), 1 si no están los cuatro nodos en ejecución.
root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
source "$root/scripts/lib-ssh-config.sh"
destination="$root/config/ssh.local"

# Se usa un archivo aparte para no mezclar el error de AWS, que incluye datos de la cuenta, con la salida.
errors=$(mktemp)
trap 'rm -f -- "$errors"' EXIT
if ! ec2=$(aws ec2 describe-instances --region us-east-1 \
    --filters 'Name=tag:Name,Values=manager-g5,worker?-g5' 'Name=instance-state-name,Values=running' \
    --output json 2> "$errors"); then
    printf 'AWS no permite consultar EC2. Iniciar Learner Lab y renovar ~/.aws/credentials.\n' >&2
    exit 3
fi

# Se pasa la respuesta de EC2 a la misma forma que la salida «nodes» de Terraform.
nodes=$(jq '[.Reservations[].Instances[] | {
    key: (.Tags[] | select(.Key == "Name").Value),
    value: {id: .InstanceId, public_ip: .PublicIpAddress, private_ip: .PrivateIpAddress}
}] | from_entries' <<< "$ec2")

if [[ $(jq 'length' <<< "$nodes") != 4 ]]; then
    printf 'Se esperaban 4 nodos en ejecución y hay %s.\n' "$(jq 'length' <<< "$nodes")" >&2
    exit 1
fi

previous=$(awk '/^Host manager-g5$/ { getline; print $2; exit }' "$destination" 2>/dev/null || true)
escribir_config_ssh "$root" "$nodes" "$destination"
cp -- "$destination" "$root/config/ssh_config.aplicado"

jq -r 'to_entries | sort_by(.key)[] | [.key, .value.id, .value.private_ip, .value.public_ip] | @tsv' <<< "$nodes"
current=$(jq -r '."manager-g5".public_ip' <<< "$nodes")
if [[ -n "$previous" && "$previous" != "$current" ]]; then
    printf 'La IP pública de manager-g5 ha cambiado: %s → %s\n' "$previous" "$current"
fi
printf 'Configuración actualizada: %s\n' "$destination"
