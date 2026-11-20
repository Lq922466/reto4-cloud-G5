# RETO 4 · Cloud — Grupo 5

Este repositorio contiene el trabajo de Cloud del Grupo 5: una página web del Gran Premio de Euskadi desplegada en cuatro servidores Ubuntu mediante AWS, Terraform y Docker Swarm.

## Por dónde empezar

1. **[Informe del proyecto](PROYECTO.md)** — Explica de forma ordenada qué hicimos, cómo funciona la infraestructura y qué resultados obtuvimos.
2. **[Organización del equipo](GESTION.md)** — Describe la participación de los integrantes y el uso de herramientas de inteligencia artificial.
3. **[Capturas y pruebas](evidencias/INDICE.md)** — Reúne las imágenes y registros que acompañan al informe.
4. **[Comprobación detallada](REVISION.md)** — Conserva la revisión técnica por criterios, con las pruebas disponibles y los puntos que todavía necesitan evidencia adicional.

## Cómo funciona el proyecto

- **AWS:** proporciona los cuatro servidores virtuales.
- **Terraform:** permite crear y configurar esos servidores a partir de archivos.
- **SSH:** permite administrarlos a distancia de forma segura.
- **Docker Swarm:** distribuye la página web entre los servidores y ayuda a recuperarla cuando falla un contenedor.
- **Docker Hub:** almacena las versiones 1.0 y 2.0 de la imagen de la web.

La página se creó con Nginx y se publicó en Docker Hub como [`innnx/reto4-f1`](https://hub.docker.com/r/innnx/reto4-f1/tags).

## Pruebas realizadas

Se documentaron el reparto de visitas entre servidores, los cambios en el número de copias de la web, la recuperación de contenedores, el mantenimiento de nodos y la actualización de la versión 1.0 a la 2.0 con vuelta atrás. También se realizaron pruebas con un servidor detenido y con el cambio de líder del clúster. El informe explica las diferencias entre las pruebas y sus límites.

**Fechas de referencia:** las últimas comprobaciones registradas del servicio y de SSH corresponden al 9 de noviembre de 2026; las de Terraform, al 10 de noviembre. Estos datos son históricos y no garantizan que el laboratorio esté actualmente encendido.

## Participación y uso de IA

Cristina coordinó el producto Cloud y revisó y autorizó los cambios técnicos. Enrique, Alexandra e Ibai participaron en las pruebas de acceso mediante SSH; Enrique también aportó cambios en GitHub. Se utilizaron Codex y Claude Code para apoyar la preparación de scripts, las operaciones autorizadas, las comprobaciones y la documentación. Los detalles se explican en el [informe](PROYECTO.md) y en [GESTION.md](GESTION.md).

## Documentos complementarios

- [Guion de presentación](entrega/DEFENSA.md)
- [Registro de tareas pendientes](entrega/PENDIENTES.md)
- [Lista de comprobación final](entrega/CHECKLIST-FINAL.md)
- [Análisis de las pruebas de fallo de servidores](evidencias/auditoria/E4-E8.md)
- [Documentación histórica](entrega/historico/PROYECTO-2026-11-09.md)

Los archivos de configuración, scripts y capturas originales se conservan en sus carpetas correspondientes.
