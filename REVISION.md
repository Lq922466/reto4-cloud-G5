# Revisión de entrega RETO 4 CLOUD

Estado de los 42 criterios a 5 de noviembre de 2026, **con los requisitos exactos de la Rúbrica**. Los documentos originales se conservan fuera del repositorio. El análisis, las diferencias entre la Guía y la Rúbrica y el plan están en el [contraste](entrega/CONTRASTE-GUIA-RUBRICA.md).

**Regla de la Rúbrica:** cada requisito puntúa solo si funciona durante la corrección y está respaldado por la captura correspondiente (según instrucciones) y los archivos correspondientes en el repositorio.

**Normas de la Guía para las capturas:** debe verse claramente el prompt con el hostname y la fecha/hora; cada captura debe incluir un comentario indicando qué prueba es, el resultado y el autor; y está estrictamente prohibido mostrar credenciales de AWS o claves privadas.

- **Listo:** cumple lo exigido con los archivos del repositorio.
- **Demostrado, falta captura conforme:** hay una comprobación real registrada, pero falta su captura según la norma o la de la consola.
- **Parcial:** una parte del requisito está sin cumplir.
- **Pendiente:** no hay trabajo real que presentar.

Ningún estado es una calificación.

## Resumen

| Situación | Nº | Criterios |
| --- | --- | --- |
| Listo | 10 | A1, D1, D2, F3–F8, F12 |
| Demostrado, falta captura conforme | 17 | A2–A5, B3–B5, C1, C2, C4, D3, E1–E3, E5–E7 |
| Parcial | 11 | A6, B1, B2, C3, E4, E8, F1, F2, F9, F10, F11 |
| Pendiente | 4 | F13, G1, G2, G3 |

**Último estado técnico comprobado: 09:56 UTC.** A las 12:15 UTC, AWS seguía denegando las lecturas. [Informe de la auditoría](evidencias/auditoria/INFORME.md).

**Documentos de entrega:** [informe técnico](PROYECTO.md), [contraste](entrega/CONTRASTE-GUIA-RUBRICA.md), [checklist final](entrega/CHECKLIST-FINAL.md), [procedimiento de capturas](entrega/PROCEDIMIENTO-CAPTURAS.md), [plan de C3, E4 y E8](entrega/PLAN-C3-E4-E8.md), [defensa](entrega/DEFENSA.md), [índice de evidencias](evidencias/INDICE.md), [gestión](GESTION.md) y [tareas pendientes](entrega/PENDIENTES.md).

## Evidencias disponibles

Índice completo: [evidencias/INDICE.md](evidencias/INDICE.md).

- [Registro técnico recuperado de Codespaces](evidencias/revision-registro-tecnico.txt) — entorno, validación, plan, apply, arranque y orquestación.
- [E4 y reincorporación](evidencias/E4-E5-E8-registro.txt) y [elección y recuperación E8](evidencias/E8-eleccion-registro.txt).
- [Captura durante E4](evidencias/E4-web-worker-down.png), [captura tras reincorporar el worker](evidencias/E5-web-recuperado.png), [captura durante E8](evidencias/E8-web-parada.png) y [captura tras recuperar el manager](evidencias/E8-web-recuperado.png).
- Las cuatro capturas F4C están enlazadas en [PROYECTO.md](PROYECTO.md).
- [Registros originales de las pruebas del 4 de noviembre](evidencias/prototipo/), antes sin versionar.
- [Índice de capturas de terminal](evidencias/capturas-terminal/INDICE.md), capturas [D3](evidencias/D3-registro.txt) y pruebas [E2](evidencias/F4-E2/), [E3](evidencias/F4-E3/) y [E6](evidencias/F4-E6/) con la web definitiva.

## Matriz por criterio

«Qué pide» y «Evidencia exigida» son el texto de la Rúbrica. Ítem completo: puntuación entera. Ítem parcial: mitad. No conseguido: 0.

### A · Infraestructura con Terraform — 2 p

