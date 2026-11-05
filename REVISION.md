# Revisión de entrega RETO 4 CLOUD

Cotejo del 4 de noviembre de 2026 con la Guía CLOUD y la Rúbrica CLOUD del profesor. La verificación funcional se distingue de la evidencia exigida para la corrección. «Verificado en prototipo» se refiere al portal provisional. La web definitiva se desplegó el 5 de noviembre, y los criterios repetidos con ella lo indican. Un registro de comandos conserva una salida real y se identifica como tal. Las imágenes son capturas reales del navegador.

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
| F3 | Verificado | README con resumen, instrucciones de despliegue final y enlace a las dos etiquetas de Docker Hub. | Revisar antes de la entrega. |
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
| A6 | Parcial | Validación, plan y apply iniciales reales. Cambio real aplicado el 5 de noviembre: 0 altas, 1 cambio, 0 destrucciones, solo la etiqueta `PruebaA6` de manager-g5. El plan posterior no propone cambios. [Plan](evidencias/A6-plan-final.txt) y [apply](evidencias/A6-apply.txt). | Destrucción real solo con autorización separada. Capturar la consola de EC2 con la etiqueta. |
| B1 | Parcial | La clave propia del Codespace funcionó en cuatro nodos. La política de vockey difiere entre guía y rúbrica. | Recoger claves públicas individuales y verificar accesos. Aclarar con el profesor si vockey se conserva como reserva o se sustituye. |
| B2 | Verificado con registro | Plantilla en /config y configuración local generada con alias. | Capturar alias y conexión ocultando material sensible. |
| B3 | Verificado con registro | Comandos en paralelo por SSH, sudo comprobado y copia SCP con SHA-256 coincidente. | Capturar el registro de comandos y copia. |
| B4 | Verificado con registro | sshd confirma root y contraseña deshabilitados. Permisos 700 y 600 comprobados. | Capturar salida de sshd y permisos, incluyendo el archivo de clave local cuando proceda. |
| B5 | Verificado con registro | Los tres workers respondieron por IP privada con ProxyJump. Tras E8 volvió a funcionar el salto. | Capturar conexión y configuración efectiva. |
| C1 | Verificado con registro | Docker 29.1.3 y ping entre IP privadas. | Capturar Docker y ping por rol. |
| C2 | Verificado con registro | Swarm por IP privada. Red ingress red-g5 con MTU 1450. | Capturar inspección de red y direcciones privadas. |
| C3 | Verificado con registro | Configuración inicial de un manager líder y tres workers Ready/Active. E8 dejó tres managers operativos y worker2-g5 como líder. | Capturar el estado actual y señalar qué registro acredita la topología inicial. |
| C4 | Verificado con registro | Overlay red-app-g5 para la aplicación con MTU 1450. | Capturar listado e inspección. |
| D1 | Verificado con registro | Dos imágenes definitivas construidas desde app/f1 y probadas en contenedores temporales. Publicadas en `innnx/reto4-f1` con etiquetas 1.0 y 2.0 y descargadas sin sesión en los tres workers, con digest y contenido idénticos. [Publicación](evidencias/D1-publicacion-dockerhub.txt), [descarga](evidencias/D1-descarga-dockerhub.txt) y [captura de etiquetas](evidencias/D1-dockerhub-etiquetas.png). | Mostrar Docker Hub en la defensa. |
| D2 | Verificado con registro | Con la web definitiva: stack.yml define red, cuatro réplicas y políticas de actualización y rollback. `reto4_web` terminó en 4/4 con `innnx/reto4-f1:1.0`. [Registro](evidencias/F3-despliegue/registro.txt) y [estado final](evidencias/F3-estado-final.txt). | Capturar configuración y servicio en terminal. |
| D3 | Verificado con registro | Con la web definitiva: HTTP 200 y Chromium sin errores por las cuatro IP. Capturas de un navegador gráfico real con la dirección visible en [manager-g5](evidencias/D3-navegador-manager-g5.png), [worker1-g5](evidencias/D3-navegador-worker1-g5.png), [worker2-g5](evidencias/D3-navegador-worker2-g5.png) y [worker3-g5](evidencias/D3-navegador-worker3-g5.png). [Método y horas](evidencias/D3-registro.txt). | Confirmar con el profesor que este método le sirve. La Rúbrica original no estaba disponible para cotejarlo. |
| E1 | Verificado con registro | Con la web definitiva: 12 peticiones por las cuatro IP respondidas por cuatro contenedores distintos. [Estado final](evidencias/F3-estado-final.txt). | Capturar las respuestas del sondeo. |
| E2 | Verificado con observación | Con la web definitiva: 8/8 (2-2-2-2), 12/12 (3-3-3-3), 2/2 (1-1) y 4/4 (1-1-1-1), con HTTP 200 en las cuatro IP tras cada estado. Las sondas registraron 562 respuestas correctas y 2 fallos, en una sola muestra de dos IP durante el paso de 12 a 2. [Registro y capturas de terminal](evidencias/F4-E2/). | Decidir cómo se valoran esos fallos. |
| E3 | Verificado en prototipo | Se eliminó un contenedor del portal provisional y Swarm creó una tarea de reemplazo, con vuelta a 4/4. | Repetir con la web definitiva. Autorizado, detenido tras los fallos de sonda de E2 y pendiente de decisión. |
| E4 | Verificado en prototipo | Solo worker3-g5 se detuvo. Su tarea se reubicó, con 164 respuestas HTTP correctas y 0 fallos en el tramo medido. Registro de EC2/Swarm y captura web. | Completar capturas de consola y terminal del antes, durante y después. |
| E5 | Verificado con registro | Learner Lab reiniciado, según confirmó el usuario; las IP públicas difieren de las anteriores. El 5 de noviembre coinciden IDs y volúmenes raíz con la referencia previa. SSH, Swarm con tres managers, 4/4 y HTTP correctos. [Registro](evidencias/E5-verificacion-final.txt). | Capturar consola y terminal. No repetir el reinicio. |
| E6 | Verificado en prototipo | worker1-g5 pasó a Drain y volvió a Active con el portal provisional. El registro muestra el estado del nodo y recuperación de 4/4. | Repetir con worker3-g5 y la web definitiva. Autorizado, detenido tras los fallos de sonda de E2 y pendiente de decisión. |
| E7 | Verificado con registro | Con la web definitiva: actualización 1.0 → 2.0 y rollback a 1.0, ambos 4/4, con 620 peticiones de sonda y 0 fallos. [Registro](evidencias/F3-actualizacion/registro.txt). | Capturar cambio de versión y retorno en terminal. |
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

