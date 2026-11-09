#!/usr/bin/env bash
set -euo pipefail
# Qué hace: genera config/ssh.local a partir de la salida «nodes» de Terraform.
# Cuándo:   justo después de crear la infraestructura. Si las IP han cambiado desde el último
#           apply, usar scripts/actualizar-ips.sh, que las lee directamente de EC2.
# Efecto:   solo escribe config/ssh.local, excluido de Git. Requiere jq y el estado de Terraform.
# Uso:      generar-config-ssh.sh [RUTA_ESTADO]. También admite TF_STATE_PATH.
root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
source "$root/scripts/lib-ssh-config.sh"
if (($# > 1)); then
    printf 'Uso: %s [RUTA_ESTADO]\n' "$0" >&2
    exit 2
fi
state=${1:-${TF_STATE_PATH:-"$root/terraform/terraform.tfstate"}}
if [[ ! -f "$state" || ! -s "$state" ]]; then
    printf 'Falta un estado Terraform no vacío. Indicar su ruta explícita; no se cambia la configuración SSH.\n' >&2
    exit 1
fi
# -chdir cambia cómo Terraform interpreta una ruta relativa: resolverla antes.
state=$(realpath -- "$state")
errors=$(mktemp)
trap 'rm -f -- "$errors"' EXIT
if ! nodes=$(terraform -chdir="$root/terraform" output -state="$state" -json nodes 2> "$errors"); then
    printf 'No se pudo leer la salida nodes del estado indicado; no se cambia la configuración SSH.\n' >&2
    exit 1
fi
if ! jq -e '
    type == "object" and
    (keys | sort) == ["manager-g5", "worker1-g5", "worker2-g5", "worker3-g5"] and
    all(.[]; type == "object" and
        (.id | type == "string" and length > 0) and
        (.public_ip | type == "string" and length > 0) and
        (.private_ip | type == "string" and length > 0))
' <<< "$nodes" > /dev/null 2>&1; then
    printf 'La salida nodes no contiene los cuatro nodos completos; no se cambia la configuración SSH.\n' >&2
    exit 1
fi
escribir_config_ssh "$root" "$nodes" "$root/config/ssh.local"