| Cód. | Qué pide | Evidencia exigida | Estado | Comprobación o evidencia | Pendiente |
| --- | --- | --- | --- | --- | --- |
| A1 | Proyecto organizado, con variables | Ficheros en /terraform | Listo | Módulo /terraform con variables de grupo, tipos, discos e imagen. [Captura conforme](evidencias/capturas-conformes/A1-modulo.png). | Comprobar con un plan que las variables de disco no proponen cambios, cuando el laboratorio esté activo. |
| A2 | Manager + 3 workers definidos una vez; etiquetas | Código; consola EC2 | Demostrado, falta captura conforme | Un manager t3.medium y tres workers t3.small a partir de un único recurso multiplicado, con etiquetas. Cuatro instancias desplegadas. | Captura de la consola de EC2 con la norma de capturas. |
| A3 | Security group con política de mínimos | Código; reglas EC2 | Demostrado, falta captura conforme | Reglas reales del grupo: SSH externo /32, TCP 80/8080 público, TCP 22 entre nodos para el salto, y 2377/7946/4789 e ICMP limitados al propio grupo. [A3-grupo-seguridad](evidencias/capturas-terminal/A3-grupo-seguridad.png). | Captura de reglas en la consola. El puerto 8080 lo exige la Guía. |
| A4 | Script de arranque (hostname, zona, Docker, claves) | Script /terraform; log | Demostrado, falta captura conforme | Plantilla de inicio con hostname, zona, claves, SSH y Docker: [captura conforme](evidencias/capturas-conformes/A4-script.png). Cloud-init completado en cuatro nodos: [registro](evidencias/capturas-terminal/A4-arranque.txt). | Captura conforme del log de arranque en los nodos. Ya está la del script. |
| A5 | Salidas con IP pública, privada e ID | Salida de Terraform | Demostrado, falta captura conforme | nodes devuelve IP pública, privada e ID. El registro E8 identifica la nueva IP del manager tras el arranque. | Rehacer la captura con prompt y comentario. |
| A6 | Pruebas clave: validación, plan, cambio, destrucción | Secuencia capturas | Parcial | Validación, plan y apply iniciales reales. Cambio real aplicado el 5 de noviembre: 0 altas, 1 cambio, 0 destrucciones, solo la etiqueta `PruebaA6` de manager-g5. El plan posterior no propone cambios. [Plan](evidencias/A6-plan-final.txt) y [apply](evidencias/A6-apply.txt). | Destrucción real, con autorización aparte y tras aclararlo con el profesor. Secuencia completa en capturas. |

### B · Acceso remoto por SSH — 1 p

| Cód. | Qué pide | Evidencia exigida | Estado | Comprobación o evidencia | Pendiente |
| --- | --- | --- | --- | --- | --- |
| B1 | Clave propia en 4 nodos; vockey sustituida | Repositorio; authorized_keys | Parcial | La clave propia del Codespace funcionó en cuatro nodos. El 9 de noviembre se instalaron las tres claves de los integrantes: [captura conforme](evidencias/capturas-conformes/B1-clave-nodos.png) y [registro](evidencias/auditoria/registro-2026-11-09-b1.txt). Cristina entró con su clave en los cuatro nodos, y Enrique, Alexandra e Ibai en manager-g5: [capturas](evidencias/capturas-integrantes/INDICE.md), [registro de manager-g5](evidencias/capturas-conformes/B1-registro-manager.png) y [registro de los cuatro nodos para Cristina](evidencias/capturas-conformes/B1-registro-cristina.png). Enrique, Alexandra e Ibai no han entrado en los workers. La política de vockey difiere entre guía y rúbrica. | Las claves de Enrique, Alexandra e Ibai, y después la de Cristina, se instalaron el 9 de noviembre en los cuatro nodos (captura conforme `B1-clave-nodos`, con las cuatro). Ese día, Cristina entró con su clave en los cuatro nodos, por salto en los workers (`B1-registro-cristina`), y Enrique, Alexandra e Ibai entraron en manager-g5 (`B1-registro-manager`, con los cuatro). Lo muestran sus capturas y lo confirma el registro de cada nodo. Falta que Enrique, Alexandra e Ibai entren en los tres workers, capturas con el comentario de la norma, subir las claves a GitHub y retirar la regla temporal `88.14.93.201/32`. Aclarar `vockey`: la Guía la deja de reserva y la Rúbrica la sustituye. |
| B2 | Archivo config SSH con nombre corto | /config; conexión | Parcial | Plantilla y configuraciones en [/config](config/README.md), `~/.ssh/config` y alias resueltos: [captura conforme](evidencias/capturas-conformes/B2-plantilla.png). | Comprobar la conexión real con el nombre corto cuando el laboratorio esté activo, y capturarla. |
| B3 | Control total, órdenes simultáneas y copia ficheros | Capturas cliente | Demostrado, falta captura conforme | Comandos en paralelo por SSH, sudo comprobado y copia SCP con SHA-256 coincidente. | Rehacer las capturas con prompt y comentario. |
| B4 | Sin contraseña ni root; permisos locales | Config SSH; permisos | Demostrado, falta captura conforme | sshd confirma root y contraseña deshabilitados. Permisos 700 y 600 comprobados. | Rehacer la captura con prompt y comentario. |
| B5 | Acceso a workers por IP privada (salto) | Conexión con salto | Demostrado, falta captura conforme | Los tres workers respondieron por IP privada con ProxyJump. Tras E8 volvió a funcionar el salto. | Rehacer la captura con prompt y comentario. |

