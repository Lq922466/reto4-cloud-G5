# Defensa de RETO 4 CLOUD · Grupo 5

Material para ensayar la exposición de 10 minutos y las preguntas del profesor. Acompaña a la
[presentación](presentacion-cloud-g5.pptx), que lleva este mismo guion en las notas del orador.

**Antes de usarlo:**

- **Asignad los papeles.** A, B, C y D son etiquetas: el reparto debe decidirlo el grupo, y los nombres de la portada están sin completar.
- **Hablad solo de lo que podáis explicar.** Adaptad el guion a lo que hizo cada uno y no os atribuyáis trabajo ajeno.
- **Revisadlo con la Guía y la Rúbrica,** que no estaban disponibles al prepararlo. Pueden cambiar el tiempo o el contenido exigido.

## Reparto de los 10 minutos

| Tiempo | Quién | Diapositivas | Tema | Evidencia de apoyo |
| --- | --- | --- | --- | --- |
| 0:00–2:15 | Integrante A | 1–3 | Reto, resultado y arquitectura | [Diagrama](../diagramas/arquitectura.png), [gestión](../GESTION.md) |
| 2:15–4:30 | Integrante B | 4–5 | Terraform, seguridad y SSH | [Reglas](../evidencias/capturas-terminal/A3-grupo-seguridad.png), [A6](../evidencias/A6-apply.txt) |
| 4:30–6:45 | Integrante C | 6–7 | Swarm, redes, web e imágenes | [Nodos](../evidencias/capturas-terminal/C3-nodos.png), [D3](../evidencias/D3-registro.txt) |
| 6:45–10:00 | Integrante D | 8–10 | Demostración, pruebas, límites y cierre | [Estado final](../evidencias/capturas-terminal/estado-final.png), [E4 y E8](../evidencias/auditoria/E4-E8.md) |

## Guion

### Diapositiva 1 · Portada (Integrante A, 0:20)

Buenos días. Somos el grupo 5 y vamos a presentar cómo hemos desplegado en AWS la web del Gran Premio de Euskadi, con infraestructura como código y un clúster de Docker Swarm.

### Diapositiva 2 · Objetivo y resultado (Integrante A, 0:50)

El reto consistía en publicar la web del evento en una infraestructura reproducible y capaz de tolerar fallos. El resultado que comprobamos por última vez fue este: cuatro instancias EC2, un servicio con cuatro de cuatro réplicas, dos versiones de la imagen en Docker Hub y respuesta HTTP 200 por las cuatro IP públicas. De los 42 criterios que revisamos, 29 están completados, 9 son parciales y 4 están pendientes, y al final os explicaremos por qué.

### Diapositiva 3 · Arquitectura (Integrante A, 1:05)

Este es el mapa. Desde Codespaces gestionamos la infraestructura con Terraform y accedemos por SSH con una regla limitada a una única IP. El navegador entra por el puerto 80 de cualquiera de las cuatro IP públicas, y la malla de enrutamiento de Swarm reparte la petición entre las réplicas. Un detalle importante: los nombres son los de la creación, pero los roles cambiaron. Para probar la elección de líder promovimos worker1 y worker2, así que hoy hay tres managers y solo worker3 es un worker puro.

### Diapositiva 4 · Terraform (Integrante B, 1:10)

La infraestructura está en la carpeta terraform: variables, proveedor, recursos y salidas. Definimos un grupo de seguridad, un manager t3.medium y tres workers t3.small, que salen de un único recurso con count. Cada nodo se configura al arrancar con una plantilla: nombre, zona horaria, claves públicas, SSH y Docker. Primero validamos y revisamos el plan, y después aplicamos: cinco recursos creados. Para probar un cambio controlado añadimos una etiqueta al manager. El plan dio cero altas, un cambio y cero destrucciones, y un plan posterior confirmó que no quedaban cambios. La destrucción no la hemos ejecutado, porque eliminaría el clúster.

### Diapositiva 5 · Seguridad y SSH (Integrante B, 1:05)

