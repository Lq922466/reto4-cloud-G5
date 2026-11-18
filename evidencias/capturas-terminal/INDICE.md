# Índice de capturas de terminal

Capturas tomadas el 5 de noviembre de 2026 por Claude Code con `scripts/capturas-terminal.sh`,
para el informe de F9 y F10. Cada una es una imagen real de un terminal xterm en un escritorio
virtual del Codespace, sin retocar, con los comandos reales. Todas usan comandos de lectura.

> **Estado del 5 de noviembre.** Muestran la topología de ese día, con tres managers y worker1-g5 como
> líder, y no tienen el prompt ni el comentario que exige la Guía. Las capturas que cumplen la norma
> están en [capturas-conformes/](../capturas-conformes/INDICE.md).

- **Fecha y máquina:** cada captura muestra el comando, `hostname` y `date -Is`. El Codespace
  usa UTC y los nodos, hora de Madrid (+01:00).
- **Texto:** junto a cada imagen hay un `.txt` con la misma salida.
- **Copia SCP:** B3 descarga `/etc/hostname` del nodo para no escribir en él.
- **Línea del líder:** en C2, Swarm informa `estado=0.0.0.0` para el líder, worker1-g5. Su
  dirección privada aparece en `manager=`.
- **E7:** la captura es el historial de tareas, tomado después de la prueba. No se tomó durante
  la actualización.

| Criterio | Captura | Qué muestra |
| --- | --- | --- |
| F1 | [F1-colaboradores](F1-colaboradores.png) | Cuentas con acceso y visibilidad del repositorio |
| F2 | [F2-historial](F2-historial.png) | Historial de la rama y PR |
| F4 | [F4-estructura](F4-estructura.png) | Estructura del repositorio |
| F5 | [F5-entorno](F5-entorno.png) | Versiones de AWS CLI, Terraform, GitHub CLI y OpenSSH |
| F6 | [F6-codigo-instancias](F6-codigo-instancias.png) | Código de las instancias |
| F7 | [F7-scripts](F7-scripts.png) | Scripts versionados |
| F12 | [F12-archivos-sensibles](F12-archivos-sensibles.png) | Archivos sensibles fuera de Git |
| A1 | [A1-modulo-terraform](A1-modulo-terraform.png) | Módulo Terraform y `terraform validate` |
| A2 | [A2-instancias](A2-instancias.png) | Instancias, tipos, estado y controles |
| A3 | [A3-grupo-seguridad](A3-grupo-seguridad.png) | Reglas de entrada del grupo de seguridad |
| A4 | [A4-arranque](A4-arranque.png) | cloud-init, zona horaria y Docker por nodo |
| A5 | [A5-salida-nodes](A5-salida-nodes.png) | `terraform output nodes` e IP actuales |
| A6 | [A6-sin-cambios](A6-sin-cambios.png) | Plan sin cambios y etiqueta `PruebaA6` |
| B1 | [B1-claves-autorizadas](B1-claves-autorizadas.png) | Huellas de las claves autorizadas por nodo |
| B2 | [B2-alias](B2-alias.png) | Alias SSH y conexión |
| B3 | [B3-simultaneo-sudo](B3-simultaneo-sudo.png), [B3-copia-scp](B3-copia-scp.png) | Comandos simultáneos, sudo y copia con SHA-256 |
| B4 | [B4-endurecimiento](B4-endurecimiento.png) | `sshd -T` y permisos |
| B5 | [B5-salto](B5-salto.png) | ProxyJump y acceso por IP privada |
| C1 | [C1-docker-ping](C1-docker-ping.png) | Docker y ping por IP privada |
| C2 | [C2-red-ingress](C2-red-ingress.png) | Direcciones de Swarm y red `red-g5` |
| C3 | [C3-nodos](C3-nodos.png) | `docker node ls` |
| C4 | [C4-red-aplicacion](C4-red-aplicacion.png) | Red `red-app-g5` |
| D1 | [D1-imagenes](D1-imagenes.png) | Imágenes en el nodo y digests en Docker Hub |
| D2 | [D2-pila-servicio](D2-pila-servicio.png) | `stack.yml` y servicio |
| E1 | [E1-reparto-peticiones](E1-reparto-peticiones.png) | Respuestas por IP y contenedor |
| E7 | [E7-historial-versiones](E7-historial-versiones.png) | Historial de tareas con las versiones |
| Final | [estado-final](estado-final.png) | Nodos, servicio y HTTP en las cuatro IP |

Las capturas tomadas durante E2, E3 y E6 están en [F4-E2](../F4-E2/), [F4-E3](../F4-E3/) y
[F4-E6](../F4-E6/). Las de navegador con la dirección visible son `evidencias/D3-navegador-*`.
