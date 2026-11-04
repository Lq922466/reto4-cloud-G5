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
El servicio respondió por las cuatro IP públicas. Faltan la web definitiva del
grupo y la publicación autorizada en Docker Hub.

Capturas reales del portal 1.0, obtenidas por Codex el 4 de noviembre de 2026.
Los cuatro accesos devolvieron la misma página mediante la malla de enrutamiento.

| Nodo | Hora de Madrid | Captura |
| --- | --- | --- |
| manager-g5 | 20:54:58 | [F4C manager](evidencias/F4C-nodo-1.png) |
| worker1-g5 | 20:55:02 | [F4C worker 1](evidencias/F4C-nodo-2.png) |
| worker2-g5 | 20:55:06 | [F4C worker 2](evidencias/F4C-nodo-3.png) |
| worker3-g5 | 20:55:09 | [F4C worker 3](evidencias/F4C-nodo-4.png) |

## Fase 5 · Orquestación

| Criterio | Resultado observado |
| --- | --- |
| E1 | 12 respuestas, repartidas por igual entre cuatro contenedores. |
| E2 | 8/8, 12/12 y 2/2. Se restauró 4/4. |
| E3 | Se eliminó un contenedor y Swarm recuperó 4/4. |
| E4 | Se detuvo worker3-g5. Swarm reubicó su tarea en manager-g5. El sondeo registró 164 respuestas HTTP correctas y 0 fallos. |
| E5 | worker3-g5 volvió Ready/Active y el servicio a 4/4. El despliegue escalonado volvió a asignar tareas al worker. Sigue pendiente reiniciar Learner Lab. |
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