El grupo de seguridad solo abre al exterior el puerto 80, el 8080 y el SSH, y este último limitado a una IP con máscara 32. Los puertos de Swarm y el ICMP solo se aceptan desde el propio grupo. En SSH usamos alias, y llegamos a los workers por su IP privada, saltando por el manager. El acceso de root y por contraseña están desactivados, y los permisos son 700 y 600. Nos queda algo por completar: las claves individuales de cada integrante. Además, en el repositorio no hay claves, credenciales ni estado de Terraform: lo comprobamos revisando todo el historial.

### Diapositiva 6 · Swarm y redes (Integrante C, 1:05)

Comprobamos el ping por IP privada entre todos los nodos y formamos el clúster anunciando la dirección privada del manager. Creamos dos redes overlay: red-g5, que es la de ingress, y red-app-g5, para la aplicación. Ambas tienen MTU 1450, porque la red overlay encapsula el tráfico y añade cabeceras. Tener tres managers nos da cuórum: con tres, el clúster sigue gestionándose si cae uno, porque los otros dos siguen siendo mayoría.

### Diapositiva 7 · Web e imágenes (Integrante C, 1:10)

La web se empaqueta sobre nginx alpine. Al arrancar, cada contenedor genera un archivo con su versión y su identificador, y eso nos permite ver qué réplica responde. Publicamos dos etiquetas en Docker Hub, la 1.0 y la 2.0, que añade una página de estado. Antes de desplegar comprobamos que los tres workers las descargaban sin sesión y con el mismo contenido que habíamos construido. La pila define cuatro réplicas y una actualización progresiva que arranca cada réplica nueva antes de retirar la anterior. En pantalla veis la web servida por una de las IP.

### Diapositiva 8 · Demostración (Integrante D, 1:30)

Vamos a verlo funcionando. Primero, el estado de los nodos y del servicio: cuatro nodos Ready y Active, y cuatro de cuatro réplicas. Ahora, varias peticiones a identidad.txt: cambia el identificador del contenedor, así que el balanceo funciona. Y aquí, la web en el navegador. [Si el laboratorio no está disponible:] el laboratorio no está disponible ahora mismo, así que os enseñamos las capturas de la última comprobación, con su fecha y hora.

### Diapositiva 9 · Pruebas de orquestación (Integrante D, 1:00)

Con la web definitiva probamos el balanceo, el escalado a 8, 12, 2 y 4 réplicas, la eliminación de un contenedor, el drain de un nodo, y la actualización a 2.0 con su rollback. También comprobamos que el clúster sobrevivía al reinicio del laboratorio. En el escalado registramos dos tiempos de espera aislados al reducir de 12 a 2 réplicas, y no hemos determinado su causa. La caída de un worker y la elección de líder solo se hicieron con el portal provisional: por eso las consideramos parciales.

### Diapositiva 10 · Límites y cierre (Integrante D, 0:45)

Preferimos ser claros con lo que falta: la destrucción con Terraform, las claves individuales, las prácticas individuales y repetir esas dos pruebas si se nos pide. Parte del trabajo técnico se hizo con asistentes de IA, y queda declarado en la documentación. En resumen: una infraestructura reproducible, un servicio que se recupera y evidencias reales de lo que afirmamos. Muchas gracias. Estamos a vuestra disposición para las preguntas.

## Demostraciones

### Preparación, el mismo día

1. Iniciar Learner Lab (**Start Lab**) y esperar al indicador verde.
2. Copiar las credenciales nuevas de **AWS Details** a `~/.aws/credentials` en Codespaces.
3. Obtener las IP públicas nuevas, porque cambian con cada reinicio:

   ```bash
   aws ec2 describe-instances --region us-east-1 \
     --filters 'Name=tag:Name,Values=manager-g5,worker?-g5' 'Name=instance-state-name,Values=running' \
     --query 'Reservations[].Instances[].[Tags[?Key==`Name`]|[0].Value,PublicIpAddress]' --output table
   ```

