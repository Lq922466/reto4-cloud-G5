# Revisión de entrega RETO 4 CLOUD

Cotejo del 4 de noviembre de 2026 con la Guía CLOUD y la Rúbrica CLOUD del profesor. La verificación funcional se distingue de la evidencia exigida para la corrección. «Verificado en prototipo» se refiere al portal provisional que se desplegó, y la web final del grupo sigue pendiente. Un registro de comandos conserva una salida real y se identifica como tal. Las imágenes son capturas reales del navegador.

## Evidencias disponibles

- [Registro técnico recuperado de Codespaces](evidencias/revision-registro-tecnico.txt) — entorno, validación, plan, apply, arranque y orquestación.
- [E4 y reincorporación](evidencias/E4-E5-E8-registro.txt) y [elección y recuperación E8](evidencias/E8-eleccion-registro.txt).
- [Captura durante E4](evidencias/E4-web-worker-down.png), [captura tras reincorporar el worker](evidencias/E5-web-recuperado.png), [captura durante E8](evidencias/E8-web-parada.png) y [captura tras recuperar el manager](evidencias/E8-web-recuperado.png).
- Las cuatro capturas F4C están enlazadas en [PROYECTO.md](PROYECTO.md).

## Matriz por criterio

| Criterio | Estado | Comprobación o evidencia disponible | Pendiente para la entrega |
| --- | --- | --- | --- |
| F1 | Parcial | GitHub confirma repositorio privado, un administrador y tres cuentas con escritura. No hay invitaciones pendientes. | Confirmar quiénes son los integrantes y si el profesor tiene acceso. Guardar captura de Settings → Collaborators. |
| F2 | Parcial | El historial muestra un autor humano y Codex. La consulta de PR devolvió cero. | Revisar e integrar la rama mediante una PR. Cada integrante debe aportar commits y PR reales. |
| F3 | Parcial | README con resumen e instrucciones locales. | Actualizar instrucciones de despliegue final y enlace a las dos etiquetas de Docker Hub. |
| F4 | Verificado | En la rama de implementación existen terraform, app, config y .devcontainer. | Incluir la rama revisada en la entrega. |
| F5 | Verificado con registro | devcontainer.json incluye AWS CLI y Terraform. El registro técnico contiene sus versiones desde Codespaces. | Capturar terminal con hostname, hora y ambas versiones. |
| F6 | Verificado con registro | Terraform en el repositorio. Validación y despliegue reales de cinco recursos. | Adjuntar capturas de código y validación. |
| F7 | Verificado | Scripts versionados y comentados en scripts. | Mostrar los scripts usados durante la defensa. |
| F8 | Verificado | Mapa propio Mermaid en diagramas/arquitectura.md. | Mostrar el diagrama renderizado y revisar el papel de los tres managers tras E8. |
| F9 | Parcial | PROYECTO.md cubre Fases 0–5. El informe Word amplía procedimiento y pruebas. | Integrar los apartados y evidencias pendientes en el informe técnico final. |
| F10 | Parcial | Capturas web reales de F4C, E4/E5 y E8, y registros de terminal reales. | Completar capturas de consola y terminal por fase con fecha, autor, hostname cuando corresponda y comentario. |
| F11 | Pendiente | GESTION.md solo contiene una nota de seguimiento. | Completar reparto, responsables y reflexión con datos del grupo. |
| F12 | Verificado en archivos revisados | No se identificaron claves privadas, credenciales, estado ni planes en los archivos versionados inspeccionados. .gitignore excluye esos archivos. | Repetir la revisión antes de integrar la PR. |
| F13 | Pendiente | No existe /practica-individual en la rama de entrega. | Incorporar la documentación real de las prácticas individuales. |
| A1 | Verificado | Módulo /terraform con variables, proveedor, recursos y salidas. | Capturar árbol y validación. |
| A2 | Verificado con registro | Un manager t3.medium y tres workers t3.small a partir de un único recurso multiplicado, con etiquetas. Cuatro instancias desplegadas. | Capturar EC2 con etiquetas, tipos y controles superados. |
| A3 | Verificado en plan | SG único. SSH externo /32, TCP 80/8080 público, TCP 22 entre nodos para el salto, y 2377/7946/4789 e ICMP limitados al propio grupo. | Capturar Inbound rules en el SG de EC2. |
| A4 | Verificado con registro | Plantilla de inicio y cloud-init completado en cuatro nodos. Hostname, Europe/Madrid, Docker y clave pública probada. | Capturar salida de arranque por rol. Claves individuales en B1. |
| A5 | Verificado con registro | nodes devuelve IP pública, privada e ID. El registro E8 identifica la nueva IP del manager tras el arranque. | Capturar terraform output. Distinguir el último estado de Terraform de la IP actual consultada en EC2. |
| A6 | Parcial | Validación, plan y apply reales. Parar y arrancar una EC2 demuestra E4/E8, pero no acredita el cambio y destrucción con Terraform. | Obtener secuencia del cambio y de la destrucción con autorizaciones independientes. Capturar plan y apply ya ejecutados desde sus registros. |
| B1 | Parcial | La clave propia del Codespace funcionó en cuatro nodos. La política de vockey difiere entre guía y rúbrica. | Recoger claves públicas individuales y verificar accesos. Aclarar con el profesor si vockey se conserva como reserva o se sustituye. |
| B2 | Verificado con registro | Plantilla en /config y configuración local generada con alias. | Capturar alias y conexión ocultando material sensible. |
| B3 | Verificado con registro | Comandos en paralelo por SSH, sudo comprobado y copia SCP con SHA-256 coincidente. | Capturar el registro de comandos y copia. |
| B4 | Verificado con registro | sshd confirma root y contraseña deshabilitados. Permisos 700 y 600 comprobados. | Capturar salida de sshd y permisos, incluyendo el archivo de clave local cuando proceda. |
| B5 | Verificado con registro | Los tres workers respondieron por IP privada con ProxyJump. Tras E8 volvió a funcionar el salto. | Capturar conexión y configuración efectiva. |
| C1 | Verificado con registro | Docker 29.1.3 y ping entre IP privadas. | Capturar Docker y ping por rol. |
| C2 | Verificado con registro | Swarm por IP privada. Red ingress red-g5 con MTU 1450. | Capturar inspección de red y direcciones privadas. |
| C3 | Verificado con registro | Configuración inicial de un manager líder y tres workers Ready/Active. E8 dejó tres managers operativos y worker2-g5 como líder. | Capturar el estado actual y señalar qué registro acredita la topología inicial. |
| C4 | Verificado con registro | Overlay red-app-g5 para la aplicación con MTU 1450. | Capturar listado e inspección. |
| D1 | Parcial | Dockerfile y dos imágenes del portal provisional, con versión e identidad del contenedor. | El código definitivo y sus dos contextos se probaron localmente. Compilar y verificar las imágenes en Docker, publicar con autorización y guardar evidencia de etiquetas en Docker Hub. |
| D2 | Verificado en prototipo | stack.yml define red, cuatro réplicas y políticas. El servicio real terminó 4/4. | Repetir con imágenes definitivas y capturar configuración y servicio. |
| D3 | Verificado en prototipo | Cuatro respuestas HTTP y cuatro capturas reales del navegador. Las IP públicas de manager y worker3 cambiaron tras las pruebas. | Repetir con la web definitiva y las IP actuales. Capturar navegador con dirección visible. |
| E1 | Verificado en prototipo | Doce peticiones dieron cuatro identidades distintas. | Capturar respuestas del sondeo y repetir con la web final. |
| E2 | Verificado en prototipo | Se observaron 8/8, 12/12 y 2/2, con vuelta a 4/4. | Capturar los tres repartos con docker service ps y repetir con la web final. |
| E3 | Verificado en prototipo | Se eliminó un contenedor y Swarm creó una tarea de reemplazo, con vuelta a 4/4. | Capturar identificador anterior, eliminación y reemplazo. |
| E4 | Verificado en prototipo | Solo worker3-g5 se detuvo. Su tarea se reubicó, con 164 respuestas HTTP correctas y 0 fallos en el tramo medido. Registro de EC2/Swarm y captura web. | Completar capturas de consola y terminal del antes, durante y después. |
| E5 | Parcial | worker3-g5 volvió Ready/Active. El servicio quedó 4/4. El despliegue escalonado volvió a asignar tareas al worker, con reparto 2–1–1 y un nodo sin tareas. | Reinicio de Learner Lab pendiente de autorización. Verificar después IP, SSH, nodos, reparto y HTTP. Capturar consola y terminal. |
| E6 | Verificado en prototipo | worker1-g5 pasó a Drain y volvió a Active. El registro muestra el estado del nodo y recuperación de 4/4. | Completar capturas de migración de tareas antes, durante y después. |
| E7 | Verificado en prototipo | Actualización 1.0 → 2.0 y rollback a 1.0. El sondeo de la secuencia de orquestación registró 156 respuestas y cero fallos observados. | Capturar cambio de versión, retorno y registro. Repetir con la web definitiva. |
| E8 | Elección verificada con límite de sondeo | worker2-g5 fue elegido Leader. manager-g5 volvió Reachable y los cuatro nodos quedaron Ready/Active con 4/4. Swarm informó Unknown/Unreachable y el script activó recuperación. Hubo 38 y 130 HTTP correctas, cero fallos observados y un intervalo sin muestras entre ambos tramos. | Capturas de terminal del cambio de líder. Si el docente exige sondeo ininterrumpido, repetir solo con autorización y ejecutar la sonda en un proceso independiente. |
| G1 | Pendiente | Existe una guía de comprobación, pero no consta exposición grupal realizada. | Preparar exposición de 10 minutos, arquitectura, código, reparto y demo. |
| G2 | Pendiente | No consta defensa individual ante el profesor. | Preparar las preguntas de cada integrante sobre todas las fases. |
| G3 | Pendiente | No consta demostración técnica individual evaluada. | Preparar y realizar las demostraciones individuales. |

