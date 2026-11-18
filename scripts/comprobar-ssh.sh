#!/usr/bin/env bash
set -euo pipefail
# Qué hace: ejecuta la misma orden a la vez en los cuatro nodos y conserva los fallos de SSH.
# Cuándo:   para comprobar el acceso por alias y el control simultáneo de los nodos.
# Efecto:   solo lectura. Usa config/ssh.local, generado por scripts/actualizar-ips.sh.
root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
# Se guarda el proceso de cada conexión para poder esperarlas todas.
pids=()
# Cada conexión va en segundo plano, de modo que las órdenes se ejecutan a la vez.
for host in manager-g5 worker{1..3}-g5; do
    ssh -F "$root/config/ssh.local" "$host" 'hostname; date -Is; docker --version' &
    pids+=("$!")
done
# Si falla cualquier conexión, el script termina con error.
status=0
for pid in "${pids[@]}"; do
    wait "$pid" || status=1
done
exit "$status"
