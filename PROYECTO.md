# RETO 4 CLOUD · Grupo 5

## Fase 0 · Codespaces y colaboración

El repositorio contiene el entorno con AWS CLI y Terraform. La rama
`cloud-g5-implementacion` integra el Terraform de Codespaces a partir de
`6f3d838`. El Codespace se usó como máquina de control mediante GitHub CLI y
OpenSSH. Para cerrar la evidencia docente, adjuntar colaboradores, PR de los
miembros y revisión del profesor.

## Fase 1 · Infraestructura

Se ejecutó `terraform validate`, se generó el plan y se aplicó el plan guardado
autorizado en `us-east-1`. Terraform confirmó 5 altas, 0 cambios y 0
destrucciones. El manager t3.medium tiene 20 GB gp3 y cada uno de los tres
workers t3.small tiene 10 GB gp3. Las cuatro instancias llegaron a running con
los dos controles de EC2 en ok. La salida `nodes` devuelve IP pública, IP privada
e ID. El estado y el plan permanecen en el Codespace.

El grupo de seguridad permite TCP 80 y 8080 desde Internet. El SSH externo se
limitó a la IP de salida del Codespace con /32. El salto SSH, ICMP y los puertos
internos de Swarm se permiten entre nodos del grupo.

## Fase 2 · SSH

`scripts/generar-config-ssh.sh` generó los alias y el salto del manager a las
IP privadas de los workers. `scripts/comprobar-ssh.sh` llegó a los cuatro nodos.
Una transferencia SCP a worker1-g5 conservó su SHA-256. En los cuatro nodos se
confirmaron cloud-init completado, zona Europe/Madrid, acceso root y contraseña
desactivados, y permisos 700/600. Se comprobó la clave propia del Codespace.
Quedan las claves individuales y la decisión docente sobre vockey.

## Fase 3 · Swarm

El ping por IP privada respondió entre todos los nodos. El script
`scripts/formar-swarm.sh` formó Swarm con tres workers y manager-g5 como líder.
La primera ejecución de la configuración de red se detuvo en la confirmación de
Docker. Tras corregir el script se comprobó red-g5 como ingress overlay y
red-app-g5 como overlay de aplicación, ambas con MTU 1450. Los cuatro nodos
aparecieron Ready y Active con Docker 29.1.3.

## Fase 4 · Web