### E5 tras End Lab y Start Lab

El usuario confirmó el reinicio y el indicador verde de AWS Academy.
A las 21:51 de Madrid, el comprobador se detuvo en DescribeInstanceStatus
por una denegación explícita de la política voc-cancel-cred. La sesión
anterior de Codespaces requiere credenciales temporales nuevas. El error
no permite confirmar ni descartar cambios en los recursos. E5 sigue
pendiente de la comparación de EC2, discos, SSH, cuórum y HTTP.
[Registro posterior saneado](evidencias/E5-verificacion-posterior.txt).

## Cierre técnico del 5 de noviembre de 2026

La Guía CLOUD y la Rúbrica CLOUD originales no están en el Codespace ni en el
repositorio. Esta revisión parte de la matriz anterior y no vuelve a cotejar
los documentos originales.

### Web e imágenes

`scripts/comprobar-web.py` detectó enlaces a `index.html#escuderias` sin destino.
Se añadió el destino, el menú de la portada apunta a sus tres secciones y los
enlaces de `.bloque-principal` se leen sobre el fondo oscuro. Los enlaces con `#`
de Bilbao y de los avisos legales siguen sin destino porque el grupo no tiene ese
contenido.

Docker no puede ejecutarse en el Codespace, que no tiene `SYS_ADMIN` ni *user
namespaces*. `scripts/preparar-imagenes.sh` construye en manager-g5 como
`reto4-g5/f1-definitiva:1.0` y `:2.0`, sin afectar a la imagen provisional ni al
servicio. Las [capturas 1.0](evidencias/D1-navegador-1.0.png) y
[2.0](evidencias/D1-navegador-2.0.png) proceden de contenedores temporales
y no acreditan D2, D3 ni E1–E8 con la web final.

### Secuencia por fases

Cada fase se detiene si falla una comprobación. La siguiente no empieza sin el
visto bueno del responsable. Las fases 1, 2 y 3 ya están completadas. En la fase 4 se ejecutó E2, y E3 y E6 están detenidas a la espera de una decisión.