## Capturas que faltan

1. **Fase 0.** En GitHub, abrir Settings → Collaborators, la pestaña Pull requests y el historial de la rama que se entregará. En Codespaces ejecutar `hostname; date -Is; aws --version; terraform version`.
2. **Fase 1.** En EC2, elegir us-east-1, filtrar las cuatro instancias por etiqueta y mostrar nombres, tipos y los controles de estado. Abrir el grupo de seguridad de G5 y mostrar Inbound rules. En el Codespace, desde el directorio de revisión, mostrar `terraform validate`, los resúmenes guardados de plan y apply, y `terraform output`. Consultar EC2 para las IP públicas actuales.
3. **Fases 2–3.** Mostrar terminal de Codespaces con alias, salto, órdenes simultáneas y copia. En los nodos mostrar `hostname; date -Is`, `cloud-init status`, Docker, zona, permisos y configuración efectiva de SSH. En el líder, mostrar `docker node ls` e inspeccionar `red-g5` y `red-app-g5`. Las salidas históricas están en los registros del repositorio.
4. **Fases 4–5.** Capturar Docker Hub una vez autorizada la publicación, y la web final con la dirección visible en cada nodo. Para E1–E8, mostrar los registros originales y marcar como tales las capturas tomadas después de la prueba. Para nuevas pruebas, capturar antes, durante y después con el sondeo activo y registrar cualquier discontinuidad. Incluir fecha, autor, prueba y resultado. Ocultar credenciales, tokens y claves privadas.

