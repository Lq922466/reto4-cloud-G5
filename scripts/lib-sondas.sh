# Funciones compartidas: una sonda independiente por cada IP pública actual.
# Se carga con source. Requiere set -euo pipefail y las variables root y logs.
ips=()
probes=()

iniciar_sondas() {
    mkdir -p "$logs"
    mapfile -t ips < <(aws ec2 describe-instances --region us-east-1 \
        --filters 'Name=tag:Name,Values=manager-g5,worker?-g5' 'Name=instance-state-name,Values=running' \
        --query 'Reservations[].Instances[].PublicIpAddress' --output text | tr '\t' '\n')
    [[ ${#ips[@]} == 4 ]]
    for ip in "${ips[@]}"; do
        bash "$root/scripts/sondear-web.sh" "http://$ip/identidad.txt" > "$logs/sonda-$ip.txt" &
        probes+=("$!")
    done
    trap parar_sondas EXIT
}

parar_sondas() {
    if ((${#probes[@]})); then
        kill "${probes[@]}" 2>/dev/null || true
        wait "${probes[@]}" 2>/dev/null || true
        probes=()
    fi
}

# Recorre la web en Chromium por cada IP y guarda una captura. Requiere que
# PYTHON_NAVEGADOR apunte a un intérprete con playwright; si no, no hace nada.
probar_navegador() {
    local label=$1 version=$2 ip
    [[ -n "${PYTHON_NAVEGADOR:-}" ]] || return 0
    for ip in "${ips[@]}"; do
        printf '\n$ probar-navegador.py http://%s/ %s\n' "$ip" "$version"
        date -Is
        "$PYTHON_NAVEGADOR" "$root/scripts/probar-navegador.py" "http://$ip/" "$version" "$logs/web-$label-$ip.png"
    done
}

max_fallos_seguidos() {
    awk '/ FALLO/ { run++; if (run > worst) worst = run; next } / OK / { run = 0 } END { print worst + 0 }' "$1"
}

# Una última muestra OK no acredita una prueba si el proceso de sondeo ya murió.
comprobar_procesos_sondas() {
    local i
    if ((${#ips[@]} == 0 || ${#ips[@]} != ${#probes[@]})); then
        printf 'ERROR: no hay un proceso de sondeo por IP.\n' >&2
        return 1
    fi
    for i in "${!ips[@]}"; do
        if [[ ! "${probes[$i]}" =~ ^[1-9][0-9]*$ ]] || ! kill -0 "${probes[$i]}" 2>/dev/null; then
            printf 'ERROR: la sonda de %s ha terminado antes de finalizar la prueba.\n' "${ips[$i]}" >&2
            return 1
        fi
        if [[ ! -s "$logs/sonda-${ips[$i]}.txt" ]]; then
            printf 'ERROR: la sonda de %s no ha registrado muestras.\n' "${ips[$i]}" >&2
            return 1
        fi
    done
}

# Devuelve error si una misma IP acumula tres fallos consecutivos.
vigilar_sondas() {
    local ip worst
    comprobar_procesos_sondas || return 1
    for ip in "${ips[@]}"; do
        worst=$(max_fallos_seguidos "$logs/sonda-$ip.txt")
        if ((worst >= 3)); then
            printf 'ERROR: %s registra %s fallos consecutivos.\n' "$ip" "$worst" >&2
            return 1
        fi
    done
}

# Por defecto cualquier fallo es un error. Con "aislados" se registran los fallos y solo
# es un error si hay tres seguidos en una IP o si su última muestra ha fallado.
resumir_sondas() {
    local mode=${1:-estricto} failures=0 blocking=0 file failed worst last procesos_ok=0
    # Comprobar antes de detenerlas: parar_sondas vacía la lista de procesos.
    comprobar_procesos_sondas || procesos_ok=$?
    parar_sondas
    printf '\nResumen de las sondas (una petición por segundo y por IP):\n'
    for ip in "${ips[@]}"; do
        file="$logs/sonda-$ip.txt"
        failed=$(grep -c ' FALLO' "$file" || true)
        worst=$(max_fallos_seguidos "$file")
        last=$(tail -n 1 "$file" | awk '{ print $2 }')
        failures=$((failures + failed))
        if ((worst >= 3)) || [[ "$last" != OK ]]; then
            blocking=$((blocking + 1))
        fi
        printf '%s OK=%s FALLO=%s seguidos=%s última=%s versión 1.0=%s versión 2.0=%s\n' "$ip" \
            "$(grep -c ' OK ' "$file" || true)" "$failed" "$worst" "$last" \
            "$(grep -c 'version=1.0' "$file" || true)" "$(grep -c 'version=2.0' "$file" || true)"
    done
    if ((failures > 0)); then
        printf '\nFallos registrados:\n'
        for ip in "${ips[@]}"; do
            grep ' FALLO' "$logs/sonda-$ip.txt" | sed "s|^|$ip |" || true
        done
    fi
    if ((procesos_ok != 0)); then
        return 1
    elif [[ "$mode" == aislados ]]; then
        ((blocking == 0))
    else
        ((failures == 0))
    fi
}
