#!/usr/bin/env bash
set -euo pipefail
# Ejecutar desde Codespaces tras comprobar SSH en los cuatro nodos.
root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
ssh_config="$root/config/ssh.local"
manager_ip=$(terraform -chdir="$root/terraform" output -json nodes |
    jq -er '."manager-g5".private_ip | strings | select(test("^[0-9]+(\\.[0-9]+){3}$"))')
remote() {
    ssh -F "$ssh_config" "$@"
}
manager_state=$(remote manager-g5 "docker info --format '{{.Swarm.LocalNodeState}} {{.Swarm.ControlAvailable}}'")
case "$manager_state" in
    'inactive false') remote manager-g5 docker swarm init --advertise-addr "$manager_ip" >/dev/null ;;
    'active true') ;;
    *) printf 'Estado inesperado en manager-g5: %s\n' "$manager_state" >&2; exit 1 ;;
esac
token=$(remote manager-g5 docker swarm join-token -q worker)
if [[ ! "$token" =~ ^SWMTKN-[a-zA-Z0-9-]+$ ]]; then
    printf 'Token de incorporación inesperado.\n' >&2
    exit 1
fi
for host in worker{1..3}-g5; do
    worker_state=$(remote "$host" "docker info --format '{{.Swarm.LocalNodeState}}'")
    case "$worker_state" in
        inactive)
            printf '%s\n' "$token" | remote "$host" \
                "read -r token && docker swarm join --token \"\$token\" '$manager_ip:2377'"
            ;;
        active) remote manager-g5 docker node inspect "$host" >/dev/null ;;
        *) printf 'Estado inesperado en %s: %s\n' "$host" "$worker_state" >&2; exit 1 ;;
    esac
done
unset token
remote manager-g5 bash -s < "$root/scripts/configurar-red-swarm.sh"
remote manager-g5 docker node ls