## Orden de cierre

1. Completar capturas y contrastarlas con los registros existentes. Identificar la cuenta del profesor y confirmar su acceso.
2. Incorporar las claves públicas de los colaboradores y la práctica individual real. Aclarar con el profesor la discrepancia sobre vockey. Completar GESTION.md con el reparto real.
3. Integrar la web F1 definitiva y construir sus dos versiones. Solicitar autorización para publicar en Docker Hub. Actualizar README y repetir las comprobaciones sobre el artefacto final.
4. Completar E5 con el reinicio autorizado de Learner Lab. A6 requiere documentar el cambio y la destrucción autorizados. Repetir E8 con sondeo independiente si se exige una serie sin huecos.
5. Revisar PR, archivos sensibles, informe y enlaces de entrega. Integrar en la rama de entrega acordada y preparar la exposición y pruebas individuales.


En E8, la última muestra antes de la interrupción fue a las 21:15:14 y la primera posterior a las 21:15:48, hora de Madrid. Las dos respuestas fueron correctas. Entre ambas muestras transcurrieron 34 segundos sin observaciones intermedias.

## Preparación operativa de lo pendiente

| Bloque | Preparación y criterio de cierre |
| --- | --- |
| E5 | Antes del reinicio autorizado, conservar IDs, IP privadas, tres managers, líder, 4/4 y HTTP. Tras el reinicio de Learner Lab, revalidar sesión, consultar IP públicas actuales, ajustar alias con la huella conocida y comprobar SSH, los cuatro nodos, la distribución de tareas y el portal. Fechar y comparar las capturas. |
| A6 | Conservar la salida de validación, plan y apply. Preparar en una rama un cambio acotado y revisar su plan para excluir sustituciones. Aplicarlo solo con autorización. Dejar la prueba de destrucción para el final, con alcance e impacto revisados y autorización separada. |
| Web F1 | Sustituir el contenido provisional de las dos versiones por el artefacto del grupo. Mantener la identidad y versión por réplica, construir ambas imágenes y verificar el contenido y la comprobación HTTP. |
| Docker Hub | Definir cuenta y repositorio, verificar acceso sin guardar credenciales, obtener autorización para publicar y guardar evidencia de ambas etiquetas y sus digests. Desplegar las imágenes aprobadas, verificar 4/4 y el acceso por las cuatro IP y repetir las pruebas que requiera el docente. |
| Entrega | Confirmar acceso del profesor y claves públicas individuales, añadir las prácticas y reparto reales, revisar la PR y evidencias con el grupo. Integrar en main después de la revisión. |

