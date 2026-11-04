#!/usr/bin/env bash
set -euo pipefail
# Lanza una petición por segundo y deja los fallos visibles en el registro.
if [[ $# != 1 ]]; then
    printf 'Uso: %s URL\n' "$0" >&2
    exit 2
fi
while true; do
    sleep 1 &
    tick=$!
    timestamp=$(date -Is)
    if body=$(curl -fsS --max-time 0.9 -- "$1"); then
        printf '%s OK %s\n' "$timestamp" "${body//$'\n'/ }"
    else
        printf '%s FALLO HTTP\n' "$timestamp"
    fi
    wait "$tick"
done