### C · Clúster Docker Swarm — 1 p

| Cód. | Qué pide | Evidencia exigida | Estado | Comprobación o evidencia | Pendiente |
| --- | --- | --- | --- | --- | --- |
| C1 | Docker en 4 nodos; conectividad por IP privada | Ping entre nodos | Demostrado, falta captura conforme | Docker 29.1.3 y ping entre IP privadas. | Rehacer la captura con prompt y comentario. |
| C2 | Clúster por IP privada; MTU ajustado (1450) | Info clúster y redes | Demostrado, falta captura conforme | Swarm por IP privada. Red ingress red-g5 con MTU 1450. | Rehacer la captura con prompt y comentario. |
| C3 | 4 nodos activos, manager líder, 3 workers unidos | Listado de nodos | Parcial | Configuración inicial de un manager líder y tres workers Ready/Active. E8 dejó tres managers operativos y worker2-g5 como líder. | El 9 de noviembre, a las 09:26 UTC, hay tres managers y el líder es worker2-g5. Ver el [plan](entrega/PLAN-C3-E4-E8.md), que requiere autorización. |
| C4 | Red overlay propia para servicios | Listado de redes | Demostrado, falta captura conforme | Overlay red-app-g5 para la aplicación con MTU 1450. | Rehacer la captura con prompt y comentario. |

### D · Despliegue de la web — 0,5 p

| Cód. | Qué pide | Evidencia exigida | Estado | Comprobación o evidencia | Pendiente |
| --- | --- | --- | --- | --- | --- |
| D1 | Imagen propia (identifica contenedor); ver 1.0 y 2.0 | /app; Docker Hub | Listo | Imagen propia que identifica el contenedor, con etiquetas 1.0 y 2.0: [captura conforme](evidencias/capturas-conformes/D1-dockerhub.png) y [registros](evidencias/INDICE.md). | Nada. Mostrar Docker Hub en la defensa. |
| D2 | Servicio 4 réplicas, red grupo, políticas reinicio | Fichero despliegue | Listo | Con la web definitiva: stack.yml define red, cuatro réplicas y políticas de actualización y rollback. `reto4_web` terminó en 4/4 con `innnx/reto4-f1:1.0`. [Registro](evidencias/F3-despliegue/registro.txt) y [estado final](evidencias/F3-estado-final.txt). | Nada. |
| D3 | Accesible por IP pública de los 4 nodos | Navegador | Demostrado, falta captura conforme | Con la web definitiva: HTTP 200 y Chromium sin errores por las cuatro IP. Capturas de un navegador gráfico real con la dirección visible en [manager-g5](evidencias/D3-navegador-manager-g5.png), [worker1-g5](evidencias/D3-navegador-worker1-g5.png), [worker2-g5](evidencias/D3-navegador-worker2-g5.png) y [worker3-g5](evidencias/D3-navegador-worker3-g5.png). [Método y horas](evidencias/D3-registro.txt). | Comentario en cada captura, y rehacerlas con las IP del día. |