### Guion de exposición de diez minutos

1. **0–2 min.** Presentar el evento, el mapa del clúster y el reparto real del grupo.
2. **2–4 min.** Mostrar el módulo Terraform y el acceso seguro por salto SSH.
3. **4–6 min.** Mostrar red overlay, cuatro réplicas e identidad del contenedor servido.
4. **6–9 min.** Demostrar una prueba previamente autorizada. Para repasar E4 y E8 sin intervenir, usar el registro y las capturas históricas, incluido el hueco de E8.
5. **9–10 min.** Mostrar la evidencia y resumir lo pendiente. Preparar demostración individual y preguntas sobre cualquier fase.

## Preparación de E5 y A6

La comprobación previa a E5 se ejecutó el 4 de noviembre de 2026 a las
21:32 de Madrid. Los cuatro nodos pasaron los controles, SSH y las consultas de
Swarm. El servicio quedó en 4/4 y respondió por las cuatro IP públicas.

- [Respaldo e inventario](evidencias/E5-preparacion.txt). El estado original y
  la copia coinciden en linaje y serial. Ambos tienen permisos 600. La copia
  privada en Codespaces también contiene la configuración SSH, la huella de
  la clave, la identificación de la cuenta AWS, las configuraciones exportadas
  de Swarm y un archivo verificado de las dos imágenes provisionales.
- [Verificación previa](evidencias/E5-verificacion-previa.txt). Ejecutar desde
  el worktree operativo `bash scripts/verificar-e5.sh DIRECTORIO_PRIVADO`
  tras el reinicio autorizado. El script compara cuenta, estado, IDs, IP
  privadas, salud EC2, SSH, cuórum, redes, 4/4 y HTTP. Usa las IP públicas
  actuales con una configuración SSH temporal y conserva el estado original.
