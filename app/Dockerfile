FROM nginx:alpine
ARG WEB_VERSION
COPY sitio/ /usr/share/nginx/html/
RUN test -s /usr/share/nginx/html/index.html && \
    printf 'version=%s\n' "$WEB_VERSION" > /etc/reto4-version
COPY 40-identidad.sh /docker-entrypoint.d/40-identidad.sh
RUN chmod 0755 /docker-entrypoint.d/40-identidad.sh
HEALTHCHECK --interval=5s --timeout=2s --retries=3 CMD wget -q -O /dev/null http://127.0.0.1/identidad.txt || exit 1
