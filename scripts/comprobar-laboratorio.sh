#!/usr/bin/env bash
set -uo pipefail
export AWS_PAGER=""
# Qué hace: comprueba el laboratorio al reactivarlo: las cuatro EC2, sus IP, la regla SSH, la web
#           y la conectividad. Si la regla SSH no coincide con la IP del Codespace, muestra los
#           comandos exactos para corregirla, SIN EJECUTARLOS.
# Cuándo:   lo primero tras iniciar Learner Lab y renovar ~/.aws/credentials.
# Efecto:   solo lectura, en AWS y en los nodos. No cambia nada.
# Salida:   0 si todo está correcto, 2 si falta corregir algo, 3 si AWS deniega la consulta.
root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
region=us-east-1
group_name=reto4-cloud-g5
status=0

# Nodos esperados: nombre, ID de instancia e IP privada, que no cambian al reiniciar.
expected="manager-g5 i-0e6ebf2af63facc60 172.31.28.10
worker1-g5 i-066a1ad3b7a8e0db9 172.31.17.168
worker2-g5 i-0ed6d9c9957251a18 172.31.29.192
worker3-g5 i-0446409b26cf0a662 172.31.31.183"

# Oculta los identificadores de cuenta y de sesión que incluyen los errores de AWS.
ocultar() { sed -E 's/[0-9]{12}/************/g; s/user[0-9]{6,}=[^ ,"]*/USUARIO/g; s/arn:aws:[a-z]+:[^ ,]*/[identificador oculto]/g'; }

printf 'Máquina: %s. Hora: %s\n' "$(hostname)" "$(date -Is)"
my_ip=$(curl -s --max-time 5 https://checkip.amazonaws.com)
printf 'IP pública actual del Codespace: %s\n' "$my_ip"

printf '\n1. Instancias EC2\n'
if ! ec2=$(aws ec2 describe-instances --region "$region" \
    --filters 'Name=tag:Name,Values=manager-g5,worker?-g5' --output json 2>&1); then
    printf '%s\n' "$ec2" | ocultar | cut -c1-160
    printf 'AWS deniega la consulta. Iniciar Learner Lab y renovar ~/.aws/credentials.\n'
    exit 3
fi
ids=$(jq -r '[.Reservations[].Instances[].InstanceId] | join(" ")' <<< "$ec2")
checks=$(aws ec2 describe-instance-status --region "$region" --include-all-instances \
    --instance-ids $ids --output json 2>/dev/null || printf '{"InstanceStatuses":[]}')
ips=()
while read -r name id private; do
    line=$(jq -r --arg n "$name" '.Reservations[].Instances[]
        | select(any(.Tags[]; .Key == "Name" and .Value == $n))
        | [.InstanceId, .State.Name, .PrivateIpAddress, (.PublicIpAddress // "-")] | @tsv' <<< "$ec2")
    read -r real_id state real_private public <<< "$line"
    health=$(jq -r --arg i "${real_id:-}" '.InstanceStatuses[] | select(.InstanceId == $i)
        | .SystemStatus.Status + "/" + .InstanceStatus.Status' <<< "$checks")
    note=correcto
    if [[ "${real_id:-}" != "$id" || "${real_private:-}" != "$private" ]]; then
        note="NO COINCIDE: se esperaba $id y $private"
        status=2
    elif [[ "$state" != running || "$health" != ok/ok ]]; then
        note="aún no está lista"
        status=2
    fi
    printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' "$name" "${real_id:--}" "${state:--}" "${health:--}" "${real_private:--}" "${public:--}" "$note"
    if [[ -n "${public:-}" && "${public:-}" != - ]]; then
        ips+=("$public")
    fi
    if [[ "$name" == manager-g5 ]]; then
        manager_ip=${public:--}
    fi
done <<< "$expected"

printf '\n2. Regla SSH del grupo de seguridad %s\n' "$group_name"
sg=$(aws ec2 describe-security-groups --region "$region" --filters "Name=group-name,Values=$group_name" --output json 2>/dev/null)
group_id=$(jq -r '.SecurityGroups[0].GroupId // empty' <<< "$sg")
mapfile -t current < <(jq -r '.SecurityGroups[0].IpPermissions[]? | select(.FromPort == 22) | .IpRanges[].CidrIp' <<< "$sg")
printf 'Grupo: %s. Origen SSH actual: %s\n' "${group_id:--}" "${current[*]:-ninguno}"
wanted="$my_ip/32"
if [[ " ${current[*]:-} " == *" $wanted "* && ${#current[@]} == 1 ]]; then
    printf 'La regla ya coincide con la IP del Codespace: %s\n' "$wanted"
else
    status=2
    printf 'La regla debe limitarse a %s. Comandos propuestos, que NO se han ejecutado y requieren autorización:\n\n' "$wanted"
    printf '  aws ec2 authorize-security-group-ingress --region %s --group-id %s --protocol tcp --port 22 --cidr %s\n' "$region" "$group_id" "$wanted"
    for old in "${current[@]:-}"; do
        if [[ -n "$old" && "$old" != "$wanted" ]]; then
            printf '  aws ec2 revoke-security-group-ingress --region %s --group-id %s --protocol tcp --port 22 --cidr %s\n' "$region" "$group_id" "$old"
        fi
    done
    printf '\nDespués, los planes de Terraform deben usar: -var ssh_cidr=%s\n' "$wanted"
fi

printf '\n3. Web por las IP públicas\n'
for ip in "${ips[@]:-}"; do
    [[ -n "$ip" ]] || continue
    code=$(curl -s -o /dev/null --max-time 6 -w '%{http_code}' "http://$ip/")
    printf '%s HTTP %s %s\n' "$ip" "$code" "$(curl -s --max-time 6 "http://$ip/identidad.txt" | tr '\n' ' ')"
    [[ "$code" == 200 ]] || status=2
done

printf '\n4. SSH y Swarm, sin cambiar nada\n'
config="$root/config/ssh.local"
if [[ "${manager_ip:--}" == - ]]; then
    printf 'manager-g5 no tiene IP pública: no se puede comprobar SSH.\n'
    status=2
elif swarm=$(ssh -n -F "$config" -o HostName="$manager_ip" -o BatchMode=yes -o ConnectTimeout=8 -o StrictHostKeyChecking=yes manager-g5 \
    'hostname; date -Is; docker node ls --format "{{.Hostname}} {{.Status}} {{.Availability}} {{.ManagerStatus}}"; docker service ls --format "{{.Name}} {{.Replicas}} {{.Image}}"; docker network inspect --format "{{.Name}} ingress={{.Ingress}} MTU={{index .Options \"com.docker.network.driver.mtu\"}}" red-g5 red-app-g5' 2>&1); then
    printf '%s\n' "$swarm" | ocultar
else
    printf 'Sin acceso SSH a manager-g5 (%s): %s\n' "$manager_ip" "$(printf '%s' "$swarm" | tail -n 1 | ocultar)"
    status=2
fi

printf '\nResultado: %s\n' "$([[ $status == 0 ]] && echo 'todo correcto' || echo 'falta corregir algo: ver arriba')"
exit "$status"
