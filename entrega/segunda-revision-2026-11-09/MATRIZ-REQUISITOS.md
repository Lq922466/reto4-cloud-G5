# Matriz independiente de requisitos Cloud

La referencia normativa son exclusivamente los dos DOCX originales identificados en [la revisión](README.md). Requisitos resumidos con palabras propias. «Documentado» indica archivos y evidencia histórica revisados, no una nota ni cumplimiento confirmado el día de la corrección. «Parcial» incluye ejecución acreditada cuya evidencia obligatoria sigue incompleta. «Pendiente» significa no acreditado en el material disponible. No se calcula nota: la Rúbrica no desglosa pesos por ítem.

| Código | Requisito | Estado documental | Fuente contrastada | Resultado y pendiente |
| --- | --- | --- | --- | --- |
| A1 | Organización y variables | Documentado | [main.tf](../../terraform/main.tf) | Variables de grupo, imagen, tipos, discos y número de workers; validar funcionamiento en corrección. |
| A2 | Manager y 3 workers, etiquetas | Parcial | [main.tf](../../terraform/main.tf) | count correcto y registro CLI; falta evidencia de consola EC2 solicitada. |
| A3 | Grupo con mínimos | Parcial | `evidencias/capturas-conformes/A3-reglas.txt` (solo local; pendiente de publicación) | Código limita puertos internos al grupo; falta consola EC2 y reflejar o retirar con autorización la regla temporal posterior. |
| A4 | Arranque: hostname, zona, Docker, claves | Documentado | [bootstrap.sh.tftpl](../../terraform/scripts/bootstrap.sh.tftpl) | Script y registro A4-arranque disponibles. Las claves añadidas después constan en B1; no se exige repetir el despliegue por este motivo. |
| A5 | Salidas de IP e ID | Documentado | `evidencias/capturas-conformes/A5-salidas.txt` (solo local; pendiente de publicación) | Salidas presentes. Las IP del último apply no son necesariamente las IP vigentes. |
| A6 | Validación, plan, cambio y destrucción | Parcial | [A6-apply.txt](../../evidencias/A6-apply.txt) | Constan validación, planes y cambio; no destrucción. A6-sin-cambios da NO CORRECTO: no usarla como prueba de plan limpio. |
| B1 | Clave propia en 4 nodos, vockey sustituida | Parcial | `evidencias/capturas-conformes/B1-clave-nodos.txt` (solo local; pendiente de publicación) | Claves públicas locales y huellas autorizadas en cuatro nodos; falta publicarlas. Hay acceso personal de todos al manager y de Cristina a workers; los demás accesos no están acreditados. No se prescribe un número de capturas. vockey sigue: discrepancia entre Guía y Rúbrica. |
| B2 | Config y nombre corto | Documentado | `evidencias/capturas-conformes/B2-conexion.txt` (solo local; pendiente de publicación) | Plantillas y conexión histórica con alias; Cristina tiene también evidencia personal. |
| B3 | Control, simultaneidad y copia | Documentado | `evidencias/capturas-conformes/B3-simultaneo.txt` (solo local; pendiente de publicación) | Órdenes y sudo en cuatro nodos; B3-copia compara SHA-256. No atribuir su ejecución a las cuatro personas del equipo. |
| B4 | Sin contraseña/root y permisos | Documentado | `evidencias/capturas-conformes/B4-endurecimiento.txt` (solo local; pendiente de publicación) | Configuración y permisos registrados; revalidar durante corrección. |
| B5 | Workers por IP privada y salto | Documentado | `evidencias/capturas-conformes/B5-salto.txt` (solo local; pendiente de publicación) | Salto documentado; Cristina tiene además capturas propias. No consta evidencia personal equivalente de Enrique, Alexandra e Ibai. |
| C1 | Docker y conectividad privada | Documentado | `evidencias/capturas-conformes/C1-ping.txt` (solo local; pendiente de publicación) | Docker y ping históricos disponibles. |
| C2 | IP privada y MTU 1450 | Documentado | `evidencias/capturas-conformes/C2-cluster.txt` (solo local; pendiente de publicación) | red-g5 ingress con MTU 1450, nodos por IP privada. |
| C3 | Manager líder y 3 workers activos | Parcial | `evidencias/capturas-conformes/C3-nodos.txt` (solo local; pendiente de publicación) | Tres managers: la captura declara NO CORRECTO. El 9/11 worker2-g5 figura líder en registro; no cumple topología solicitada. |
| C4 | Overlay propia para servicios | Documentado | `evidencias/capturas-conformes/C4-red.txt` (solo local; pendiente de publicación) | red-app-g5 separada de ingress y con MTU 1450. |
| D1 | Imagen propia identificable, 1.0/2.0 | Documentado | [construir-f1.sh](../../app/construir-f1.sh) | Código genera ambas versiones, identidad del contenedor y registro de publicación/descarga. Docker Hub no consultado de nuevo. |
| D2 | 4 réplicas, red y reinicio | Documentado | [stack.yml](../../app/stack.yml) | Fichero y registro D2-servicio con 4/4; actualización y rollback start-first. |
| D3 | Navegador en 4 IP públicas | Parcial | [D3-registro.txt](../../evidencias/D3-registro.txt) | Navegación y capturas históricas existen; completar comentario normativo y direcciones vigentes para entrega. |
| E1 | Balanceo | Parcial | `evidencias/capturas-conformes/E1-balanceo.txt` (solo local; pendiente de publicación) | Hay respuestas de distintos contenedores y captura; completar secuencia antes/durante/después exigida por Guía para fase 5. |
| E2 | Escalar 8,12,2 | Parcial | [registro.txt](../../evidencias/F4-E2/registro.txt) | Estados 8/8,12/12,2/2 y retorno 4/4 registrados; faltan capturas normativas de secuencia. No ocultar tiempos de espera. |
| E3 | Eliminar contenedor y autorreparar | Parcial | [registro.txt](../../evidencias/F4-E3/registro.txt) | Recuperación documentada; completar capturas normativas antes/durante/después y conservar fallos de sonda. |
| E4 | Caída worker, web disponible | Parcial | [E4-E5.txt](../../evidencias/prototipo/E4-E5.txt) | Prueba histórica con portal provisional y textos; completar demostración y capturas. Repetir con web final es propuesta de cierre, no requisito literal de repetir. |
| E5 | Reincorporar, reequilibrar, reiniciar lab | Parcial | [E5-verificacion-final.txt](../../evidencias/E5-verificacion-final.txt) | Registros de recuperación y captura E5-estado; falta secuencia completa normativa de fase 5. |
| E6 | Drain y reactivación | Parcial | [registro.txt](../../evidencias/F4-E6/registro.txt) | Estados y retorno registrados; faltan capturas normativas de secuencia. |
| E7 | Actualizar sin corte y rollback | Parcial | [registro.txt](../../evidencias/F3-actualizacion/registro.txt) | Actualización, navegación y rollback registrados; completar secuencia normativa y conservar las sondas como evidencia histórica. |
| E8 | Nuevo líder desde otro nodo | Parcial | [E8-eleccion.txt](../../evidencias/prototipo/E8-eleccion.txt) | Promoción/elección históricas; falta captura normativa durante caída y listado desde otro manager dentro de la secuencia. |
| F1 | Privado, colaboradores y profesor | Parcial | [F1-repositorio.txt](../../evidencias/capturas-conformes/F1-repositorio.txt) | Cuatro cuentas identificadas en documentación; falta acreditar profesor invitado antes de fecha límite. Permisos actuales no consultados. |
| F2 | Commits y PR de todos | Parcial | [GESTION.md](../../GESTION.md) | Cristina y Enrique contribuyen; Alexandra e Ibai sin commits propios ni PR. PR #2 apunta a integración; PR #1 apunta a main. |
| F3 | README con resumen y enlaces | Documentado | [README.md](../../README.md) | Contenido presente; validador local de enlaces sin errores. |
| F4 | Estructura requerida | Documentado | [README.md](../../README.md) | Carpetas presentes en integración. Los originales no exigen main ni merge: entregar la estructura en la rama acordada es suficiente para este requisito. |
| F5 | Devcontainer y Codespace | Documentado | [devcontainer.json](../../.devcontainer/devcontainer.json) | AWS CLI y Terraform definidos y captura F5-entorno disponible. |
| F6 | Terraform funcional | Documentado | [main.tf](../../terraform/main.tf) | Código y registros de validate/apply disponibles; no se ha vuelto a ejecutar Terraform en esta revisión. |
| F7 | Scripts comentados | Documentado | [actualizar-ips.sh](../../scripts/actualizar-ips.sh) | Scripts de consultas, comprobaciones, IPs y despliegue con comentarios. |
| F8 | Mapa propio de arquitectura | Documentado | [arquitectura.md](../../diagramas/arquitectura.md) | Mapa y PNG disponibles, explícitamente históricos; actualizar roles cuando se acuerde topología final. |
| F9 | Informe extenso fases 0–5 | Parcial | [PROYECTO.md](../../PROYECTO.md) | Informe extenso local, pero faltan evidencias y parte no está en remoto. |
| F10 | Capturas normativas y comentadas | Parcial | [INDICE.md](../../evidencias/capturas-conformes/INDICE.md) | Hay 32 entradas en manifiesto; no todas acreditan éxito, y faltan secuencias y consola. Capturas personales sin comentario. |
| F11 | Reparto y reflexión | Parcial | [GESTION.md](../../GESTION.md) | Reparto y responsables presentes; reflexión con POR COMPLETAR. Trello y actas semanales no son requisitos del profesor. |
| F12 | Sin credenciales, privadas ni estado | Verificación limitada | [.gitignore](../../.gitignore) | Exclusiones presentes y sin tfstate/pem/tfvars reales en listado versionado consultado. No se ha repetido análisis exhaustivo del historial; hacer barrido antes de publicar. Las públicas sí las exige Guía. |
| F13 | Práctica individual | Pendiente | [README.md](../../practica-individual/README.md) | Solo instrucciones y plantilla; no confundir documentos individuales de esta revisión con la práctica EC2 previa. |
| G1 | Exposición 10 min y demo | Pendiente | [DEFENSA.md](../../entrega/DEFENSA.md) | Material preparado; exposición, reparto explicado y caída de nodo en directo todavía no acreditados. |
| G2 | Preguntas individuales | Pendiente | [DEFENSA.md](../../entrega/DEFENSA.md) | 2 o 3 preguntas a cualquier miembro sobre cualquier parte del proyecto el día de exposición; no se acredita con documentación. |
| G3 | Demostración individual | Pendiente | [DEFENSA.md](../../entrega/DEFENSA.md) | Demostración técnica individual que solicite el profesor a cualquier miembro durante la evaluación. |

