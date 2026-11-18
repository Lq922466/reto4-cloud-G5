# Defensa de RETO 4 CLOUD · Grupo 5

Material para ensayar la exposición de 10 minutos y las preguntas del profesor. Acompaña a la
[presentación](presentacion-cloud-g5.pptx), que lleva este mismo guion en las notas del orador.

**Antes de usarlo:**

- **Asignad los papeles.** A, B, C y D son etiquetas: el reparto debe decidirlo el grupo, y los nombres de la portada están sin completar.
- **Hablad solo de lo que podáis explicar.** Adaptad el guion a lo que hizo cada uno y no os atribuyáis trabajo ajeno.
- **Lo que exige la Guía.** En grupo, 10 minutos: arquitectura, código, reparto de tareas y **una demostración en directo de caída de un nodo**. Individualmente,
  2 o 3 preguntas a cualquier miembro sobre cualquier parte y una demostración técnica en vivo.
- **Topología.** Desde el 18 de noviembre, el guion describe la topología de la Guía: un manager líder y tres workers, restaurada el 9 de noviembre tras E8. **La presentación aún no está actualizada:** sus diapositivas 3, 5 y 6 y sus notas describen tres managers y las claves individuales sin instalar. Corregidlas antes de ensayar y comprobad el clúster el mismo día.

## Reparto de los 10 minutos

La organización del equipo encarga la presentación final a todos, pero no asigna estas partes. «Integrante A» a «D» son
marcadores: el grupo debe decidir qué parte presenta Cristina, Enrique, Alexandra e Ibai.

