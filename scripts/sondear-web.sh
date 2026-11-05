#!/usr/bin/env bash
set -euo pipefail
# Qué hace: consulta la web cada segundo y registra la hora, el resultado, la versión y el contenedor.
# Cuándo:   durante las pruebas de orquestación, en una terminal aparte o redirigido a un archivo.
# Uso:      sondear-web.sh http://IP_PUBLICA/identidad.txt
# Efecto:   solo lectura. Es una muestra por segundo: no acredita disponibilidad continua.
if [[ $# != 1 ]]; then
    printf 'Uso: %s URL\n' "$0" >&2
    exit 2
fi
while true; do
    # La espera va en paralelo para que cada iteración dure un segundo, tarde lo que tarde la petición.
    sleep 1 &
    tick=$!
    timestamp=$(date -Is)
    # El límite de 0,9 s evita que una respuesta lenta retrase la siguiente muestra.
    if body=$(curl -fsS --max-time 0.9 -- "$1"); then
        # Une en una línea la versión y el contenedor que han respondido.
        printf '%s OK %s\n' "$timestamp" "${body//$'\n'/ }"
    else
        printf '%s FALLO HTTP\n' "$timestamp"
    fi
    wait "$tick"
done