4. Poner la IP nueva de manager-g5 en `HostName` de `config/ssh.local`.
5. Comprobar la IP de salida con `curl https://checkip.amazonaws.com`. Si no es la de la regla SSH, hay que actualizar la regla: es un cambio en
   AWS que debe autorizar el responsable.
6. Verificar antes de empezar, sin cambiar nada:

   ```bash
   bash scripts/verificar-despliegue.sh config/ssh.local innnx/reto4-f1 1.0
   ```

7. Abrir en pestañas la web por sus cuatro IP, y tener preparadas las capturas del plan B.

### Demostraciones que no cambian nada

| # | Qué se muestra | Comando | Resultado esperado | Plan B |
| --- | --- | --- | --- | --- |
| 1 | Nodos y servicio | `ssh -F config/ssh.local manager-g5 'docker node ls; docker service ls'` | 4 nodos Ready/Active y 4/4 | [Estado final](../evidencias/capturas-terminal/estado-final.png) |
| 2 | Réplicas | `ssh -F config/ssh.local manager-g5 'docker service ps --filter desired-state=running reto4_web'` | Cuatro tareas | [Pila y servicio](../evidencias/capturas-terminal/D2-pila-servicio.png) |
| 3 | Balanceo | `for i in 1 2 3 4 5 6; do curl -s http://IP/identidad.txt; done` | Varios contenedores | [Reparto](../evidencias/capturas-terminal/E1-reparto-peticiones.png) |
| 4 | Web | Abrir `http://IP/` en las cuatro IP | La web en todas | [D3](../evidencias/D3-navegador-manager-g5.png) |
| 5 | Redes y MTU | `ssh -F config/ssh.local manager-g5 'docker network inspect --format "{{.Name}} {{.Ingress}} {{index .Options \"com.docker.network.driver.mtu\"}}" red-g5 red-app-g5'` | `red-g5 true 1450` y `red-app-g5 false 1450` | [C2](../evidencias/capturas-terminal/C2-red-ingress.png) y [C4](../evidencias/capturas-terminal/C4-red-aplicacion.png) |
| 6 | Salto SSH | `ssh -F config/ssh.local worker3-g5 'hostname; hostname -I'` | worker3-g5 y su IP privada | [Salto](../evidencias/capturas-terminal/B5-salto.png) |
| 7 | Endurecimiento | `ssh -F config/ssh.local manager-g5 'sudo sshd -T \| grep -E "^(permitrootlogin\|passwordauthentication) "'` | Ambos en `no` | [B4](../evidencias/capturas-terminal/B4-endurecimiento.png) |
| 8 | Reglas | Consola de EC2 → Security Groups → `reto4-cloud-g5` → Inbound rules | Reglas de la tabla del informe | [A3](../evidencias/capturas-terminal/A3-grupo-seguridad.png) |

### Demostraciones que cambian el servicio

Hacedlas solo si el profesor las pide, y con la verificación anterior correcta. Cada una incluye cómo volver al estado de partida.

| # | Qué se muestra | Comandos en el manager | Volver al estado | Plan B |
| --- | --- | --- | --- | --- |
| 9 | Escalado (E2) | `docker service scale reto4_web=8` | `docker service scale reto4_web=4` | [F4-E2](../evidencias/F4-E2/) |
| 10 | Autorreparación (E3) | En un nodo con tarea: `docker ps`, y `docker rm -f ID` | Swarm la reemplaza solo | [F4-E3](../evidencias/F4-E3/) |
| 11 | Drain (E6) | `docker node update --availability drain worker3-g5` | `docker node update --availability active worker3-g5` | [F4-E6](../evidencias/F4-E6/) |
| 12 | Actualización (E7) | `docker service update --image innnx/reto4-f1:2.0 reto4_web` | `docker service rollback reto4_web` | [F3-actualizacion](../evidencias/F3-actualizacion/) |

**No hagáis en la defensa, salvo que os lo pida el profesor:** detener instancias (E4 y E8), porque interrumpe más y sus IP cambian, ni `terraform destroy`, que elimina el clúster.

## Preguntas del profesor

