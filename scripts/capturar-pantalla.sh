#!/usr/bin/env bash
set -euo pipefail
# Captura la pantalla real de un navegador o un terminal gráficos. No retoca la imagen.
# Requiere un servidor X en DISPLAY (Xvfb sirve), xterm e ImageMagick.
#   capturar-pantalla.sh web URL ARCHIVO.png       Requiere CHROME con la ruta del navegador.
#   capturar-pantalla.sh terminal ARCHIVO.png COMANDO
mode=${1:-}
: "${DISPLAY:?Definir DISPLAY}"
font=(-fa 'DejaVu Sans Mono' -fs 11 -bg black -fg white)

wait_for() {
    local file=$1
    for _ in $(seq 1 120); do
        [[ -e "$file" ]] && return 0
        sleep 0.5
    done
    printf 'El comando no terminó a tiempo.\n' >&2
    return 1
}

case "$mode" in
web)
    [[ $# == 3 ]] || { printf 'Uso: %s web URL ARCHIVO.png\n' "$0" >&2; exit 2; }
    url=$2 output=$3
    : "${CHROME:?Definir CHROME}"
    profile=$(mktemp -d)
    done_file=$(mktemp -u)
    pids=()
    cleanup() {
        kill "${pids[@]}" 2>/dev/null || true
        sleep 1
        rm -rf -- "$profile" "$done_file"
    }
    trap cleanup EXIT
    # El Codespace no admite el sandbox del navegador. La web se sirve por HTTP, de modo que
    # se desactiva el aviso previo de HTTPS para que se vea la página y no el aviso.
    LANGUAGE=es "$CHROME" --no-sandbox --test-type --lang=es --accept-lang=es --no-first-run --no-default-browser-check \
        --disable-sync --password-store=basic --user-data-dir="$profile" \
        --disable-features=Translate,HttpsUpgrades,HttpsFirstBalancedModeAutoEnable,HttpsFirstModeV2 \
        --window-position=0,0 --window-size=1400,830 "$url" >/dev/null 2>&1 &
    pids+=("$!")
    xterm "${font[@]}" -geometry 150x11+0+835 -e bash -c '
        url=$1 done_file=$2
        printf "\$ hostname; date -Is\n"; hostname; date -Is
        printf "\$ curl -s -o /dev/null -w \"%%{http_code}\" %s\n" "$url"
        curl -s -o /dev/null --max-time 5 -w "%{http_code}\n" "$url"
        printf "\$ curl -s %sidentidad.txt\n" "$url"
        curl -s --max-time 5 "${url}identidad.txt"
        touch "$done_file"
        sleep 120' _ "$url" "$done_file" &
    pids+=("$!")
    wait_for "$done_file"
    # Tiempo para que el navegador termine de pintar la página.
    sleep 8
    import -window root "$output"
    ;;
terminal)
    [[ $# == 3 ]] || { printf 'Uso: %s terminal ARCHIVO.png COMANDO\n' "$0" >&2; exit 2; }
    output=$2 command=$3
    done_file=$(mktemp -u)
    title="captura-$$"
    xterm "${font[@]}" -T "$title" -geometry 150x30+0+0 -e bash -c '
        printf "\$ %s\n" "$2"
        bash -c "$2" 2>&1
        touch "$1"
        sleep 120' _ "$done_file" "$command" &
    pid=$!
    trap 'kill "$pid" 2>/dev/null || true; rm -f -- "$done_file"' EXIT
    wait_for "$done_file"
    sleep 0.5
    import -window "$title" "$output"
    ;;
*)
    printf 'Uso: %s web URL ARCHIVO.png | terminal ARCHIVO.png COMANDO\n' "$0" >&2
    exit 2
    ;;
esac
