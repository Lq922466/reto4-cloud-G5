#!/usr/bin/env bash
set -euo pipefail
# Ejecuta la misma comprobación simultáneamente y conserva los fallos de SSH.
root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
pids=()
for host in manager-g5 worker{1..3}-g5; do
    ssh -F "$root/config/ssh.local" "$host" 'hostname; date -Is; docker --version' &
    pids+=("$!")
done
status=0
for pid in "${pids[@]}"; do
    wait "$pid" || status=1
done
exit "$status"