Respuestas de repaso. Cada integrante debe poder explicarlas con sus propias palabras.

### Terraform e infraestructura

**¿Por qué Terraform y no crear las instancias a mano?**
Porque la infraestructura queda descrita en código, versionada y reproducible, y el plan muestra qué cambiará antes de aplicarlo.

**¿Qué es el estado de Terraform y por qué no está en Git?**
Es el archivo que relaciona el código con los recursos reales. Puede contener datos sensibles, así que se excluye de Git. Sin él, Terraform no sabría qué recursos gestiona y no podría destruirlos de forma ordenada.

**¿Qué hace `count` en los workers?**
Crea varias instancias a partir de un solo bloque, con el índice para nombrarlas: worker1, worker2 y worker3.

**¿Qué hizo exactamente el cambio de A6?**
Añadió la etiqueta `PruebaA6=reto4-g5` a manager-g5. El plan fue de 0 altas, 1 cambio y 0 destrucciones, y un plan posterior no propuso cambios.

**¿Por qué no habéis ejecutado `terraform destroy`?**
Porque eliminaría el clúster y lo necesitamos para la defensa. Tenemos el plan de destrucción de los 5 recursos, pero el criterio A6 sigue parcial hasta ejecutarlo.

**¿Por qué cambian las IP públicas?**
Porque son IP públicas asignadas automáticamente, sin IP elástica. Al detener y arrancar una instancia recibe otra. Las privadas se mantienen, y Swarm usa esas.

### Seguridad y SSH

**¿Para qué sirve cada puerto de Swarm?**
2377/TCP, gestión del clúster. 7946/TCP y UDP, comunicación entre nodos. 4789/UDP, tráfico de la red overlay con VXLAN.

**¿Por qué esos puertos solo aceptan el propio grupo de seguridad?**
Porque solo los necesitan los nodos del clúster. Exponerlos permitiría a terceros intentar interactuar con Swarm.

**¿Por qué tenéis abierto el 8080?**
Se abrió en la configuración inicial, pero la pila solo publica el 80, así que ningún servicio de la pila lo usa. Hay que contrastarlo con la Guía.

**¿Qué es ProxyJump y por qué se usa?**
Permite llegar a un nodo pasando por otro. Conectamos al manager por su IP pública y, desde él, a los workers por su IP privada.

**¿Cómo comprobáis que root y la contraseña están desactivados?**
Con `sudo sshd -T`, que muestra la configuración efectiva: `permitrootlogin no` y `passwordauthentication no`, en los cuatro nodos.

**¿Por qué permisos 700 y 600?**
Para que solo el propietario acceda a `.ssh` y a sus claves. OpenSSH rechaza claves con permisos demasiado abiertos.

**¿Qué pasa con `vockey`?**
Sigue autorizada junto a la clave del Codespace. La revisión anterior anotó una diferencia entre la Guía y la Rúbrica, y está pendiente de aclarar con el profesor.

### Docker Swarm y redes

**¿Qué diferencia hay entre un manager y un worker?**
Los managers mantienen el estado del clúster y deciden dónde van las tareas. Los workers ejecutan tareas. Aquí los managers también ejecutan réplicas.

**¿Por qué tres managers y no dos?**
Raft necesita mayoría. Con tres se tolera perder uno; con dos, perder uno deja sin mayoría y no se puede gestionar el clúster.

**¿Por qué se llaman worker1 y worker2 si son managers?**
Es el nombre de creación. Los promovimos antes de E8 para tener cuórum y probar la elección de líder.

**¿Por qué el líder es ahora worker1?**
Primero E8 cambió el líder a worker2. En la comprobación posterior al reinicio del laboratorio ya era worker1. El líder lo elige Raft y puede cambiar cuando se reinician los nodos.

**¿Qué es la malla de enrutamiento?**
Permite que cualquier nodo reciba la petición en el puerto publicado y la reenvíe a una réplica, aunque ese nodo no aloje ninguna.