```bash
ssh -t -F config/ssh.local manager-g5 docker login -u CUENTA
# Fase 1. Publicar 1.0 y 2.0. El script cierra la sesión al terminar.
bash scripts/publicar-imagenes.sh config/ssh.local CUENTA/REPOSITORIO
# Fase 2. Descargar sin sesión en los workers y comparar con lo construido.
bash scripts/comprobar-descarga.sh config/ssh.local CUENTA/REPOSITORIO
# Fase 3. Desplegar 1.0, actualizar a 2.0 y hacer rollback. Termina en 1.0.
bash scripts/desplegar-f1.sh config/ssh.local CUENTA/REPOSITORIO DIRECTORIO_REGISTROS
bash scripts/probar-actualizacion.sh config/ssh.local CUENTA/REPOSITORIO DIRECTORIO_REGISTROS
# Fase 4. E2, E3 y E6, uno a uno. No crea ni elimina recursos AWS.
bash scripts/probar-orquestacion.sh config/ssh.local CUENTA/REPOSITORIO DIRECTORIO_REGISTROS e2
bash scripts/probar-orquestacion.sh config/ssh.local CUENTA/REPOSITORIO DIRECTORIO_REGISTROS e3
bash scripts/probar-orquestacion.sh config/ssh.local CUENTA/REPOSITORIO DIRECTORIO_REGISTROS e6
```

La imagen provisional se conserva en los nodos.

### Publicación en Docker Hub

