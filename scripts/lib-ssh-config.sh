# Funciones compartidas para generar la configuración SSH. Se carga con source.
# La usan generar-config-ssh.sh (desde la salida de Terraform) y actualizar-ips.sh (desde EC2).

# escribir_config_ssh RAIZ_DEL_REPOSITORIO JSON DESTINO
# JSON tiene una entrada por nodo: {"manager-g5": {"public_ip": "...", "private_ip": "..."}, ...}
# Escribe en un archivo temporal y lo mueve al final, para no dejar nunca un archivo a medias.
escribir_config_ssh() {
    local root=$1 nodes=$2 destination=$3 temporary host field ip
    temporary=$(mktemp "$root/config/.ssh.local.XXXXXX")
    for host in manager-g5 worker{1..3}-g5; do
        # Se entra por IP pública solo al manager. A los workers se llega por IP privada, con salto.
        field=private_ip
        if [[ "$host" == manager-g5 ]]; then
            field=public_ip
        fi
        # Rechaza cualquier valor que no sea una dirección IPv4.
        ip=$(jq -er --arg host "$host" --arg field "$field" '
            .[$host][$field] | strings | select(test("^[0-9]+(\\.[0-9]+){3}$"))
        ' <<< "$nodes") || { rm -f -- "$temporary"; return 1; }
        printf 'Host %s\n    HostName %s\n' "$host" "$ip" >> "$temporary"
        # El alias mantiene la clave de host conocida aunque cambie la IP pública del manager.
        if [[ "$host" == manager-g5 ]]; then
            printf '    HostKeyAlias manager-g5\n' >> "$temporary"
        fi
        printf '\n' >> "$temporary"
    done
    # El resto de opciones (salto, usuario y clave) se copia de la plantilla.
    sed -n '/^Host worker?-g5/,$p' "$root/config/ssh_config.example" >> "$temporary"
    chmod 600 "$temporary"
    mv -- "$temporary" "$destination"
}
