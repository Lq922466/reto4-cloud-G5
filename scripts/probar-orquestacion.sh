#!/usr/bin/env bash
set -euo pipefail
export AWS_PAGER=""
# Fase 4. Repite E2, E3 y E6 con la web definitiva y una sonda independiente por IP.
# REQUIERE AUTORIZACIÓN: modifica el servicio y la disponibilidad de un nodo de
# Swarm. No crea ni elimina recursos AWS. Se detiene en el primer fallo.
# Uso: probar-orquestacion.sh CONFIG_SSH CUENTA/REPOSITORIO DIRECTORIO_REGISTROS
if [[ $# != 3 ]]; then
    printf 'Uso: %s CONFIG_SSH CUENTA/REPOSITORIO DIRECTORIO_REGISTROS\n' "$0" >&2
    exit 2
fi
config=$1 target=$2 logs=$3
root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
remote() { local node=$1; shift; ssh -n -F "$config" -o BatchMode=yes -o StrictHostKeyChecking=yes "$node" "$@"; }
manager() { remote manager-g5 "$@"; }
source "$root/scripts/lib-sondas.sh"

reparto() {
    date -Is
    manager 'docker service ps --filter desired-state=running --format "{{.Node}}" reto4_web | sort | uniq -c'
}
replicas() { manager 'docker service ls --filter name=reto4_web --format "{{.Replicas}}"'; }
esperar_replicas() {
    local expected=$1/$1 current=
    for _ in $(seq 1 60); do
        current=$(replicas)
        [[ "$current" == "$expected" ]] && { printf 'réplicas=%s\n' "$current"; return 0; }
        sleep 3
    done
    printf 'ERROR: réplicas=%s, se esperaba %s\n' "$current" "$expected" >&2
    return 1
}
# Nodos con alguna tarea en ejecución.
nodos_con_tareas() { manager 'docker service ps --filter desired-state=running --format "{{.Node}}" reto4_web' | sort -u; }
tiene_tareas() { [[ $'\n'"$(nodos_con_tareas)"$'\n' == *$'\n'"$1"$'\n'* ]]; }
reequilibrar() {
    printf '\n$ [manager-g5] docker service update --force reto4_web\n'
    manager 'docker service update --quiet --detach=false --force reto4_web' >/dev/null
    esperar_replicas 4
    reparto
}

iniciar_sondas
hostname
date -Is
sleep 5
printf '\n$ estado inicial\n'
esperar_replicas 4
reparto

printf '\n===== E2: escalado =====\n'
for count in 8 12 2 4; do
    printf '\n$ [manager-g5] docker service scale reto4_web=%s\n' "$count"
    manager "docker service scale --detach=false reto4_web=$count" >/dev/null
    esperar_replicas "$count"
    reparto
done

printf '\n===== E3: eliminación de un contenedor =====\n'
nodes=$(nodos_con_tareas)
node=${nodes%%$'\n'*}
container=$(remote "$node" 'docker ps -q --filter label=com.docker.swarm.service.name=reto4_web | head -n 1')
[[ -n "$container" ]]
printf '$ [%s] docker rm -f %s\n' "$node" "$container"
remote "$node" "docker rm -f '$container'" >/dev/null
date -Is
sleep 3
esperar_replicas 4
manager 'docker service ps --format "{{.Name}} {{.Node}} {{.DesiredState}} {{.CurrentState}} {{.Error}}" reto4_web | head -n 8'
reparto
running=$(remote "$node" 'docker ps -q --filter label=com.docker.swarm.service.name=reto4_web')
if [[ $'\n'"$running"$'\n' == *$'\n'"$container"$'\n'* ]]; then
    printf 'ERROR: el contenedor %s sigue en ejecución.\n' "$container" >&2
    exit 1
fi

printf '\n===== E6: drain y vuelta a Active =====\n'
reequilibrar
# Se prefiere un worker puro con tareas para que se observe la migración.
for candidate in worker3-g5 worker2-g5 worker1-g5; do
    if tiene_tareas "$candidate"; then
        drain_node=$candidate
        break
    fi
done
[[ -n "${drain_node:-}" ]]
# Si el script falla durante el drain, el nodo no debe quedar sin servicio.
restaurar_nodo() { manager "docker node update --availability active '$drain_node'" >/dev/null || true; }
trap 'restaurar_nodo; parar_sondas' EXIT
printf '\n$ [manager-g5] docker node update --availability drain %s\n' "$drain_node"
manager "docker node update --availability drain '$drain_node'" >/dev/null
sleep 5
esperar_replicas 4
reparto
manager 'docker node ls --format "{{.Hostname}} {{.Status}} {{.Availability}} {{.ManagerStatus}}"'
if tiene_tareas "$drain_node"; then
    printf 'ERROR: %s conserva tareas durante el drain.\n' "$drain_node" >&2
    exit 1
fi
printf '\n$ [manager-g5] docker node update --availability active %s\n' "$drain_node"
manager "docker node update --availability active '$drain_node'" >/dev/null
manager 'docker node ls --format "{{.Hostname}} {{.Status}} {{.Availability}} {{.ManagerStatus}}"'
trap parar_sondas EXIT
reequilibrar

printf '\n===== Estado final =====\n'
bash "$root/scripts/verificar-despliegue.sh" "$config" "$target" 1.0
resumir_sondas