Repositorio público [`innnx/reto4-f1`](https://hub.docker.com/r/innnx/reto4-f1/tags).

| Etiqueta | Digest | Huella del contenido servido |
| --- | --- | --- |
| 1.0 | `sha256:622d83436cb97412b761ca8cd8d6b8e6c4940f4682a7f6fb6940921d599362ca` | `a83fb4d41950fac0…` |
| 2.0 | `sha256:1736eda0abd63aa0ac538b1a9c11bfdb4f64dc1d36c7687cd7be9a52d2cc76f7` | `4e8580f3094f3803…` |

- El [primer intento](evidencias/D1-publicacion-intento-fallido.txt), a las 09:02 UTC del
  5 de noviembre de 2026, se detuvo porque Docker Hub rechazó el token con `access
  token has insufficient scopes`. No publicó etiquetas.
- La [publicación correcta](evidencias/D1-publicacion-dockerhub.txt) se hizo a las
  09:12 UTC, tras iniciar sesión de nuevo. El script cerró la sesión al terminar.
- La [comprobación de descarga](evidencias/D1-descarga-dockerhub.txt) confirmó el acceso
  anónimo al registro y las dos etiquetas en worker1-g5, worker2-g5 y worker3-g5, sin
  sesión de Docker Hub, con el digest y la huella de lo construido en manager-g5.
- [Captura de la página pública de etiquetas](evidencias/D1-dockerhub-etiquetas.png),
  tomada con Chromium a las 09:15 UTC.
- Los cuatro nodos conservan las imágenes provisionales y las publicadas.

### Despliegue y actualización de la web definitiva

Realizados el 5 de noviembre de 2026 sin recrear EC2 ni reinicializar Swarm. El servicio
terminó en **versión 1.0 de la web definitiva, 4/4**.

| Paso | Fin (UTC) | Resultado | Sondas (4 IP, 1 petición/s) | Registro |
| --- | --- | --- | --- | --- |
| Portal provisional → `innnx/reto4-f1:1.0` | 09:20:42 | 4/4, HTTP 200 y Chromium sin errores en las cuatro IP | 328 OK, 0 fallos, hueco máximo 2 s | [Despliegue](evidencias/F3-despliegue/registro.txt) |
| 1.0 → 2.0 | 09:22:22 | 4/4, HTTP 200 y Chromium sin errores en las cuatro IP | 620 OK, 0 fallos, hueco máximo 1 s, con el rollback | [Actualización](evidencias/F3-actualizacion/registro.txt) |
| Rollback 2.0 → 1.0 | 09:23:39 | 4/4, HTTP 200 y Chromium sin errores en las cuatro IP | Incluidas en la fila anterior | [Actualización](evidencias/F3-actualizacion/registro.txt) |

- La hora es la registrada al terminar el paso. Las sondas se guardan por IP junto a cada
  registro y cubren también las pruebas posteriores en Chromium.
- Las imágenes anteriores se conservan en los cuatro nodos. El rollback automático de
  Swarm no llegó a activarse.
- **Reparto final desigual:** manager-g5 1, worker1-g5 1, worker2-g5 2 y worker3-g5 0.
  Swarm no reequilibra por sí solo tras una actualización con `start-first`. worker3-g5
  responde por la malla de enrutamiento, como muestran su HTTP 200 y [el estado
  final](evidencias/F3-estado-final.txt). La fase 4 reequilibra al final de E6.
- Las capturas de este apartado salen de Chromium sin interfaz y no muestran la dirección.
  La IP está en el nombre del archivo y la hora en el registro. Son idénticas entre IP
  porque el contenido servido es el mismo. Las que muestran la dirección son las de D3.
- E4 y E8 solo se probaron con el portal provisional.

### Capturas D3 con la dirección visible

Tomadas a las 09:37–09:38 UTC del 5 de noviembre de 2026 con Chromium gráfico en un
escritorio virtual Xvfb del Codespace, capturando la pantalla entera con
`scripts/capturar-pantalla.sh`. La barra de direcciones es la del propio navegador y la
imagen no se retoca. Un terminal real, en la parte inferior, muestra máquina, hora, HTTP
200 e identidad de la réplica.

- Chromium omite `http://` en la barra y muestra la IP y «No es seguro», porque la web se
  sirve por HTTP. El terminal muestra la URL completa.
- La barra informativa de Chrome for Testing es del navegador y se dejó visible.
- Al lanzarlo se desactivaron el aviso previo de HTTPS, la traducción y el aviso de sandbox.
  El Codespace no admite sandbox de navegador. [Registro](evidencias/D3-registro.txt).

### Fase 4: E2 con la web definitiva

Se escaló a 8, 12, 2 y 4 réplicas, comprobando réplicas, reparto y HTTP en las cuatro IP
tras cada estado. Todos los estados se alcanzaron. El [registro](evidencias/F4-E2/registro.txt)
termina en `exit=1` porque el script trata cualquier fallo de sonda como error:

- A las 09:35:38 UTC, durante el paso de 12 a 2, una muestra de 34.230.4.20 y otra de
  98.81.203.125 agotaron el límite de 0,9 s. Las muestras anterior y siguiente fueron
  correctas. Son 2 de 564 peticiones.
- Esas IP son las de worker1-g5 y worker3-g5, los nodos que se quedaron sin tareas en ese
  paso. manager-g5 y worker2-g5, que conservaron la suya, no registraron fallos. No se ha
  determinado la causa: lo observado es compatible con una actualización transitoria del
  balanceo al retirar tareas, pero no lo demuestra.
- Al terminar, 4/4 con reparto 1-1-1-1, cuatro nodos Ready/Active y versión 1.0.

Se detuvieron E3 y E6 en aplicación de la condición de parar ante un fallo.

### A6

El estado está en `/workspaces/reto4-revision.Geeumo/terraform`. La regla SSH activa
no tiene descripción y `main.tf` la declaraba, lo que hacía que el plan reescribiera
la regla. Se retiró del código la descripción de esa regla, de modo que el plan no
toca el grupo de seguridad y no requiere ningún cambio previo en AWS.

Hay que usar la IP actual del Codespace en `ssh_cidr`. Tanto `terraform.tfvars` como
el `reto4-local.auto.tfvars.json` operativo tienen valores antiguos, y aplicarlos
retiraría el acceso SSH actual.

El 5 de noviembre de 2026, a las 09:05 UTC, se regeneró el plan y un control
automático confirmó 0 altas, 1 cambio y 0 destrucciones, limitado a añadir
`PruebaA6=reto4-g5` a manager-g5. Se aplicó ese plan guardado. También actualizó en
el estado la salida `nodes`, ya prevista en el plan, que ahora muestra las IP
actuales. [Registro completo](evidencias/A6-apply.txt).

Comprobaciones posteriores: etiqueta solo en manager-g5, mismos IDs y volúmenes
raíz, regla SSH sin cambios, `terraform plan` sin cambios y `reto4_web` en 4/4 con la
imagen anterior. La destrucción sigue sin autorizar ni ejecutar.

- El código vigente es el de esta rama. `main.tf` del worktree operativo es anterior:
  planificar desde allí propondría retirar la etiqueta. Hay que ejecutar Terraform
  desde esta rama con `-state` apuntando al estado operativo.
- `scripts/verificar-e5.sh` compara el serial con el respaldo previo a E5. Tras este
  cambio el serial es otro y esa primera comprobación fallará. E5 ya está registrado
  y el estado anterior se conserva en el directorio privado de respaldo.
