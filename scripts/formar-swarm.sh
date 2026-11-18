#!/usr/bin/env bash
set -euo pipefail
# Qué hace: forma el clúster Docker Swarm por IP privada y crea sus redes.
# Cuándo:   desde Codespaces, una sola vez y tras comprobar SSH en los cuatro nodos.
# Efecto:   MODIFICA el clúster. Es seguro repetirlo: no cambia lo que ya esté correcto.
root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
ssh_config="$root/config/ssh.local"
# Swarm debe anunciarse por la IP privada del manager, nunca por la pública, que cambia en cada sesión.
manager_ip=$(terraform -chdir="$root/terraform" output -json nodes |
    jq -er '."manager-g5".private_ip | strings | select(test("^[0-9]+(\\.[0-9]+){3}$"))')
remote() {
    ssh -F "$ssh_config" "$@"
}
# Comprueba el estado del manager para poder repetir el script sin romper un clúster ya formado.
manager_state=$(remote manager-g5 "docker info --format '{{.Swarm.LocalNodeState}} {{.Swarm.ControlAvailable}}'")
case "$manager_state" in
    'inactive false') remote manager-g5 docker swarm init --advertise-addr "$manager_ip" >/dev/null ;;
    'active true') ;;
    *) printf 'Estado inesperado en manager-g5: %s\n' "$manager_state" >&2; exit 1 ;;
esac
# Token con el que los workers se unen al clúster. Se valida y no se guarda en ningún archivo.
token=$(remote manager-g5 docker swarm join-token -q worker)
if [[ ! "$token" =~ ^SWMTKN-[a-zA-Z0-9-]+$ ]]; then
    printf 'Token de incorporación inesperado.\n' >&2
    exit 1
fi
# Une cada worker que aún no esté en el clúster, pasando el token por la entrada estándar.
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
# Se borra el token de la memoria del script al terminar de usarlo.
unset token
# Crea las redes overlay con MTU 1450 y muestra el resultado.
remote manager-g5 bash -s < "$root/scripts/configurar-red-swarm.sh"
remote manager-g5 docker node ls