- El estado de Swarm se comprobó en el disco raíz de los cuatro nodos. La
  exportación es un inventario de configuración. No es una copia fría de
  Raft. Si el laboratorio devuelve otra cuenta, cambian los IDs o se pierden
  los discos, detener la prueba y revisar la recuperación antes de cualquier
  acción de escritura. Consultar la
  [guía de respaldo de Swarm](https://docs.docker.com/engine/swarm/admin_guide/#back-up-the-swarm).
- [Plan A6](evidencias/A6-plan-previo.txt). En una copia privada se generó un
  plan real con 0 altas, 1 cambio y 0 destrucciones. Solo propone añadir
  `PruebaA6=reto4-g5` a manager-g5. Si se autoriza, incorporar el cambio al
  worktree operativo, volver a planificar contra su estado y comprobar que el
  plan sigue limitado a la etiqueta antes de aplicar. La destrucción es una
  prueba posterior con autorización independiente.

## Integración de la web final

Recibir dos exportaciones estáticas que contengan index.html y los recursos
públicos de cada versión. Revisar el contenido antes de compilar. El constructor
rechaza enlaces simbólicos y nombres comunes de archivos sensibles.

```bash
bash app/construir.sh RUTA_EXPORTACION_1 CUENTA/REPOSITORIO 1.0
bash app/construir.sh RUTA_EXPORTACION_2 CUENTA/REPOSITORIO 2.0
```

Comprobar ambas imágenes, su contenido y /identidad.txt localmente. Tras
autorización de publicación, autenticarse sin guardar credenciales en el
repositorio, publicar exactamente las dos etiquetas aprobadas y registrar
sus digests. Desplegar 1.0, verificar cuatro réplicas y las cuatro IP y
repetir las pruebas pertinentes con el portal final.

## Revisión del ZIP de la web F1 definitiva

El archivo del grupo contiene cinco páginas HTML, CSS, JavaScript e imágenes,
sin servidor de aplicación, base de datos ni dependencias de compilación. El
sitio puede servirse en Nginx. La copia preparada está en `app/f1`. Se corrigió
la ruta del logo respetando mayúsculas de Linux, se retiró una credencial de
demostración del JavaScript y se deshabilitó el acceso que requería un servidor.
Los demás formularios funcionan como demostración local, sin enviar datos.
Se retiró también el hash vacío que figuraba junto al enlace FIA. La validez
del documento externo no se verificó como parte de la prueba local.

```bash
bash app/construir-f1.sh CUENTA/REPOSITORIO 1.0
bash app/construir-f1.sh CUENTA/REPOSITORIO 2.0
```

- **1.0** contiene el sitio del grupo e incluye un enlace a la identidad de la
  réplica. **2.0** muestra una versión distinta y añade una página que consulta
  el estado de la réplica. Nginx generará /identidad.txt al arrancar cada
  contenedor. El constructor compartido comprueba los archivos que se servirán.
- **D1:** se prepararon los dos contextos y se verificaron con Chromium las
  cinco páginas de ambas versiones. Cargaron el logo, mostraron su versión y
  no enviaron los formularios. La página de estado se probó con una respuesta
  simulada identificada como tal. No se construyeron ni publicaron imágenes.
- **D2 y D3:** stack.yml admite la imagen final, con cuatro réplicas, la red
  del grupo y política de reinicio. Se deben comprobar las cuatro réplicas y
  las cuatro IP con la web final tras autorizar su sustitución. Los resultados
  anteriores corresponden al portal provisional.
- [Captura local del sitio candidato](evidencias/F1-candidata-local.png).
  Autor Codex, 4 de noviembre de 2026. Es una prueba de navegador local
  posterior a las pruebas del portal provisional y no acredita un despliegue.

### E5 y comparación de discos

Se confirmó que el plan operativo no propone acciones sobre recursos AWS.
Terraform señala una actualización de la salida nodes a partir de las IP
reales. El estado se conservó sin aplicar ese cambio. Se guardó la referencia
privada de IDs y volúmenes raíz. verificar-e5.sh ahora compara cada disco
adjunto con esa referencia antes de comprobar SSH y Swarm. El reinicio
autorizado requiere End Lab y Start Lab desde la sesión de AWS Academy.
E5 seguirá pendiente hasta que consten el reinicio y las comprobaciones posteriores.