### E · Pruebas de orquestación — 1,5 p

| Cód. | Qué pide | Evidencia exigida | Estado | Comprobación o evidencia | Pendiente |
| --- | --- | --- | --- | --- | --- |
| E1 | Balanceo de carga | Respuestas distintas | Demostrado, falta captura conforme | Con la web definitiva: 12 peticiones por las cuatro IP respondidas por cuatro contenedores distintos. [Estado final](evidencias/F3-estado-final.txt). | Rehacer la captura con prompt y comentario. |
| E2 | Escalado (8, 12, 2) | Reparto de réplicas | Demostrado, falta captura conforme | Con la web definitiva: 8/8 (2-2-2-2), 12/12 (3-3-3-3), 2/2 (1-1) y 4/4 (1-1-1-1), con HTTP 200 en las cuatro IP tras cada estado. Las sondas registraron 562 respuestas correctas y dos tiempos de espera aislados durante la reducción de 12 a 2 réplicas. [Registro y capturas](evidencias/F4-E2/). | Capturas conformes antes, durante y después, con la sonda visible. Requiere autorización. Conservar la observación de los dos tiempos de espera. |
| E3 | Autorreparación (eliminar contenedor) | Servicio antes/después | Demostrado, falta captura conforme | Con la web definitiva: se eliminó un contenedor de la tarea `reto4_web.1`. Swarm registró el fallo y creó una tarea de reemplazo en el mismo nodo, con vuelta a 4/4 y HTTP 200 en las cuatro IP. Las sondas registraron 308 respuestas correctas y 0 fallos. [Registro y capturas](evidencias/F4-E3/). | Capturas conformes, con la sonda visible. Requiere autorización. |
| E4 | Alta disponibilidad (caída worker) | Nodo caído; script OK | Parcial | Con el portal provisional: solo worker3-g5 se detuvo, Swarm lo marcó `Down`, reubicó su tarea y volvió a 4/4. 164 respuestas de sonda correctas y 0 fallos. [Análisis](evidencias/auditoria/E4-E8.md). | Repetir con la web definitiva y capturas conformes: ver el [plan](entrega/PLAN-C3-E4-E8.md). También es la demostración obligatoria de la exposición. |
| E5 | Reincorporación y reequilibrio; reinicio lab | Nodos y servicio | Demostrado, falta captura conforme | Learner Lab reiniciado, según confirmó Cristina; las IP públicas difieren de las anteriores. El 5 de noviembre coinciden IDs y volúmenes raíz con la referencia previa. SSH, Swarm con tres managers, 4/4 y HTTP correctos. [Registro](evidencias/E5-verificacion-final.txt). | Captura conforme de nodos y servicio tras el próximo inicio del laboratorio, y vista de EC2. |
| E6 | Mantenimiento (modo drain) | Nodos y servicio | Demostrado, falta captura conforme | Con la web definitiva: worker3-g5 pasó a Drain, su tarea migró a worker2-g5 y el servicio siguió en 4/4. Volvió a Active y la actualización `--force` dejó una réplica por nodo. HTTP 200 en las cuatro IP tras cada paso. Las sondas registraron 488 respuestas correctas y 0 fallos. [Registro y capturas](evidencias/F4-E6/). | Capturas conformes, con la sonda visible. Requiere autorización. |
| E7 | Actualización (1.0 a 2.0) sin corte y rollback | Script y navegador | Demostrado, falta captura conforme | Con la web definitiva: actualización 1.0 → 2.0 y rollback a 1.0, ambos 4/4, con 620 peticiones de sonda y 0 fallos. [Registro](evidencias/F3-actualizacion/registro.txt). | Capturas conformes durante la actualización y el rollback, con la sonda y el navegador. Requiere autorización. |
| E8 | Alta disp. managers (nuevo líder) | Listado desde otro | Parcial | Con el portal provisional: de tres managers, se detuvo solo el líder. Comparando antes y después, worker2-g5 pasó a líder y manager-g5 volvió como Reachable, con 4/4. Sondas: 38 y 130 correctas, con 34 s sin muestras. [Análisis](evidencias/auditoria/E4-E8.md). | Repetir con la web definitiva y capturas desde otro manager durante la parada: ver el [plan](entrega/PLAN-C3-E4-E8.md). |