| Tiempo | Quién | Diapositivas | Tema | Evidencia de apoyo |
| --- | --- | --- | --- | --- |
| 0:00–2:15 | Integrante A | 1–3 | Reto, resultado, reparto de tareas y arquitectura | [Diagrama](../diagramas/arquitectura.png), [gestión](../GESTION.md) |
| 2:15–4:30 | Integrante B | 4–5 | Código de Terraform, seguridad y SSH | [Reglas](../evidencias/capturas-terminal/A3-grupo-seguridad.png), [A6](../evidencias/A6-apply.txt) |
| 4:30–6:45 | Integrante C | 6–7 | Swarm, redes, web e imágenes. **Al empezar: apagar worker3-g5** | [Nodos tras corregir C3](../PROYECTO.md#34-validación-de-los-nodos-y-de-sus-roles-c3), [D3](../evidencias/D3-registro.txt) |
| 6:45–10:00 | Integrante D | 8–10 | Caída de un nodo en directo, pruebas, límites y cierre | [Estado final](../evidencias/capturas-terminal/estado-final.png), [E4 y E8](../evidencias/auditoria/E4-E8.md) |

## Guion

### Diapositiva 1 · Portada (Integrante A, 0:20)

Buenos días. Somos el grupo 5 y vamos a presentar cómo hemos desplegado en AWS la web del Gran Premio de Euskadi, con infraestructura como código y un clúster de Docker Swarm.

### Diapositiva 2 · Objetivo, resultado y reparto (Integrante A, 0:50)

El reto consistía en publicar la web del evento en una infraestructura reproducible y capaz de tolerar fallos. El resultado que comprobamos fue este: cuatro instancias EC2, un servicio con cuatro de cuatro réplicas, dos versiones de la imagen en Docker Hub y respuesta HTTP 200 por las cuatro IP públicas. Nos repartimos el trabajo así: [explicad quién hizo cada parte, con los datos reales de GESTION.md].

### Diapositiva 3 · Arquitectura (Integrante A, 1:05)

Este es el mapa. Desde Codespaces gestionamos la infraestructura con Terraform y accedemos por SSH con una regla limitada a una única IP. El navegador entra por el puerto 80 de cualquiera de las cuatro IP públicas, y la malla de enrutamiento de Swarm reparte la petición entre las réplicas. El clúster tiene un manager, que es el líder, y tres workers, como pide la Guía. Para probar la elección de líder promovimos temporalmente worker1 y worker2, y después los volvimos a bajar a workers.

### Diapositiva 4 · Terraform y código (Integrante B, 1:10)

La infraestructura está en la carpeta terraform: variables, proveedor, recursos y salidas. En pantalla veis el código de los workers: es un único recurso, multiplicado con count, y los nombres se generan con el índice y el grupo. Cada nodo se configura al arrancar con una plantilla: nombre, zona horaria, claves públicas, SSH y Docker. Primero validamos y revisamos el plan, y después aplicamos: cinco recursos creados. Para probar un cambio controlado añadimos una etiqueta al manager. El plan dio cero altas, un cambio y cero destrucciones. Y aprendimos algo importante: como la imagen de Ubuntu se elige como «la más reciente», cuando Canonical publicó una nueva el plan pasó a proponer sustituir las cuatro instancias. Por eso nunca aplicamos un plan sin revisarlo.

### Diapositiva 5 · Seguridad y SSH (Integrante B, 1:05)

El grupo de seguridad solo abre al exterior el puerto 80, el 8080 y el SSH, y este último limitado a una IP con máscara 32. Los puertos de Swarm y el ICMP solo se aceptan desde el propio grupo. En SSH usamos alias, y llegamos a los workers por su IP privada, saltando por el manager. El acceso de root y por contraseña están desactivados, y los permisos son 700 y 600. Cada integrante tiene su propia clave instalada en los cuatro nodos; nos queda que tres de nosotros entremos también en los workers. Además, en el repositorio no hay claves, credenciales ni estado de Terraform: lo comprobamos revisando todo el historial.

### Diapositiva 6 · Swarm y redes (Integrante C, 1:05)

Comprobamos el ping por IP privada entre todos los nodos y formamos el clúster anunciando la dirección privada del manager. Creamos dos redes overlay: red-g5, que es la de ingress, y red-app-g5, para la aplicación. Ambas tienen MTU 1450, porque la red overlay encapsula el tráfico y añade cabeceras. En funcionamiento normal hay un solo manager. Para la prueba de alta disponibilidad de managers promovemos dos workers: con tres managers, si cae uno, los otros dos siguen siendo mayoría y eligen un líder nuevo.

### Diapositiva 7 · Web e imágenes (Integrante C, 1:10)

La web se empaqueta sobre nginx alpine. Al arrancar, cada contenedor genera un archivo con su versión y su identificador, y eso nos permite ver qué réplica responde. Publicamos dos etiquetas en Docker Hub, la 1.0 y la 2.0, que añade una página de estado. Antes de desplegar comprobamos que los tres workers las descargaban sin sesión y con el mismo contenido que habíamos construido. La pila define cuatro réplicas y una actualización progresiva que arranca cada réplica nueva antes de retirar la anterior. En pantalla veis la web servida por una de las IP.

### Diapositiva 8 · Demostración en directo: caída de un nodo (Integrante D, 1:30)

Vamos a ver la caída de un nodo en directo. Mientras hablaban mis compañeros, hemos dejado un script consultando la web cada segundo y hemos apagado worker3. Aquí veis el listado de nodos: worker3 aparece caído. Y aquí, las réplicas: Swarm ha reubicado su tarea en otro nodo. Mirad el script: la web sigue respondiendo, y aquí la tenéis en el navegador. Después volveremos a arrancar el nodo y se reincorporará al clúster. [Si el laboratorio no está disponible:] el laboratorio no está disponible ahora mismo, así que os enseñamos el registro de la prueba anterior, con su fecha y hora.

### Diapositiva 9 · Pruebas de orquestación (Integrante D, 1:00)

Además, con la web definitiva probamos el balanceo, el escalado a 8, 12, 2 y 4 réplicas, la eliminación de un contenedor, el drain de un nodo, y la actualización a 2.0 sin cortes con su rollback. También comprobamos que el clúster sobrevivía al reinicio del laboratorio. En el escalado registramos dos tiempos de espera aislados al reducir de 12 a 2 réplicas, y no hemos determinado su causa.

### Diapositiva 10 · Límites y cierre (Integrante D, 0:45)

Preferimos ser claros con lo que falta: [actualizad esta lista el día de la exposición]. Parte del trabajo técnico se hizo con asistentes de IA, y queda declarado en la documentación. En resumen: una infraestructura reproducible, un servicio que se recupera y evidencias reales de lo que afirmamos. Muchas gracias. Estamos a vuestra disposición para las preguntas.

## Demostraciones

### Preparación, el mismo día

1. Iniciar Learner Lab (**Start Lab**) y esperar al indicador verde.
2. Copiar las credenciales nuevas de **AWS Details** a `~/.aws/credentials` en Codespaces.
3. Comprobar el laboratorio, sin cambiar nada: `bash scripts/comprobar-laboratorio.sh`. Si la regla SSH no coincide con la IP actual, muestra los comandos exactos: es un cambio en AWS que debe autorizar Cristina.
4. Actualizar los alias: `bash scripts/actualizar-ips.sh`.
5. Comprobar que entra con el nombre corto: `ssh manager-g5 hostname`.
6. Verificar antes de empezar, sin cambiar nada:

   ```bash
   bash scripts/verificar-despliegue.sh config/ssh.local innnx/reto4-f1 1.0
   ```

7. Abrir en pestañas la web por sus cuatro IP, y tener preparadas las capturas del plan B.

### Demostración obligatoria: caída de un nodo

Requiere AWS activo, y solo debe hacerse el día de la exposición o en un ensayo autorizado. Ensayadla antes con el reloj en la mano: en la prueba E4, EC2 indicó `stopped` menos de dos minutos después de empezar.

1. **Antes de empezar:** dejad en una terminal el script, con la IP de un nodo que **no** vayáis a apagar:

   ```bash
   bash scripts/sondear-web.sh http://IP_DE_MANAGER/identidad.txt
   ```

2. **Al empezar la parte del Integrante C (4:30):** detened worker3-g5 en la consola de EC2 (Instance state → Stop), o con:

   ```bash
   aws ec2 stop-instances --region us-east-1 --instance-ids i-0446409b26cf0a662
   ```

3. **En la parte del Integrante D (6:45):** mostrad el estado:

   ```bash
   ssh -F config/ssh.local manager-g5 'docker node ls; docker service ls; docker service ps --filter desired-state=running reto4_web'
   ```

   **Se espera:** worker3-g5 `Down` y sus tareas reubicadas. El servicio puede mostrar `5/4` un momento, porque la tarea antigua sigue contada hasta confirmar su apagado.
4. **Mostrad el script y el navegador,** por la IP de un nodo activo.
5. **Después de la exposición:** arrancad de nuevo worker3-g5, cuya IP pública cambiará, y reequilibrad con `docker service update --force reto4_web`.

**Plan B:** el [registro de E4](../evidencias/prototipo/E4-worker-down.txt), indicando que se hizo con el portal provisional.

### Demostraciones que no cambian nada

| # | Qué se muestra | Comando | Resultado esperado | Plan B |
| --- | --- | --- | --- | --- |
| 1 | Nodos y servicio | `ssh -F config/ssh.local manager-g5 'docker node ls; docker service ls'` | 4 nodos Ready/Active, manager-g5 como único `Leader` y 4/4 | [Estado final](../evidencias/capturas-terminal/estado-final.png), del 5 de noviembre, cuando aún había tres managers |
| 2 | Réplicas | `ssh -F config/ssh.local manager-g5 'docker service ps --filter desired-state=running reto4_web'` | Cuatro tareas | [Pila y servicio](../evidencias/capturas-terminal/D2-pila-servicio.png) |
| 3 | Balanceo | `for i in 1 2 3 4 5 6; do curl -s http://IP/identidad.txt; done` | Varios contenedores | [Reparto](../evidencias/capturas-terminal/E1-reparto-peticiones.png) |
| 4 | Web | Abrir `http://IP/` en las cuatro IP | La web en todas | [D3](../evidencias/D3-navegador-manager-g5.png) |
| 5 | Redes y MTU | `ssh -F config/ssh.local manager-g5 'docker network inspect --format "{{.Name}} {{.Ingress}} {{index .Options \"com.docker.network.driver.mtu\"}}" red-g5 red-app-g5'` | `red-g5 true 1450` y `red-app-g5 false 1450` | [C2](../evidencias/capturas-terminal/C2-red-ingress.png) y [C4](../evidencias/capturas-terminal/C4-red-aplicacion.png) |
| 6 | Salto SSH | `ssh -F config/ssh.local worker3-g5 'hostname; hostname -I'` | worker3-g5 y su IP privada | [Salto](../evidencias/capturas-terminal/B5-salto.png) |
| 7 | Endurecimiento | `ssh -F config/ssh.local manager-g5 'sudo sshd -T \| grep -E "^(permitrootlogin\|passwordauthentication) "'` | Ambos en `no` | [B4](../evidencias/capturas-terminal/B4-endurecimiento.png) |
| 8 | Reglas | Consola de EC2 → Security Groups → `reto4-cloud-g5` → Inbound rules | Reglas de la tabla del informe | [A3](../evidencias/capturas-terminal/A3-grupo-seguridad.png) |

### Demostraciones que cambian el servicio

Pueden pedirse en la demostración individual. Hacedlas con la verificación anterior correcta. Cada una incluye cómo volver al estado de partida.

| # | Qué se muestra | Comandos en el manager | Volver al estado | Plan B |
| --- | --- | --- | --- | --- |
| 9 | Escalado (E2) | `docker service scale reto4_web=8` | `docker service scale reto4_web=4` | [F4-E2](../evidencias/F4-E2/) |
| 10 | Autorreparación (E3) | En un nodo con tarea: `docker ps`, y `docker rm -f ID` | Swarm la reemplaza solo | [F4-E3](../evidencias/F4-E3/) |
| 11 | Drain (E6) | `docker node update --availability drain worker3-g5` | `docker node update --availability active worker3-g5` | [F4-E6](../evidencias/F4-E6/) |
| 12 | Actualización (E7) | `docker service update --image innnx/reto4-f1:2.0 reto4_web` | `docker service rollback reto4_web` | [F3-actualizacion](../evidencias/F3-actualizacion/) |

**No ejecutéis `terraform destroy` en la defensa, salvo que lo pida el profesor:** elimina el clúster.

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
Añadió la etiqueta `PruebaA6=reto4-g5` a manager-g5. El plan fue de 0 altas, 1 cambio y 0 destrucciones, y el plan siguiente, ese mismo día, no propuso cambios. El 10 de noviembre el plan normal propone sustituir las instancias por la imagen de Ubuntu nueva: hay que fijar la imagen antes de volver a aplicar.

**¿Por qué no habéis ejecutado `terraform destroy`?**
Porque eliminaría el clúster, y cada requisito debe funcionar durante la corrección. Tenemos el plan de destrucción de los 5 recursos, pero A6 sigue parcial hasta ejecutarlo.

**¿Por qué cambian las IP públicas?**
Porque son IP públicas asignadas automáticamente, sin IP elástica. Al detener y arrancar una instancia recibe otra. Las privadas se mantienen, y Swarm usa esas.

### Seguridad y SSH

**¿Para qué sirve cada puerto de Swarm?**
2377/TCP, gestión del clúster. 7946/TCP y UDP, comunicación entre nodos. 4789/UDP, tráfico de la red overlay con VXLAN.

**¿Por qué esos puertos solo aceptan el propio grupo de seguridad?**
Porque solo los necesitan los nodos del clúster. Exponerlos permitiría a terceros intentar interactuar con Swarm.

**¿Por qué tenéis abierto el 8080?**
Porque la Guía pide abrir 80 y 8080 desde Internet. Nuestra pila solo publica el 80.

**¿Qué es ProxyJump y por qué se usa?**
Permite llegar a un nodo pasando por otro. Conectamos al manager por su IP pública y, desde él, a los workers por su IP privada.

**¿Cómo comprobáis que root y la contraseña están desactivados?**
Con `sudo sshd -T`, que muestra la configuración efectiva: `permitrootlogin no` y `passwordauthentication no`, en los cuatro nodos.

**¿Por qué permisos 700 y 600?**
Para que solo el propietario acceda a `.ssh` y a sus claves. OpenSSH rechaza claves con permisos demasiado abiertos.

**¿Qué pasa con `vockey`?**
Sigue autorizada, junto a la clave del Codespace y las cuatro claves personales. La Guía la deja como reserva y la Rúbrica pide sustituirla: [indicad lo que haya respondido el profesor].

### Docker Swarm y redes

**¿Qué diferencia hay entre un manager y un worker?**
Los managers mantienen el estado del clúster y deciden dónde van las tareas. Los workers ejecutan tareas. Aquí los managers también ejecutan réplicas.

**¿Por qué para E8 se necesitan tres managers y no dos?**
Raft necesita mayoría. Con tres se tolera perder uno; con dos, perder uno deja sin mayoría y no se puede gestionar el clúster.

**¿Qué pasó con los roles después de E8?**
worker1 y worker2 siguieron como managers, y Raft fue eligiendo líder con cada reinicio: worker2 tras E8, worker1 el 5 de noviembre, manager-g5 el 6 y de nuevo worker2 y worker1 el 9. Ese día los bajamos con `docker node demote`, primero el que no era líder, y manager-g5 quedó como único manager y líder.

**¿Qué es la malla de enrutamiento?**
Permite que cualquier nodo reciba la petición en el puerto publicado y la reenvíe a una réplica, aunque ese nodo no aloje ninguna.

**¿Qué diferencia hay entre `red-g5` y `red-app-g5`?**
`red-g5` es la red ingress, usada por la malla de enrutamiento. `red-app-g5` es la overlay de la aplicación, a la que se conecta el servicio.

**¿Por qué MTU 1450?**
La overlay encapsula con VXLAN y añade unos 50 bytes de cabeceras. Con 1450 el paquete encapsulado cabe en 1500 sin fragmentarse, lo que evita cuelgues o lentitud.

**¿Habéis comprobado la MTU dentro de un contenedor?**
Sí, el 6 de noviembre: dentro de los contenedores la interfaz mide 1400, 50 bytes menos que la red. Lo que pide la Guía es la MTU de la red, que es 1450, comprobada con `docker network inspect`.

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
Respondedlo cada uno con vuestra participación real. En `main`, a 18 de noviembre, constan commits de Cristina, con su identidad Innnx, de Codex y uno de Enrique, en la PR #2. Las PR #3, #4 y #5 son borradores preparados con Codex desde la cuenta de Cristina, pendientes de que cada uno los valide. La organización del equipo asigna el Producto 6, Cloud, a Cristina, pero la Guía pide que todos aporten commits y PR.

**¿Habéis usado inteligencia artificial?**
Sí. El historial muestra commits con Codex y con Claude Code, y los cambios sobre AWS, el servicio y GitHub se hicieron con autorización expresa de Cristina. Cada integrante debe poder explicar lo que presenta.

**¿Qué mejoraríais con más tiempo?**
Técnicamente: HTTPS, estado remoto de Terraform con bloqueo, IP elásticas o balanceador, y monitorización. La reflexión de organización debe aportarla el grupo.

## Consejos para el ensayo

- Cronometrad el guion: leído a ritmo normal, debe quedar por debajo de 10 minutos. Si os pasáis, recortad la diapositiva 5 o la 7.
- Tened un responsable de la demostración y otro de cambiar de diapositiva.
- Si algo falla, id directamente al plan B: es mejor una captura real con fecha que improvisar.
- Decid la hora de las capturas: el estado puede haber cambiado desde entonces.
