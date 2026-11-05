#!/usr/bin/env bash
set -euo pipefail
# Qué hace: genera config/ssh.local a partir de la salida «nodes» de Terraform.
# Cuándo:   justo después de crear la infraestructura. Si las IP han cambiado desde el último
#           apply, usar scripts/actualizar-ips.sh, que las lee directamente de EC2.
# Efecto:   solo escribe config/ssh.local, excluido de Git. Requiere jq y el estado de Terraform.
root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
source "$root/scripts/lib-ssh-config.sh"
nodes=$(terraform -chdir="$root/terraform" output -json nodes)
escribir_config_ssh "$root" "$nodes" "$root/config/ssh.local"
