#!/usr/bin/env bash
set -euo pipefail
# Genera la configuración local a partir de las salidas vigentes de Terraform.
root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
nodes=$(terraform -chdir="$root/terraform" output -json nodes)
destination="$root/config/ssh.local"
umask 077
temporary=$(mktemp "$root/config/.ssh.local.XXXXXX")
trap 'rm -f -- "$temporary"' EXIT
for host in manager-g5 worker{1..3}-g5; do
    field=private_ip
    if [[ "$host" == manager-g5 ]]; then
        field=public_ip
    fi
    ip=$(jq -er --arg host "$host" --arg field "$field" '
        .[$host][$field] | strings | select(test("^[0-9]+(\\.[0-9]+){3}$"))
    ' <<< "$nodes")
    printf 'Host %s\n    HostName %s\n\n' "$host" "$ip" >> "$temporary"
done
sed -n '/^Host worker?-g5/,$p' "$root/config/ssh_config.example" >> "$temporary"
mv -- "$temporary" "$destination"