### F · Repositorio GitHub y Entorno (Fase 0) — 2 p

| Cód. | Qué pide | Evidencia exigida | Estado | Comprobación o evidencia | Pendiente |
| --- | --- | --- | --- | --- | --- |
| F1 | Privado, todos colaboradores, profesor invitado | Settings | Parcial | GitHub confirma repositorio privado, un administrador y tres cuentas con escritura: [captura conforme](evidencias/capturas-conformes/F1-repositorio.png). La consulta de invitaciones no está disponible con el token actual. | Invitar al profesor antes de la fecha límite. Captura de Settings → Collaborators. Ya está la de terminal. Los integrantes ya constan en la organización del equipo: Cristina, Enrique, Alexandra e Ibai. |
| F2 | Commits repartidos y uso de Pull Requests por colaboradores | Historial y PRs | Parcial | Constan commits de Cristina, con su identidad Innnx, y de Codex, y la PR #1 de Cristina, en borrador: [captura conforme](evidencias/capturas-conformes/F2-historial.png), del 5 de noviembre. El 6 de noviembre se fusionó la PR #2 de Enrique, con un commit suyo. | Commits y PR reales de Alexandra e Ibai, y más aportaciones de Enrique. Vista web de la PR. Ya está la captura del historial. |
| F3 | README.md (resumen, instrucciones rápidas, enlaces) | README.md | Listo | [README](README.md) con resumen, estructura, despliegue y enlace a las dos etiquetas de Docker Hub. | Nada. |
| F4 | Estructura (/terraform, /app, /config, y .devcontainer) | Árbol repo | Listo | Existen las carpetas pedidas en la rama de implementación: [captura conforme](evidencias/capturas-conformes/F4-estructura.png). | Integrar la PR: `main` solo contiene `.devcontainer`, `.gitignore`, `README.md` y `terraform`. |
| F5 | Entorno colaborativo: .devcontainer (AWS CLI, Terraform) y capturas Codespace | .devcontainer.json, proyecto.md | Listo | `devcontainer.json` con AWS CLI y Terraform, funcionando en el Codespace: [captura conforme](evidencias/capturas-conformes/F5-entorno.png), integrada en `PROYECTO.md`. | Nada imprescindible. Una vista del Codespace en el navegador sería un apoyo. |
| F6 | Código Terraform funcional | /terraform | Listo | Código validado, y desplegó cinco recursos reales: [captura conforme](evidencias/capturas-conformes/F6-codigo.png). | Nada. Comprobar con un plan cuando el laboratorio esté activo. |
| F7 | Scripts comentados | /scripts | Listo | Scripts comentados: qué hacen, cuándo se usan y su efecto. Incluye la actualización de IP, comprobaciones y consultas. [Captura conforme](evidencias/capturas-conformes/F7-scripts.png). | Nada. Si cambian los scripts, mantener los comentarios. |
| F8 | Mapa arquitectura propio | /diagramas | Listo | Mapa propio Mermaid con los roles actuales, en [diagramas/arquitectura.md](diagramas/arquitectura.md) y [renderizado](diagramas/arquitectura.png). | Nada. Si cambia la topología, actualizar el diagrama. |
| F9 | proyecto.md: Informe extenso Fases 0-5 paso a paso | proyecto.md | Parcial | Informe de las Fases 0–5 en [PROYECTO.md](PROYECTO.md), con los requisitos de la Guía por fase, comandos, resultados e incidencias. | Integrar las capturas conformes que faltan, con su comentario. **El Word no es necesario.** |
| F10 | Capturas de evidencias (Fases 0-5) con normativa y comentadas | proyecto.md | Parcial | [Capturas conformes](evidencias/capturas-conformes/INDICE.md) generadas con el [procedimiento](entrega/PROCEDIMIENTO-CAPTURAS.md). Las demás capturas son reales, pero no cumplen la norma. | Hay 11 capturas conformes de 50, más las 6 con sesión de una persona. El resto requiere laboratorio activo, SSH y, para las pruebas, autorización. |
| F11 | Reparto tareas y reflexión | gestion.md | Parcial | [GESTION.md](GESTION.md) es un borrador con datos reales de GitHub, Git y la organización del equipo. | Ya recoge la organización acordada y separa lo asignado de lo realizado. Falta el trabajo real de cada integrante, sus seguimientos de los viernes y la reflexión. Trello y el seguimiento semanal son normas internas del grupo, no requisitos de la Rúbrica. |
| F12 | Sin credenciales, claves ni estado de tf | Repo y .gitignore | Listo | Revisión de todo el historial sin credenciales, claves ni estado: [registro](evidencias/auditoria/registro-repositorio.txt) y [captura conforme](evidencias/capturas-conformes/F12-seguridad.png). | Repetir con `scripts/revisar-secretos.py` antes de integrar la PR. |
| F13 | Documentación práctica individual | /practica-individual | Pendiente | [`practica-individual/`](practica-individual/README.md) solo contiene instrucciones y una plantilla, sin ninguna práctica. | Cada integrante debe aportar la documentación de su práctica individual previa de EC2. |

