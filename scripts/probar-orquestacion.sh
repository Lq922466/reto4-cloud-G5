#!/usr/bin/env bash
set -euo pipefail
export AWS_PAGER=""
# Fase 4. Repite E2, E3 o E6 con la web definitiva y una sonda independiente por IP.
# REQUIERE AUTORIZACIÓN: modifica el servicio y la disponibilidad de un nodo de Swarm.
# No crea ni elimina recursos AWS. Se detiene en el primer fallo.
# Con CAPTURAS=1 y DISPLAY definido guarda capturas reales de un terminal gráfico.
# Uso: probar-orquestacion.sh CONFIG_SSH CUENTA/REPOSITORIO DIRECTORIO_REGISTROS e2|e3|e6
if [[ $# != 4 || ! "$4" =~ ^e[236]$ ]]; then
    printf 'Uso: %s CONFIG_SSH CUENTA/REPOSITORIO DIRECTORIO_REGISTROS e2|e3|e6\n' "$0" >&2
    exit 2
fi
config=$(realpath -- "$1") target=$2 logs=$3 test=$4
root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
drain_node=worker3-g5
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
nodos_con_tareas() { manager 'docker service ps --filter desired-state=running --format "{{.Node}}" reto4_web' | sort -u; }
tiene_tareas() { [[ $'\n'"$(nodos_con_tareas)"$'\n' == *$'\n'"$1"$'\n'* ]]; }
ids_tareas() { manager 'docker service ps --filter desired-state=running --format "{{.ID}}" reto4_web' | sort; }
verificar() { bash "$root/scripts/verificar-despliegue.sh" "$config" "$target" 1.0 "$1"; }
# Captura un terminal real con el comando indicado, ejecutado en manager-g5.
capturar() {
    [[ -n "${CAPTURAS:-}" ]] || return 0
    bash "$root/scripts/capturar-pantalla.sh" terminal "$logs/terminal-$1.png" \
        "ssh -F '$config' manager-g5 'hostname; date -Is; $2'"
}
estado='docker service ls; docker service ps --filter desired-state=running reto4_web'
nodos_listos() {
    local nodes
    nodes=$(manager 'docker node ls --format "{{.Hostname}} {{.Status}} {{.Availability}} {{.ManagerStatus}}"')
    printf '%s\n' "$nodes"
    [[ $(grep -c ' Ready Active' <<< "$nodes") == 4 ]]
}

probar_e2() {
    printf '\n===== E2: escalado =====\n'
    verificar 4
    capturar e2-inicial-4 "$estado"
    local count
    for count in 8 12 2 4; do
        printf '\n$ [manager-g5] docker service scale reto4_web=%s\n' "$count"
        manager "docker service scale --detach=false reto4_web=$count" >/dev/null
        esperar_replicas "$count"
        reparto
        verificar "$count"
        capturar "e2-escalado-$count" "$estado"
    done
}

probar_e3() {
    printf '\n===== E3: eliminación de un contenedor =====\n'
    verificar 4
    local nodes node container slot before after running
    nodes=$(nodos_con_tareas)
    node=${nodes%%$'\n'*}
    container=$(remote "$node" 'docker ps -q --filter label=com.docker.swarm.service.name=reto4_web | head -n 1')
    [[ -n "$container" ]]
    slot=$(remote "$node" "docker inspect --format '{{index .Config.Labels \"com.docker.swarm.task.name\"}}' '$container'")
    slot=${slot%.*}
    before=$(ids_tareas)
    printf '\nTareas antes:\n%s\n' "$before"
    capturar e3-antes "$estado"
    printf '\n$ [%s] docker rm -f %s  (tarea %s)\n' "$node" "$container" "$slot"
    remote "$node" "docker rm -f '$container'" >/dev/null
    date -Is
    for _ in $(seq 1 40); do
        after=$(ids_tareas)
        [[ "$after" != "$before" && $(replicas) == 4/4 ]] && break
        sleep 2
    done
    printf '\nTareas después:\n%s\n' "$after"
    if [[ "$after" == "$before" ]]; then
        printf 'ERROR: Swarm no ha creado una tarea de reemplazo.\n' >&2
        return 1
    fi
    running=$(remote "$node" 'docker ps -q --filter label=com.docker.swarm.service.name=reto4_web')
    if [[ $'\n'"$running"$'\n' == *$'\n'"$container"$'\n'* ]]; then
        printf 'ERROR: el contenedor %s sigue en ejecución.\n' "$container" >&2
        return 1
    fi
    printf '\n$ [manager-g5] docker service ps --filter name=%s reto4_web\n' "$slot"
    manager "docker service ps --filter name=$slot reto4_web"
    esperar_replicas 4
    reparto
    verificar 4
    capturar e3-despues "docker service ls; docker service ps --filter name=$slot reto4_web; docker service ps --filter desired-state=running reto4_web"
}

probar_e6() {
    printf '\n===== E6: drain de %s y vuelta a Active =====\n' "$drain_node"
    verificar 4
    reparto
    if ! tiene_tareas "$drain_node"; then
        printf 'ERROR: %s no tiene tareas y no se observaría la migración.\n' "$drain_node" >&2
        return 1
    fi
    capturar e6-antes "docker node ls; $estado"
    # Si el script falla durante el drain, el nodo no debe quedar sin servicio.
    restaurar_nodo() { manager "docker node update --availability active '$drain_node'" >/dev/null || true; }
    trap 'restaurar_nodo; parar_sondas' EXIT
    printf '\n$ [manager-g5] docker node update --availability drain %s\n' "$drain_node"
    manager "docker node update --availability drain '$drain_node'" >/dev/null
    date -Is
    for _ in $(seq 1 40); do
        if ! tiene_tareas "$drain_node" && [[ $(replicas) == 4/4 ]]; then
            break
        fi
        sleep 2
    done
    if tiene_tareas "$drain_node"; then
        printf 'ERROR: %s conserva tareas durante el drain.\n' "$drain_node" >&2
        return 1
    fi
    esperar_replicas 4
    reparto
    manager 'docker node ls --format "{{.Hostname}} {{.Status}} {{.Availability}} {{.ManagerStatus}}"'
    verificar 4
    capturar e6-durante-drain "docker node ls; $estado"

    printf '\n$ [manager-g5] docker node update --availability active %s\n' "$drain_node"
    manager "docker node update --availability active '$drain_node'" >/dev/null
    nodos_listos
    trap parar_sondas EXIT
    capturar e6-active "docker node ls; $estado"

    printf '\n$ [manager-g5] docker service update --force reto4_web\n'
    manager 'docker service update --quiet --detach=false --force reto4_web' >/dev/null
    esperar_replicas 4
    reparto
    verificar 4
    nodos_listos
    capturar e6-despues-force "docker node ls; $estado"
}

iniciar_sondas
hostname
date -Is
sleep 5
"probar_$test"
probar_navegador "fin-$test" 1.0
resumir_sondas
