#!/bin/sh
set -eu
# Qué hace: genera /identidad.txt con la versión de la imagen y el nombre del contenedor.
# Cuándo:   lo ejecuta nginx al iniciar cada réplica, desde /docker-entrypoint.d.
# Por qué:  el identificador es distinto en cada contenedor, así que no puede ir en la imagen. Permite
#           comprobar el balanceo de carga viendo qué réplica responde.
{
    cat /etc/reto4-version
    printf 'contenedor=%s\n' "$(hostname)"
} > /usr/share/nginx/html/identidad.txt