### G · Exposición y defensa — 2 p (G1 0,5 · G2 1 · G3 0,5)

| Cód. | Qué pide | Evidencia exigida | Estado | Comprobación o evidencia | Pendiente |
| --- | --- | --- | --- | --- | --- |
| G1 | Exposición (10 min): demo, arquitectura, código | Día exposición | Pendiente | Material preparado: [guion para cuatro integrantes, demostraciones y preguntas](entrega/DEFENSA.md) y [presentación](entrega/presentacion-cloud-g5.pptx). No consta exposición realizada. | Asignar partes, ensayar y hacer la exposición, con caída de un nodo en directo. |
| G2 | Preguntas individuales a cualquier miembro | Día exposición | Pendiente | [Preguntas de repaso](entrega/DEFENSA.md#preguntas-del-profesor) preparadas. No consta defensa individual. | Cada integrante debe prepararla: 2 o 3 preguntas sobre cualquier parte. |
| G3 | Demostración técnica individual | Día exposición | Pendiente | [Demostraciones](entrega/DEFENSA.md#demostraciones) preparadas. No consta demostración individual evaluada. | Cada integrante debe hacerla en directo. Requiere laboratorio activo y acceso SSH. |

## Capturas que faltan

**Con sesión de AWS o GitHub**, que debe hacer un integrante. Deben cumplir la norma de la Guía y no mostrar el identificador de la cuenta:

1. **A2 y E5.** AWS Console → EC2 → Instances, en us-east-1, filtrando por `g5`. Mostrar Name, Instance ID, Instance type, Instance state y Status check.
2. **A6.** En la misma vista, seleccionar manager-g5 y abrir Tags para mostrar `PruebaA6=reto4-g5`.
3. **A3.** EC2 → Security Groups → `reto4-cloud-g5` → Inbound rules.
4. **F1.** GitHub → Settings → Collaborators, incluyendo la cuenta del profesor.
5. **F2.** GitHub → Pull requests → PR #1, pestañas Conversation y Commits.
6. **F5, opcional.** El Codespace abierto en el navegador, como apoyo a la [captura conforme](evidencias/capturas-conformes/F5-entorno.png).

Guardarlas en `evidencias/capturas-web/`.

**Durante E4 y E8:** la consola de EC2 con la instancia detenida.

**De terminal:** [11 capturas conformes ya generadas](evidencias/capturas-conformes/INDICE.md). El resto se genera con el [procedimiento](entrega/PROCEDIMIENTO-CAPTURAS.md): las de solo lectura, con el laboratorio activo y SSH, y las de pruebas, además, con autorización.

## Cierre técnico del 5 de noviembre de 2026

La Guía CLOUD y la Rúbrica CLOUD originales no están en el Codespace ni en el
repositorio. Esta revisión parte de la matriz anterior y no vuelve a cotejar
los documentos originales.

### Auditoría y revisión de E4 y E8

[Informe de la auditoría](evidencias/auditoria/INFORME.md) y [revisión de E4 y E8](evidencias/auditoria/E4-E8.md). Se retiró de la
documentación la afirmación de que en E8 Swarm devolvió `Unknown/Unreachable`, porque ningún registro la contiene. También se
corrigieron E4 y E8, que pasan a parcial.

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
visto bueno de Cristina. Las cuatro fases están completadas.

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
- **Reparto al terminar esta fase:** manager-g5 1, worker1-g5 1, worker2-g5 2 y worker3-g5 0.
  La IP de worker3-g5 respondió HTTP 200, como muestra [el estado
  final](evidencias/F3-estado-final.txt). E6 dejó después una réplica por nodo.
- Las sondas toman una muestra por segundo y por IP. No acreditan disponibilidad continua.
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

### Fase 4: E2, E3 y E6 con la web definitiva

Ejecutadas por separado el 5 de noviembre de 2026, sin crear ni eliminar recursos AWS. Las sondas
toman una muestra por segundo y por IP, y no acreditan disponibilidad continua.

| Prueba | Hora UTC | Resultado | Sondas |
| --- | --- | --- | --- |
| [E2](evidencias/F4-E2/registro.txt) | 09:34–09:36 | 8/8, 12/12, 2/2 y 4/4, con HTTP 200 en las cuatro IP tras cada estado | 562 correctas, 2 tiempos de espera aislados |
| [E3](evidencias/F4-E3/registro.txt) | 09:44–09:45 | Contenedor eliminado, tarea de reemplazo creada, 4/4 y HTTP 200 | 308 correctas, 0 fallos |
| [E6](evidencias/F4-E6/registro.txt) | 09:46–09:48 | Drain y migración, vuelta a Active, `--force`, una réplica por nodo y HTTP 200 | 488 correctas, 0 fallos |

**E2.** Durante la reducción de 12 a 2 réplicas, a las 09:35:38 UTC, se registraron dos tiempos de
espera aislados: una muestra de 34.230.4.20 y otra de 98.81.203.125 superaron el límite de 0,9 s.
Las muestras anterior y siguiente de cada IP fueron correctas. Son 2 de 564 peticiones. No se ha
determinado la causa. El registro termina en `exit=1` porque en ese momento el script trataba
cualquier fallo de sonda como error.

**Criterio de E3 y E6.** Registrar todos los fallos HTTP, incluidos los aislados, y detener la
prueba si no se recupera el número esperado de réplicas, si alguna IP sigue fallando al terminar
o si una misma IP registra tres fallos consecutivos. No se activó ninguna de estas condiciones.

**E3.** A las 09:45:01 UTC se eliminó con `docker rm -f` el contenedor `223aad67af29` de la tarea
`reto4_web.1`, en manager-g5. Swarm la marcó como fallida (`non-zero exit (137)`) y creó la tarea
`lgmt4tdycl4a` en el mismo nodo. A las 09:45:16 UTC el servicio estaba en 4/4.

**E6.** A las 09:46:31 UTC worker3-g5 pasó a Drain y su tarea migró a worker2-g5, con reparto
1-1-2-0 y 4/4. Tras volver a Active, la actualización `--force` terminó con reparto 1-1-1-1.

**Estado final, comprobado a las 09:48 y a las 09:56 UTC.** Cuatro nodos Ready/Active, `reto4_web` en 4/4 con
`innnx/reto4-f1:1.0`, una réplica por nodo y HTTP 200 en las cuatro IP.
[Captura](evidencias/capturas-terminal/estado-final.png).

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

## Registro histórico

Conservado como registro del proceso. **Contiene planes y estados superados**: lo vigente está en los apartados anteriores.

### Orden de cierre

Plan original, conservado como registro. Las tareas vigentes están en
[PENDIENTES](entrega/PENDIENTES.md).

1. Completar capturas y contrastarlas con los registros existentes. Identificar la cuenta del profesor y confirmar su acceso.
2. Incorporar las claves públicas de los colaboradores y la práctica individual real. Aclarar con el profesor la discrepancia sobre vockey. Completar GESTION.md con el reparto real.
3. Integrar la web F1 definitiva y construir sus dos versiones. Solicitar autorización para publicar en Docker Hub. Actualizar README y repetir las comprobaciones sobre el artefacto final.
4. Completar E5 con el reinicio autorizado de Learner Lab. A6 requiere documentar el cambio y la destrucción autorizados. Repetir E8 con sondeo independiente si se exige una serie sin huecos.
5. Revisar PR, archivos sensibles, informe y enlaces de entrega. Integrar en la rama de entrega acordada y preparar la exposición y pruebas individuales.


En E8, la última muestra antes de la interrupción fue a las 21:15:14 y la primera posterior a las 21:15:48, hora de Madrid. Las dos respuestas fueron correctas. Entre ambas muestras transcurrieron 34 segundos sin observaciones intermedias.

### Preparación operativa de lo pendiente

Plan original, conservado como registro.

| Bloque | Preparación y criterio de cierre |
| --- | --- |
| E5 | Antes del reinicio autorizado, conservar IDs, IP privadas, tres managers, líder, 4/4 y HTTP. Tras el reinicio de Learner Lab, revalidar sesión, consultar IP públicas actuales, ajustar alias con la huella conocida y comprobar SSH, los cuatro nodos, la distribución de tareas y el portal. Fechar y comparar las capturas. |
| A6 | Conservar la salida de validación, plan y apply. Preparar en una rama un cambio acotado y revisar su plan para excluir sustituciones. Aplicarlo solo con autorización. Dejar la prueba de destrucción para el final, con alcance e impacto revisados y autorización separada. |
| Web F1 | Sustituir el contenido provisional de las dos versiones por el artefacto del grupo. Mantener la identidad y versión por réplica, construir ambas imágenes y verificar el contenido y la comprobación HTTP. |
| Docker Hub | Definir cuenta y repositorio, verificar acceso sin guardar credenciales, obtener autorización para publicar y guardar evidencia de ambas etiquetas y sus digests. Desplegar las imágenes aprobadas, verificar 4/4 y el acceso por las cuatro IP y repetir las pruebas que requiera el docente. |
| Entrega | Confirmar acceso del profesor y claves públicas individuales, añadir las prácticas y reparto reales, revisar la PR y evidencias con el grupo. Integrar en main después de la revisión. |

### Preparación de E5 y A6

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

### Integración de la web final

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

### Revisión del ZIP de la web F1 definitiva

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

#### E5 y comparación de discos

Se confirmó que el plan operativo no propone acciones sobre recursos AWS.
Terraform señala una actualización de la salida nodes a partir de las IP
reales. El estado se conservó sin aplicar ese cambio. Se guardó la referencia
privada de IDs y volúmenes raíz. verificar-e5.sh ahora compara cada disco
adjunto con esa referencia antes de comprobar SSH y Swarm. El reinicio
autorizado requiere End Lab y Start Lab desde la sesión de AWS Academy.
E5 seguirá pendiente hasta que consten el reinicio y las comprobaciones posteriores.

#### E5 tras End Lab y Start Lab

El usuario confirmó el reinicio y el indicador verde de AWS Academy.
A las 21:51 de Madrid, el comprobador se detuvo en DescribeInstanceStatus
por una denegación explícita de la política voc-cancel-cred. La sesión
anterior de Codespaces requiere credenciales temporales nuevas. El error
no permite confirmar ni descartar cambios en los recursos. E5 sigue
pendiente de la comparación de EC2, discos, SSH, cuórum y HTTP.
[Registro posterior saneado](evidencias/E5-verificacion-posterior.txt).
