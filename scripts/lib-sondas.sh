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

# Devuelve error si alguna sonda ha registrado un fallo.
resumir_sondas() {
    local failures=0 file failed
    parar_sondas
    printf '\nResumen de las sondas (una petición por segundo y por IP):\n'
    for ip in "${ips[@]}"; do
        file="$logs/sonda-$ip.txt"
        failed=$(grep -c ' FALLO' "$file" || true)
        failures=$((failures + failed))
        printf '%s OK=%s FALLO=%s versión 1.0=%s versión 2.0=%s\n' "$ip" \
            "$(grep -c ' OK ' "$file" || true)" "$failed" \
            "$(grep -c 'version=1.0' "$file" || true)" "$(grep -c 'version=2.0' "$file" || true)"
    done
    ((failures == 0))
}
