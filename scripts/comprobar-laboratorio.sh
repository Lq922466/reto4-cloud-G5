#!/usr/bin/env bash
set -uo pipefail
export AWS_PAGER=""
# Qué hace: comprueba el laboratorio al reactivarlo: las cuatro EC2, sus IP, la regla SSH, la web
#           y la conectividad. Si falta permitir la IP del Codespace, muestra un comando
#           para añadir ese origen, SIN EJECUTARLO ni retirar otros accesos.
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
my_ip=$(curl -fsS --max-time 5 https://checkip.amazonaws.com 2>/dev/null || true)
if ! my_ip=$(python3 -c 'import ipaddress,sys; print(ipaddress.IPv4Address(sys.argv[1]))' "$my_ip" 2>/dev/null); then
    my_ip=
    status=2
fi
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
if ! sg=$(aws ec2 describe-security-groups --region "$region" --filters "Name=group-name,Values=$group_name" --output json 2>&1); then
    printf '%s\n' "$sg" | ocultar | cut -c1-160
    printf 'AWS deniega la consulta del grupo de seguridad; no se proponen cambios sin sus reglas.\n'
    exit 3
fi
group_id=$(jq -r '.SecurityGroups[0].GroupId // empty' <<< "$sg")
mapfile -t current < <(jq -r '.SecurityGroups[0].IpPermissions[]? | select(.FromPort == 22) | .IpRanges[].CidrIp' <<< "$sg")
printf 'Grupo: %s. Origen SSH actual: %s\n' "${group_id:--}" "${current[*]:-ninguno}"
wanted="$my_ip/32"
if [[ -z "$my_ip" || -z "$group_id" ]]; then
    status=2
    printf 'No se pudo identificar la IP del Codespace o el grupo: no se proponen cambios de acceso.\n'
elif python3 -c 'import ipaddress,sys; ip=ipaddress.IPv4Address(sys.argv[1]); sys.exit(not any(ip in ipaddress.ip_network(c) for c in sys.argv[2:]))' "$my_ip" "${current[@]}" 2>/dev/null; then
    printf 'El origen del Codespace está permitido. Se conservan los demás accesos SSH existentes.\n'
else
    status=2
    printf 'Falta permitir %s. Comando propuesto, NO ejecutado y sujeto a autorización:\n\n' "$wanted"
    printf '  aws ec2 authorize-security-group-ingress --region %s --group-id %s --protocol tcp --port 22 --cidr %s\n' "$region" "$group_id" "$wanted"
    printf 'No se propone retirar ningún acceso existente. El plan Terraform debe conservar los orígenes autorizados.\n'
fi
if [[ " ${current[*]:-} " == *" 0.0.0.0/0 "* ]]; then
    status=2
    printf 'SSH está abierto a Internet: requiere revisar la política de mínimos, sin retirar accesos en esta comprobación.\n'
fi

printf '\n3. Web por las IP públicas\n'
for ip in "${ips[@]:-}"; do
    [[ -n "$ip" ]] || continue
    code=$(curl -s -o /dev/null --max-time 6 -w '%{http_code}' "http://$ip/")
    identity=$(curl -fsS --max-time 6 "http://$ip/identidad.txt" 2>/dev/null || true)
    printf '%s HTTP %s %s\n' "$ip" "$code" "${identity//$'\n'/ }"
    [[ "$code" == 200 ]] || status=2
    if [[ ! "$identity" =~ ^version=(1[.]0|2[.]0)$'\n'contenedor=[[:alnum:]][[:alnum:]_.-]*$ ]]; then
        printf 'NO CORRECTO: identidad de la aplicación ausente o inválida en %s.\n' "$ip"
        status=2
    fi
done

printf '\n4. SSH y Swarm, sin cambiar nada\n'
config="$root/config/ssh.local"
if [[ "${manager_ip:--}" == - ]]; then
    printf 'manager-g5 no tiene IP pública: no se puede comprobar SSH.\n'
    status=2
elif swarm=$(ssh -n -F "$config" -o HostName="$manager_ip" -o BatchMode=yes -o ConnectTimeout=8 -o StrictHostKeyChecking=yes manager-g5 \
    'set -e
hostname
date -Is
printf "# NODOS\n"
docker node ls --format "{{json .}}"
printf "# SERVICIOS\n"
docker service ls --format "{{json .}}"
printf "# REDES\n"
docker network inspect --format '\''{"Name":{{json .Name}},"Driver":{{json .Driver}},"Ingress":{{json .Ingress}},"MTU":{{json (index .Options "com.docker.network.driver.mtu")}}}'\'' red-g5 red-app-g5' 2>&1); then
    printf '%s\n' "$swarm" | ocultar
    if ! printf '%s\n' "$swarm" | python3 -c '
import json, re, sys
sections = {"NODOS": [], "SERVICIOS": [], "REDES": []}
section = None
try:
    for line in sys.stdin:
        line = line.strip()
        if line.startswith("# ") and line[2:] in sections:
            section = line[2:]
        elif section and line:
            sections[section].append(json.loads(line))
    nodes = sections["NODOS"]
    names = {"manager-g5", "worker1-g5", "worker2-g5", "worker3-g5"}
    checks = {
        "C3: cuatro nodos Ready/Active, manager-g5 Leader y tres workers":
            len(nodes) == 4 and {n.get("Hostname") for n in nodes} == names and
            all(n.get("Status") == "Ready" and n.get("Availability") == "Active" and
                (n.get("ManagerStatus") or "") == ("Leader" if n.get("Hostname") == "manager-g5" else "")
                for n in nodes),
        "D2: reto4_web replicado, cuatro replicas y una imagen 1.0 o 2.0":
            sum(s.get("Name") == "reto4_web" and s.get("Replicas") == "4/4" and
                s.get("Mode") == "replicated" and
                re.fullmatch(r"innnx/reto4-f1:(1[.]0|2[.]0)(@sha256:[0-9a-f]{64})?", s.get("Image", "")) is not None
                for s in sections["SERVICIOS"]) == 1,
    }
    for name, ingress in [("red-g5", True), ("red-app-g5", False)]:
        checks[f"Red {name}: overlay, ingress={ingress} y MTU 1450"] = sum(
            n.get("Name") == name and n.get("Driver") == "overlay" and
            n.get("Ingress") is ingress and str(n.get("MTU")) == "1450"
            for n in sections["REDES"]) == 1
    for label, ok in checks.items():
        print(("CORRECTO: " if ok else "NO CORRECTO: ") + label)
    sys.exit(0 if all(checks.values()) else 1)
except (ValueError, TypeError, AttributeError):
    print("NO CORRECTO: la salida de Swarm esta incompleta o no es valida")
    sys.exit(1)
'; then
        status=2
    fi
else
    printf 'Sin acceso SSH a manager-g5 (%s): %s\n' "$manager_ip" "$(printf '%s' "$swarm" | tail -n 1 | ocultar)"
    status=2
fi

printf '\nResultado: %s\n' "$([[ $status == 0 ]] && echo 'todo correcto' || echo 'falta corregir algo: ver arriba')"
exit "$status"