Las dos versiones del portal provisional están en `app/sitio`. Se construyeron
con `app/construir.sh`, se distribuyeron a los nodos con `docker save` y
`docker load` y se desplegaron con `docker stack deploy --resolve-image never`.
El servicio respondió por las cuatro IP públicas. La web definitiva se publicó y
desplegó después: consultar [su apartado](#despliegue-de-la-web-definitiva).

Capturas reales del portal 1.0, obtenidas por Codex el 4 de noviembre de 2026.
Los cuatro accesos devolvieron la misma página mediante la malla de enrutamiento.

| Nodo | Hora de Madrid | Captura |
| --- | --- | --- |
| manager-g5 | 20:54:58 | [F4C manager](evidencias/F4C-nodo-1.png) |
| worker1-g5 | 20:55:02 | [F4C worker 1](evidencias/F4C-nodo-2.png) |
| worker2-g5 | 20:55:06 | [F4C worker 2](evidencias/F4C-nodo-3.png) |
| worker3-g5 | 20:55:09 | [F4C worker 3](evidencias/F4C-nodo-4.png) |

## Fase 5 · Orquestación

Esta tabla recoge las pruebas con el portal provisional. E1, E2, E3, E6 y E7 se repitieron
con la web definitiva: consultar [su apartado](#despliegue-de-la-web-definitiva).

| Criterio | Resultado observado |
| --- | --- |
| E1 | 12 respuestas, repartidas por igual entre cuatro contenedores. |
| E2 | 8/8, 12/12 y 2/2. Se restauró 4/4. |
| E3 | Se eliminó un contenedor y Swarm recuperó 4/4. |
| E4 | Se detuvo worker3-g5. Swarm reubicó su tarea en manager-g5. El sondeo registró 164 respuestas HTTP correctas y 0 fallos. |
| E5 | worker3-g5 volvió Ready/Active y el servicio a 4/4. El despliegue escalonado volvió a asignar tareas al worker. El reinicio de Learner Lab se registra en [E5 completado](#e5-completado). |
| E6 | worker1-g5 pasó por Drain y volvió a Active. |
| E7 | La web respondió en 2.0 y volvió a 1.0 tras rollback. |
| E8 | Con tres managers operativos, se detuvo únicamente manager-g5. worker2-g5 asumió el liderazgo. manager-g5 volvió Reachable y el servicio terminó 4/4. |

Durante la primera secuencia de orquestación se registraron 156 peticiones HTTP correctas y 0 fallidas.
Para completar las evidencias de terminal, mostrar el hostname y la hora junto
a cada comando, estado y resultado, e identificar al autor.

Evidencias del 4 de noviembre de 2026: [registro de EC2, Swarm y HTTP](evidencias/E4-E5-E8-registro.txt), [portal durante la parada](evidencias/E4-web-worker-down.png) y [portal después de reincorporar el worker](evidencias/E5-web-recuperado.png). Capturas de Codex. Durante la parada el contador mostró 5/4 por la tarea antigua sin confirmación de apagado. Después de arrancar el worker se normalizó a 4/4. La nueva IP pública de worker3-g5 es 3.91.68.78.

En E8, la comprobación esperaba Down y Swarm devolvió Unknown/Unreachable, por lo que se activó el arranque de recuperación. Se observaron 38 respuestas HTTP correctas y 0 fallos durante la parada y 130 correctas y 0 fallos durante la recuperación, con un intervalo sin sondeo entre ambas. La nueva IP pública del manager es 98.93.8.44. [Registro de terminal](evidencias/E8-eleccion-registro.txt) · [Captura durante la maniobra](evidencias/E8-web-parada.png) · [Captura tras reincorporar el manager](evidencias/E8-web-recuperado.png).

[Revisión completa de la guía y la rúbrica](REVISION.md). En E8, la última muestra antes de la interrupción fue a las 21:15:14 y la primera posterior a las 21:15:48, hora de Madrid. Las dos respuestas fueron correctas. Entre ambas muestras transcurrieron 34 segundos sin observaciones intermedias.

## Comprobación posterior de solo lectura

El 4 de noviembre de 2026, a las 21:26 de Madrid, EC2 informó cuatro instancias
running con ambos controles en ok. SSH respondió en los cuatro nodos. Swarm
mostró cuatro nodos Ready/Active, worker2-g5 como Leader, dos managers Reachable,
dos redes overlay con MTU 1450 y reto4_web con 4/4. Se obtuvo HTTP 1.0 por las
cuatro IP públicas actuales. El [registro original](evidencias/verificacion-posterior.txt)
conserva comandos, hostname, horas y resultados. Estas observaciones son
posteriores y no amplían el intervalo cubierto por el sondeo de E8.

| Nodo | IP pública consultada en EC2 | Captura posterior |
| --- | --- | --- |
| manager-g5 | 98.93.8.44 | [Portal](evidencias/posterior-web-manager-g5.png) |
| worker1-g5 | 54.227.41.215 | [Portal](evidencias/posterior-web-worker1-g5.png) |
| worker2-g5 | 34.228.8.66 | [Portal](evidencias/posterior-web-worker2-g5.png) |
| worker3-g5 | 3.91.68.78 | [Portal](evidencias/posterior-web-worker3-g5.png) |

Capturas de Codex entre las 21:26:28 y las 21:26:39. El navegador capturó el
contenido web. AWS Console y la terminal web siguen pendientes de captura
visual. Las IP del estado de Terraform corresponden a su última aplicación.

## Preparación de E5 y A6

El respaldo privado del estado, la configuración de Swarm y las imágenes
provisionales quedó validado en Codespaces. La comprobación previa a E5
confirmó cuatro nodos operativos, 4/4 y acceso HTTP desde las cuatro IP.
El reinicio del laboratorio permanece pendiente de autorización.

En A6 se preparó un plan aislado de una sola actualización de etiqueta del
manager. No se aplicó. Los registros y el procedimiento de comprobación
están en [REVISION.md](REVISION.md#preparación-de-e5-y-a6).

## Web F1 candidata

La web definitiva del grupo ya está en app/f1. Las versiones de entrega 1.0
y 2.0 tienen contextos de construcción preparados y comprobaciones HTTP
locales. La variante 2.0 incorpora una vista de estado de réplica. Consultar
[la revisión del ZIP y el alcance de D1–D3](REVISION.md#revisión-del-zip-de-la-web-f1-definitiva).
El clúster la sirve desde el 5 de noviembre de 2026.

### E5 Verificación posterior interrumpida

Learner Lab se reinició mediante End Lab y Start Lab. La primera verificación
posterior se detuvo porque la política de la sesión AWS anterior rechazó la
consulta de EC2. El [registro](evidencias/E5-verificacion-posterior.txt) se
conserva sin identificadores de sesión. Se requiere renovar las credenciales
temporales en Codespaces y completar las comprobaciones antes de cerrar E5.

### E5 completado

El 5 de noviembre de 2026, tras renovar las credenciales, EC2 mostró las mismas
instancias y los mismos volúmenes raíz. SSH, cuórum, redes, 4/4 y HTTP resultaron
correctos. [Registro](evidencias/E5-verificacion-final.txt).

## Web F1 e imágenes definitivas

Las imágenes 1.0 y 2.0 se construyeron y probaron en contenedores temporales de
manager-g5, se publicaron en [`innnx/reto4-f1`](https://hub.docker.com/r/innnx/reto4-f1/tags)
y se descargaron sin sesión en los tres workers. Consultar
[el cierre técnico](REVISION.md#cierre-técnico-del-5-de-noviembre-de-2026).

## A6 · Cambio con Terraform

El 5 de noviembre de 2026 se aplicó un plan revisado de 0 altas, 1 cambio y 0
destrucciones que añade la etiqueta `PruebaA6=reto4-g5` a manager-g5. Un plan
posterior no propone cambios. [Registro](evidencias/A6-apply.txt). La destrucción no
se ha ejecutado.

## Despliegue de la web definitiva

El 5 de noviembre de 2026, sin recrear EC2 ni reinicializar Swarm, `reto4_web` pasó del
portal provisional a `innnx/reto4-f1:1.0`, se actualizó a 2.0 y volvió a 1.0 con rollback.
Cada paso terminó en 4/4, con HTTP 200 y Chromium sin errores en las cuatro IP públicas.
Las sondas por IP registraron 948 respuestas correctas y 0 fallos. El servicio queda en
1.0.

[Despliegue](evidencias/F3-despliegue/registro.txt) ·
[actualización y rollback](evidencias/F3-actualizacion/registro.txt) ·
[estado final](evidencias/F3-estado-final.txt) ·
[captura completa](evidencias/F3-web-final-1.0-completa.png) ·
[detalle y límites](REVISION.md#despliegue-y-actualización-de-la-web-definitiva)

Capturas de un navegador gráfico real con la dirección visible:
[manager-g5](evidencias/D3-navegador-manager-g5.png) ·
[worker1-g5](evidencias/D3-navegador-worker1-g5.png) ·
[worker2-g5](evidencias/D3-navegador-worker2-g5.png) ·
[worker3-g5](evidencias/D3-navegador-worker3-g5.png).

### E2, E3 y E6 con la web definitiva

| Prueba | Resultado | Sondas |
| --- | --- | --- |
| [E2](evidencias/F4-E2/) | 8/8, 12/12, 2/2 y 4/4, con HTTP 200 en las cuatro IP tras cada estado | 562 correctas, 2 tiempos de espera aislados durante la reducción de 12 a 2 réplicas |
| [E3](evidencias/F4-E3/) | Se eliminó un contenedor y Swarm creó una tarea de reemplazo, con vuelta a 4/4 | 308 correctas, 0 fallos |
| [E6](evidencias/F4-E6/) | worker3-g5 pasó a Drain, su tarea migró y volvió a Active. `--force` dejó una réplica por nodo | 488 correctas, 0 fallos |

Las sondas toman una muestra por segundo y por IP, y no acreditan disponibilidad continua. No se ha
determinado la causa de los dos tiempos de espera.
[Detalle](REVISION.md#fase-4-e2-e3-y-e6-con-la-web-definitiva).

El servicio queda en 4/4 con la versión 1.0, una réplica por nodo, cuatro nodos Ready/Active y HTTP
200 en las cuatro IP. [Estado final](evidencias/capturas-terminal/estado-final.png).

## Capturas de terminal

Las capturas por criterio de las Fases 0–5 están en el
[índice](evidencias/capturas-terminal/INDICE.md). Las de AWS Console y GitHub que faltan, en
[REVISION.md](REVISION.md#capturas-que-faltan).
