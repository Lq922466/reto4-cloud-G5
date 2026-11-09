#!/usr/bin/env bash
set -euo pipefail
export AWS_PAGER=""
# Comprobación de solo lectura del servicio web. Usa las IP públicas actuales de EC2.
# Uso: verificar-despliegue.sh CONFIG_SSH IMAGEN VERSION [RÉPLICAS]
if [[ $# != 3 && $# != 4 ]]; then
    printf 'Uso: %s CONFIG_SSH IMAGEN VERSION [RÉPLICAS]\n' "$0" >&2
    exit 2
fi
config=$1 image=$2 version=$3 expected=${4:-4}
if [[ ! "$version" =~ ^(1[.]0|2[.]0)$ || ! "$expected" =~ ^[1-9][0-9]*$ ]]; then
    printf 'La versión debe ser 1.0 o 2.0 y las réplicas un entero positivo.\n' >&2
    exit 2
fi
remote() { ssh -n -F "$config" -o BatchMode=yes -o StrictHostKeyChecking=yes manager-g5 "$@"; }

hostname
date -Is
printf '\n$ docker node ls; docker service ls; docker service ps\n'
remote 'hostname; docker node ls --format "{{.Hostname}} {{.Status}} {{.Availability}} {{.ManagerStatus}}"'
replicas=$(remote 'docker service ls --filter name=reto4_web --format "{{.Replicas}}"')
spec=$(remote 'docker service inspect --format "{{.Spec.TaskTemplate.ContainerSpec.Image}}" reto4_web')
printf 'reto4_web réplicas=%s imagen=%s\n' "$replicas" "$spec"
[[ "$replicas" == "$expected/$expected" ]]
[[ "$spec" == "$image:$version" || "$spec" == "$image:$version@"* ]]
tasks=$(remote 'docker service ps --filter desired-state=running --format "{{.Name}} {{.Image}} {{.Node}} {{.CurrentState}}" reto4_web')
printf '%s\n' "$tasks"
# El portal provisional y la web definitiva responden ambos version=1.0: la imagen los distingue.
matching=$(awk -v expected="$image:$version" '{ split($2, name, "@"); if (name[1] == expected && $4 == "Running") count++ } END { print count + 0 }' <<< "$tasks")
if [[ "$matching" != "$expected" || $(wc -l <<< "$tasks") != "$expected" ]]; then
    printf 'ERROR: no hay %s tareas Running con la imagen esperada.\n' "$expected" >&2
    exit 1
fi

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
        if [[ ! "$body" =~ ^version=(1[.]0|2[.]0)$'\n'contenedor=[[:alnum:]][[:alnum:]_.-]*$ ]] ||
            ! grep -Fxq "version=$version" <<< "$body"; then
            printf 'ERROR: identidad incompleta o versión inesperada en %s.\n' "$ip" >&2
            exit 1
        fi
        printf '%s\n' "${body#*$'\n'}" >> "$identities"
    done
    printf '%s HTTP %s\n' "$ip" "$code"
    [[ "$code" == 200 ]]
done
printf '\n12 peticiones, todas en versión %s. Respuestas por contenedor:\n' "$version"
sort "$identities" | uniq -c
distinct=$(sort -u "$identities" | wc -l)
if ((expected > 1 && distinct < 2)); then
    printf 'ERROR: las peticiones solo han alcanzado un contenedor; no se ha demostrado balanceo.\n' >&2
    exit 1
fi
