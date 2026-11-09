#!/usr/bin/env bash
set -euo pipefail
# Qué hace: comprueba o instala una clave pública Ed25519 en ~/.ssh/authorized_keys de los cuatro nodos.
# Cuándo:   para dar acceso SSH a un integrante. --instalar requiere autorización expresa.
# Efecto:   --comprobar solo lee. --instalar añade la clave al final de cada archivo, sin tocar las
#           demás, y guarda antes una copia en el mismo nodo. Si la clave ya está, no cambia nada.
# Salida:   0 si la clave está en los cuatro nodos, 2 si falta en alguno, 1 si hay un error.
# Uso:      instalar-clave-publica.sh --comprobar|--instalar terraform/claves/NOMBRE.pub
root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
config=$root/config/ssh.local
nodos=(manager-g5 worker1-g5 worker2-g5 worker3-g5)

error() {
    printf 'ERROR: %s\n' "$1" >&2
    exit 1
}

[[ $# == 2 && ( $1 == --comprobar || $1 == --instalar ) ]] ||
    error "uso: $(basename -- "$0") --comprobar|--instalar ARCHIVO.pub"
modo=$1
archivo=$2

# Solo se acepta una clave pública Ed25519 en una línea: así se rechazan claves privadas,
# otros tipos y archivos con saltos de línea de Windows, que ensuciarían authorized_keys.
[[ -f "$archivo" && $(wc -l < "$archivo") == 1 ]] || error "$archivo debe existir y tener una sola línea"
clave=$(< "$archivo")
[[ "$clave" =~ ^ssh-ed25519\ [A-Za-z0-9+/]+=*\ [A-Za-z0-9@._-]+$ ]] ||
    error "$archivo no es una clave pública Ed25519 con comentario, en formato limpio"
lectura=$(ssh-keygen -lf "$archivo") || error "ssh-keygen no reconoce $archivo"
[[ "$lectura" == *"(ED25519)" ]] || error "$archivo no es de tipo Ed25519"
huella=$(awk '{print $2}' <<< "$lectura")
printf 'Clave: %s\n' "$lectura"

# Muestra el estado de cada nodo. Si un nodo no responde, se detiene: nada se instala a medias.
comprobar() {
    local host salida estado faltan=0
    for host in "${nodos[@]}"; do
        salida=$(ssh -n -F "$config" -o ConnectTimeout=12 -o StrictHostKeyChecking=yes "$host" \
            'ssh-keygen -lf ~/.ssh/authorized_keys; stat -c "permisos=%a" ~/.ssh/authorized_keys') ||
            error "sin acceso SSH a $host"
        estado=presente
        if ! grep -qF -- "$huella" <<< "$salida"; then
            estado=ausente
            faltan=2
        fi
        printf '%s\t%s\tclaves=%s\tvockey=%s\t%s\n' "$host" "$estado" "$(grep -c '^[0-9]' <<< "$salida")" \
            "$(grep -c ' vockey ' <<< "$salida" || true)" "$(grep '^permisos=' <<< "$salida")"
    done
    return "$faltan"
}

instalar_en() {
    ssh -F "$config" -o ConnectTimeout=12 -o StrictHostKeyChecking=yes "$1" "bash -s -- $(printf '%q' "$clave")" <<'REMOTO'
set -euo pipefail
clave=$1
material=${clave#* }
material=${material%% *}
f=$HOME/.ssh/authorized_keys
if grep -qF -- "$material" "$f"; then
    echo "ya estaba: no se cambia nada"
    exit 0
fi
copia=$f.antes-$(date +%Y%m%d-%H%M%S)
cp -p -- "$f" "$copia"
# Si el archivo no termina en salto de línea, la clave nueva se pegaría a la última.
[[ -z $(tail -c 1 -- "$f") ]] || printf '\n' >> "$f"
printf '%s\n' "$clave" >> "$f"
# Las claves anteriores deben seguir intactas. Si no, se restaura la copia y se informa del fallo.
if ! cmp -s -n "$(stat -c %s -- "$copia")" -- "$copia" "$f" || ! ssh-keygen -lf "$f" > /dev/null; then
    cp -p -- "$copia" "$f"
    echo "fallo: se ha restaurado la copia" >&2
    exit 1
fi
echo "instalada. Copia previa: $copia"
REMOTO
}

codigo=0
comprobar || codigo=$?
if [[ "$modo" == --instalar ]]; then
    for host in "${nodos[@]}"; do
        printf '%s: ' "$host"
        instalar_en "$host" || error "detenido en $host: los nodos anteriores ya tienen la clave"
    done
    codigo=0
    comprobar || codigo=$?
fi
exit "$codigo"