**¿Qué diferencia hay entre `red-g5` y `red-app-g5`?**
`red-g5` es la red ingress, usada por la malla de enrutamiento. `red-app-g5` es la overlay de la aplicación, a la que se conecta el servicio.

**¿Por qué MTU 1450?**
La overlay encapsula con VXLAN y añade unos 50 bytes de cabeceras. Con 1450 el paquete encapsulado cabe en 1500 sin fragmentarse.

**¿Habéis comprobado la MTU dentro de un contenedor?**
No. Lo comprobado es la configuración de las redes, con `docker network inspect`.

### Web e imágenes

**¿Qué hay en la imagen?**
`nginx:alpine`, los archivos estáticos de la web, un script que genera `identidad.txt` al arrancar y un healthcheck.

**¿Por qué se genera `identidad.txt` al arrancar y no al construir?**
Porque el identificador depende de cada contenedor. Si estuviera en la imagen, sería igual en todas las réplicas.

**¿Qué diferencia hay entre una etiqueta y un digest?**
La etiqueta es un nombre que puede moverse. El digest identifica el contenido exacto. Por eso guardamos los digests de 1.0 y 2.0.

**¿Cómo sabéis que la imagen desplegada es la definitiva?**
El portal provisional también respondía `version=1.0`, así que comprobamos además la imagen de cada tarea y recorrimos la web con un navegador.

**¿Qué significa `order: start-first`?**
Que Swarm arranca la réplica nueva y, cuando está sana, retira la anterior. Se reduce el riesgo de quedarse con menos réplicas durante la actualización.

### Orquestación

**¿Qué pasó con los dos tiempos de espera de E2?**
Al reducir de 12 a 2 réplicas, una muestra de dos IP superó el límite de 0,9 s, y las siguientes fueron correctas. No hemos determinado la causa, y no afirmamos disponibilidad continua.

**¿Qué significa `5/4` en E4?**
Es transitorio: la tarea del nodo caído sigue contada hasta que Swarm puede confirmar su apagado. Al reincorporarse el nodo, volvió a 4/4.

**Después de E4, ¿por qué el nodo no recupera tareas solo?**
Swarm no reequilibra las tareas que ya funcionan. Hay que forzarlo, por ejemplo con `docker service update --force`.

**¿Qué diferencia hay entre Drain y parar un nodo?**
Drain retira las tareas de forma ordenada y el nodo sigue activo. Al parar un nodo, Swarm detecta la caída y reprograma sus tareas después.

**¿Por qué E4 y E8 están como parciales?**
Se hicieron con el portal provisional. En E8 no registramos el estado del clúster durante la parada: la elección se ve comparando antes y después, y la sonda tiene 34 segundos sin muestras.

**¿Podéis demostrar que la instancia de E8 llegó a detenerse?**
De forma indirecta: tenemos la solicitud de parada y su IP pública cambió. El registro no contiene el estado `stopped`, a diferencia de E4.

**¿Cuánto tardó la elección de líder?**
No lo sabemos, porque no se midió.

### Gestión y uso de IA

**¿Quién hizo cada parte?**
Respondedlo cada uno con vuestra participación real. En el repositorio, hasta ahora, solo constan commits de Innnx y Codex.

**¿Habéis usado inteligencia artificial?**
Sí. El historial muestra commits con Codex y con Claude Code, y los cambios sobre el servicio y AWS del 5 de noviembre se hicieron con autorización expresa. Cada integrante debe poder explicar lo que presenta.

**¿Qué mejoraríais con más tiempo?**
Técnicamente: HTTPS, estado remoto de Terraform con bloqueo, IP elásticas o balanceador, y monitorización. La reflexión de organización debe aportarla el grupo.

## Consejos para el ensayo

- Cronometrad el guion: leído a ritmo normal, debe quedar por debajo de 10 minutos. Si os pasáis, recortad la diapositiva 5 o la 7.
- Tened un responsable de la demostración y otro de cambiar de diapositiva.
- Si algo falla, id directamente al plan B: es mejor una captura real con fecha que improvisar.
- Decid la hora de las capturas: el estado puede haber cambiado desde entonces.