## Condiciones adicionales de la Guía, sin añadir criterios

Estas condiciones completan la lectura de los 42 ítems de la Rúbrica. La comprobación del contenido se ha repetido con ambos originales completos; no se han ejecutado pruebas en AWS.

| Criterios relacionados | Condición de la Guía | Contraste documental |
| --- | --- | --- |
| A1, A2, F6, F13 | us-east-1, VPC por defecto; partir de EC2 Ubuntu 22.04; manager t3.medium/20 GB y tres workers t3.small/10 GB | Variables, búsqueda de AMI y VPC en Terraform corresponden a esos valores. La documentación de práctica previa sigue pendiente. |
| A3, B5 | Un único SG; 22 desde aula/alumno, 80 y 8080 desde Internet; 2377 TCP, 7946 TCP/UDP, 4789 UDP e ICMP entre nodos | El código define un grupo con puertos internos restringidos al propio grupo. También permite SSH interno para el salto. La regla temporal posterior y consola siguen pendientes de cierre. |
| A4, B1, B4 | Hostname por nodo, Europe/Madrid, Docker y claves públicas; sin root ni contraseña | El bootstrap contiene estas configuraciones; registros de arranque, endurecimiento y claves disponibles. Guía reserva vockey y Rúbrica pide sustituirla: aclaración pendiente. |
| C2, C4 | Inicializar Swarm en la IP privada del manager; ingress overlay personalizada red-g5 con MTU 1450 y red propia para servicios | Scripts y registros distinguen red-g5 ingress de red-app-g5. El estado de roles se evalúa en C3 y la prueba de promoción en E8. |
| D1, D2, F4 | Docker Hub 1.0/2.0; cuatro réplicas en puerto 80; /app con Dockerfile, código de ambas versiones y script Swarm; /config con plantilla y configuraciones aplicadas | Los ficheros existen; construir-f1.sh genera las dos versiones desde el código base. Las pruebas y capturas pendientes siguen en D3 y E1–E8. |
| E1–E8, F10 | Capturas antes/durante/después, mientras una sonda consulta cada segundo; hostname, fecha/hora y comentario de prueba, resultado y autoría; sin credenciales ni privadas | Se distingue evidencia histórica de las secuencias normativas aún incompletas. E5 es explícito en Rúbrica; los originales no fijan 16 capturas personales SSH. |
| F2, F5 | Codespace principal con AWS CLI/Terraform; terminales secundarios Linux, como WSL o Git Bash, para clonar y contribuir mediante Git y PR | Devcontainer disponible. La PR de Enrique consta; sus capturas SSH son de PowerShell y no demuestran el entorno Linux usado para contribuir. Ese punto sigue sin acreditar. |
| F7–F11, F13 | Scripts comentados, diagrama, documentación de práctica previa, informe de fases 0–5 y gestión con reparto y reflexión | Existen scripts, diagrama e informe; reflexión y práctica previa pendientes. Los cuatro documentos individuales no sustituyen F13. |
| G1, G2, G3 | Exposición de 10 minutos con arquitectura, código, reparto y caída en directo; 2 o 3 preguntas sobre cualquier parte y demostración técnica individual solicitada | Solo hay material preparatorio: los tres ítems se acreditan durante la exposición. |

La discrepancia de pesos se conserva sin estimar una nota: A–E suman 6 puntos en ambos originales, pero la Guía distribuye 1,5/1/0,8/0,7/2 y la Rúbrica 2/1/1/0,5/1,5. F y G valen 2 puntos cada uno. Se usa la Rúbrica para identificar los 42 ítems, sin suponer un peso igual dentro de cada bloque.
