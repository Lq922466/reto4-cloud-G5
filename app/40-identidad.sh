#!/bin/sh
set -eu
# La identidad se genera al iniciar cada réplica.
{
    cat /etc/reto4-version
    printf 'contenedor=%s\n' "$(hostname)"
} > /usr/share/nginx/html/identidad.txt
