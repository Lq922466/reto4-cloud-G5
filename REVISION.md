# Revisión de entrega RETO 4 CLOUD

**Actualización de contexto (20/11/2026):** la coordinadora confirma que la presentación ya se realizó y que comprobó los accesos SSH del equipo. Las tablas siguientes corresponden a la auditoría documental del 18 de noviembre; sus estados no se han recalculado como si se hubieran obtenido nuevas capturas.

Estado de los 42 criterios de la Rúbrica, revisado el **18 de noviembre de 2026** con las evidencias del repositorio. El último estado
técnico registrado es del 9 de noviembre (Swarm, SSH y web) y del 10 de noviembre (Terraform). Desde entonces no se ha accedido a AWS ni
al clúster. El procedimiento y la explicación de cada criterio están en [PROYECTO.md](PROYECTO.md); los originales de la Guía y la
Rúbrica se conservan fuera del repositorio, y su análisis está en el [contraste](entrega/CONTRASTE-GUIA-RUBRICA.md).

**Regla de la Rúbrica:** cada requisito puntúa solo si funciona durante la corrección y está respaldado por la captura correspondiente
(según instrucciones) y los archivos correspondientes en el repositorio. Ítem completo: puntuación entera. Ítem parcial: mitad. No
conseguido: 0.

**Normas de la Guía para las capturas:** debe verse claramente el prompt con el hostname y la fecha/hora; cada captura debe incluir un
comentario indicando qué prueba es, el resultado y el autor; y está estrictamente prohibido mostrar credenciales de AWS o claves privadas.

- **Listo:** cumple lo exigido, con su captura conforme y sus archivos en el repositorio.
- **Demostrado, falta captura conforme:** hay una comprobación real registrada, pero falta la captura concreta que pide la Rúbrica
  (por ejemplo, la de la consola de EC2) o la captura versionada no refleja el estado comprobado.
- **Parcial:** una parte del requisito está sin cumplir.
- **Pendiente:** no hay trabajo real que presentar.

Ningún estado es una calificación. En [PROYECTO.md](PROYECTO.md), «Listo» y «Demostrado, falta captura conforme» aparecen como
«Cumplido», indicando la captura que falta.

## Resumen

| Situación | Nº | Criterios |
| --- | --- | --- |
| Listo | 22 | A1, A4, A5, B2, B3, B4, B5, C1, C2, C4, D1, D2, E1, E5, F3–F9, F12 |
| Demostrado, falta captura conforme | 9 | A2, A3, C3, D3, E2, E3, E6, E7, F1 |
| Parcial | 7 | A6, B1, E4, E8, F2, F10, F11 |
| Pendiente | 4 | F13, G1, G2, G3 |

**Antes de la corrección** hay que iniciar el laboratorio y comprobar el estado con `scripts/comprobar-laboratorio.sh`: la Rúbrica
solo puntúa lo que funcione ese día. **No se debe ejecutar un `terraform apply` normal** hasta fijar la imagen de Ubuntu, porque el
plan del 10 de noviembre propone sustituir las cuatro instancias ([incidencia I1.4](PROYECTO.md#115-incidencias-reales-y-soluciones)).

**Documentos de entrega:** [informe técnico](PROYECTO.md), [índice de evidencias](evidencias/INDICE.md),
[capturas conformes](evidencias/capturas-conformes/INDICE.md), [checklist final](entrega/CHECKLIST-FINAL.md),
[tareas pendientes](entrega/PENDIENTES.md), [plan de C3, E4 y E8](entrega/PLAN-C3-E4-E8.md), [defensa](entrega/DEFENSA.md),
[gestión](GESTION.md) y [registro histórico de esta revisión](entrega/historico/REVISION-2026-11-05.md).

## Matriz por criterio

«Qué pide» y «Evidencia exigida» son el texto literal de la Rúbrica. `CC/` es la carpeta
[evidencias/capturas-conformes/](evidencias/capturas-conformes/INDICE.md).

### A · Infraestructura con Terraform — 2 p

| Cód. | Qué pide | Evidencia exigida | Estado | Comprobación o evidencia | Pendiente |
| --- | --- | --- | --- | --- | --- |
| A1 | Proyecto organizado, con variables | Ficheros en /terraform | Listo | Módulo con variables de grupo, tamaños, discos, imagen y accesos SSH, con validaciones. [CC/A1-modulo](evidencias/capturas-conformes/A1-modulo.png). | Fijar la imagen de Ubuntu antes de cualquier `apply` (I1.4). |
| A2 | Manager + 3 workers definidos una vez; etiquetas | Código; consola EC2 | Demostrado, falta captura conforme | Un manager t3.medium y tres workers t3.small de un único recurso con `count`, etiquetados y en ejecución. [CC/F6-codigo](evidencias/capturas-conformes/F6-codigo.png) y [CC/A2-instancias](evidencias/capturas-conformes/A2-instancias.png), del 6 de noviembre. | Captura de **EC2 → Instances** en la consola, sin el ID de la cuenta. |
| A3 | Security group con política de mínimos | Código; reglas EC2 | Demostrado, falta captura conforme | Grupo único: SSH solo desde `/32`, 80 y 8080 públicos, y 2377, 7946, 4789, ICMP y 22 interno solo entre nodos. [CC/A3-reglas](evidencias/capturas-conformes/A3-reglas.png), del 6 de noviembre. El 9 de noviembre había además la regla temporal `88.14.93.201/32` para B1. | Captura de las reglas de entrada en la consola. Retirar la regla temporal al terminar B1. |
| A4 | Script de arranque (hostname, zona, Docker, claves) | Script /terraform; log | Listo | [CC/A4-script](evidencias/capturas-conformes/A4-script.png) y [CC/A4-arranque](evidencias/capturas-conformes/A4-arranque.png): cloud-init terminado en los cuatro nodos, con Europe/Madrid y Docker. | Nada. |
| A5 | Salidas con IP pública, privada e ID | Salida de Terraform | Listo | Salida `nodes` con IP pública, IP privada e ID: [CC/A5-salidas](evidencias/capturas-conformes/A5-salidas.png). El 10 de noviembre el estado se sincronizó con `refresh-only` y las salidas coinciden con EC2 (registro privado, fuera de Git). | Versionar un extracto del `refresh-only` sin datos de la cuenta. |
| A6 | Pruebas clave: validación, plan, cambio, destrucción | Secuencia capturas | Parcial | Validación, plan y apply iniciales, y cambio controlado del 5 de noviembre (0 altas, 1 cambio, 0 destrucciones): [plan](evidencias/A6-plan-final.txt) y [apply](evidencias/A6-apply.txt). El plan posterior dio [NO CORRECTO](evidencias/capturas-conformes/A6-sin-cambios.png) el 6 de noviembre, y el del 10 propone sustituir las instancias por la AMI nueva. | Fijar la AMI y obtener `No changes`; destrucción con autorización y tras consultarlo; secuencia completa en capturas. |

### B · Acceso remoto por SSH — 1 p

| Cód. | Qué pide | Evidencia exigida | Estado | Comprobación o evidencia | Pendiente |
| --- | --- | --- | --- | --- | --- |
| B1 | Clave propia en 4 nodos; vockey sustituida | Repositorio; authorized_keys | Parcial | Las cuatro claves públicas están en [`terraform/claves/`](terraform/claves/) e instaladas en los cuatro nodos: [CC/B1-clave-nodos](evidencias/capturas-conformes/B1-clave-nodos.png). Cristina entró con la suya en los cuatro nodos ([CC/B1-registro-cristina](evidencias/capturas-conformes/B1-registro-cristina.png)); los registros conservados de Enrique, Alexandra e Ibai solo acreditan manager-g5 ([CC/B1-registro-manager](evidencias/capturas-conformes/B1-registro-manager.png) y [capturas de los integrantes](evidencias/capturas-integrantes/INDICE.md)). La coordinadora confirma posteriormente que también comprobó sus accesos a workers, sin capturas conformes adicionales. | Capturas comentadas de las conexiones de Enrique, Alexandra e Ibai a los workers (la comprobación es confirmación de la coordinadora); captura `B1-repositorio`; aclarar `vockey`: la Guía la deja de reserva y la Rúbrica la sustituye. |
| B2 | Archivo config SSH con nombre corto | /config; conexión | Listo | Plantillas y configuración aplicada en [/config](config/README.md): [CC/B2-plantilla](evidencias/capturas-conformes/B2-plantilla.png) y conexión real con el nombre corto: [CC/B2-conexion](evidencias/capturas-conformes/B2-conexion.png). | Regenerar los alias con `actualizar-ips.sh` tras cada reinicio. |
| B3 | Control total, órdenes simultáneas y copia ficheros | Capturas cliente | Listo | [CC/B3-simultaneo](evidencias/capturas-conformes/B3-simultaneo.png) y [CC/B3-copia](evidencias/capturas-conformes/B3-copia.png): misma orden a la vez en los cuatro nodos, `sudo` y SCP con SHA-256 coincidente. | Nada. |
| B4 | Sin contraseña ni root; permisos locales | Config SSH; permisos | Listo | [CC/B4-endurecimiento](evidencias/capturas-conformes/B4-endurecimiento.png): root y contraseña desactivados, y permisos 700 y 600. | Nada. |
| B5 | Acceso a workers por IP privada (salto) | Conexión con salto | Listo | [CC/B5-salto](evidencias/capturas-conformes/B5-salto.png): los tres workers por IP privada a través del manager. | Nada. |

### C · Clúster Docker Swarm — 1 p

| Cód. | Qué pide | Evidencia exigida | Estado | Comprobación o evidencia | Pendiente |
| --- | --- | --- | --- | --- | --- |
| C1 | Docker en 4 nodos; conectividad por IP privada | Ping entre nodos | Listo | [CC/C1-ping](evidencias/capturas-conformes/C1-ping.png): Docker 29.1.3 y `ping` por IP privada sin pérdidas. | Nada. |
| C2 | Clúster por IP privada; MTU ajustado (1450) | Info clúster y redes | Listo | [CC/C2-cluster](evidencias/capturas-conformes/C2-cluster.png): Swarm anunciado por IP privada y red ingress `red-g5` con MTU 1450. | Nada. |
| C3 | 4 nodos activos, manager líder, 3 workers unidos | Listado de nodos | Demostrado, falta captura conforme | El 9 de noviembre se bajaron los dos managers temporales de E8 y manager-g5 quedó como único manager y líder, con tres workers `Ready/Active` y 100 muestras de sonda correctas. Consta en el registro de sesión de Codex, no versionado. La captura versionada, [CC/C3-nodos](evidencias/capturas-conformes/C3-nodos.png) del 6 de noviembre, da NO CORRECTO. | Con el laboratorio activo, comprobar y repetir `C3-nodos`. |
| C4 | Red overlay propia para servicios | Listado de redes | Listo | [CC/C4-red](evidencias/capturas-conformes/C4-red.png): `red-app-g5`, overlay propia con MTU 1450. | Nada. |

### D · Despliegue de la web — 0,5 p

| Cód. | Qué pide | Evidencia exigida | Estado | Comprobación o evidencia | Pendiente |
| --- | --- | --- | --- | --- | --- |
| D1 | Imagen propia (identifica contenedor); ver 1.0 y 2.0 | /app; Docker Hub | Listo | Imagen propia que identifica cada contenedor, con etiquetas 1.0 y 2.0: [CC/D1-dockerhub](evidencias/capturas-conformes/D1-dockerhub.png), [publicación](evidencias/D1-publicacion-dockerhub.txt) y [descarga anónima](evidencias/D1-descarga-dockerhub.txt). | Mostrar Docker Hub en la defensa. |
| D2 | Servicio 4 réplicas, red grupo, políticas reinicio | Fichero despliegue | Listo | [`app/stack.yml`](app/stack.yml) y [CC/D2-servicio](evidencias/capturas-conformes/D2-servicio.png): cuatro réplicas, `red-app-g5`, reinicio siempre y actualización con rollback. [Despliegue](evidencias/F3-despliegue/registro.txt). | Nada. |
| D3 | Accesible por IP pública de los 4 nodos | Navegador | Demostrado, falta captura conforme | Web definitiva en un navegador real por las cuatro IP del 5 de noviembre: [manager-g5](evidencias/D3-navegador-manager-g5.png), [worker1-g5](evidencias/D3-navegador-worker1-g5.png), [worker2-g5](evidencias/D3-navegador-worker2-g5.png) y [worker3-g5](evidencias/D3-navegador-worker3-g5.png). HTTP 200 en las cuatro IP el 9 de noviembre. | Capturas con el comentario de la norma, con las IP del día de la corrección. |

### E · Pruebas de orquestación — 1,5 p

| Cód. | Qué pide | Evidencia exigida | Estado | Comprobación o evidencia | Pendiente |
| --- | --- | --- | --- | --- | --- |
| E1 | Balanceo de carga | Respuestas distintas | Listo | [CC/E1-balanceo](evidencias/capturas-conformes/E1-balanceo.png): las peticiones por las cuatro IP reciben respuesta de contenedores distintos. Repetido el 9 de noviembre con 48 peticiones. | Nada. |
| E2 | Escalado (8, 12, 2) | Reparto de réplicas | Demostrado, falta captura conforme | Con la web definitiva: 8/8 (2-2-2-2), 12/12 (3-3-3-3), 2/2 y vuelta a 4/4, con HTTP 200 en las cuatro IP. 562 muestras correctas y dos tiempos de espera aislados. [Registro y capturas](evidencias/F4-E2/registro.txt). | Capturas conformes antes, durante y después, con la sonda visible. Requiere autorización. |
| E3 | Autorreparación (eliminar contenedor) | Servicio antes/después | Demostrado, falta captura conforme | Con la web definitiva: contenedor eliminado y reemplazado, vuelta a 4/4, 308 muestras correctas y 0 fallos. [Registro y capturas](evidencias/F4-E3/registro.txt). | Capturas conformes, con la sonda visible. Requiere autorización. |
| E4 | Alta disponibilidad (caída worker) | Nodo caído; script OK | Parcial | Solo con el portal provisional (4 de noviembre): worker3-g5 detenido, marcado `Down`, tarea reubicada y vuelta a 4/4, con 164 muestras correctas. [Análisis](evidencias/auditoria/E4-E8.md). | Repetir con la web definitiva y capturas conformes, según el [plan](entrega/PLAN-C3-E4-E8.md). Es también la demostración en directo de la exposición. |
| E5 | Reincorporación y reequilibrio; reinicio lab | Nodos y servicio | Listo | [CC/E5-estado](evidencias/capturas-conformes/E5-estado.png): tras reiniciar el laboratorio, las mismas instancias siguen en el clúster con 4/4. Reequilibrio con `docker service update --force` en E6. [Antes](evidencias/E5-verificacion-previa.txt) y [después](evidencias/E5-verificacion-final.txt) del reinicio del 4 al 5 de noviembre. | Comprobar el clúster tras el reinicio del 10 de noviembre. |
| E6 | Mantenimiento (modo drain) | Nodos y servicio | Demostrado, falta captura conforme | Con la web definitiva: worker3-g5 en `Drain`, tarea trasladada, vuelta a `Active` y una réplica por nodo tras `--force`. 488 muestras correctas y 0 fallos. [Registro y capturas](evidencias/F4-E6/registro.txt). | Capturas conformes, con la sonda visible. Requiere autorización. |
| E7 | Actualización (1.0 a 2.0) sin corte y rollback | Script y navegador | Demostrado, falta captura conforme | Con la web definitiva: 1.0 → 2.0 → 1.0, ambos en 4/4, con 620 muestras correctas y 0 fallos, y navegador en cada versión. [Registro](evidencias/F3-actualizacion/registro.txt). | Captura conforme durante la actualización, con la sonda y el navegador. Requiere autorización. |
| E8 | Alta disp. managers (nuevo líder) | Listado desde otro | Parcial | Solo con el portal provisional (4 de noviembre): con tres managers se detuvo el líder y worker2-g5 pasó a líder, comparando antes y después. 34 s sin muestras de sonda. [Análisis](evidencias/auditoria/E4-E8.md). | Repetir con la web definitiva, con `docker node ls` desde otro manager durante la parada, y restaurar C3 después. |

### F · Repositorio GitHub y Entorno (Fase 0) — 2 p

| Cód. | Qué pide | Evidencia exigida | Estado | Comprobación o evidencia | Pendiente |
| --- | --- | --- | --- | --- | --- |
| F1 | La Rúbrica original pide repositorio privado, colaboradores y profesor invitado; según la coordinadora, el profesor indicó después cambiarlo a público, y así consta desde el 20/11 | Settings | Demostrado, falta captura conforme | Repositorio **público desde el 20/11**, según la indicación posterior del profesor comunicada por la coordinadora (la captura corresponde al estado privado del 18/11); colaboradores Enrique, Alexandra, Ibai y el profesor (jc-csl), con escritura, y Cristina como administradora: [CC/F1-repositorio](evidencias/capturas-conformes/F1-repositorio.png), del 18 de noviembre. | Captura de **Settings → Collaborators** en el navegador. |
| F2 | Commits repartidos y uso de Pull Requests por colaboradores | Historial y PRs | Parcial | `main` integra todo el historial con la PR #1 (fusionada el 18 de noviembre). Commits de Cristina (Innnx), de Codex y uno de Enrique, en la PR #2 (6 de noviembre). Las PR #3–#5 se abrieron desde la cuenta de Cristina con borradores de Codex y no son trabajo propio de los integrantes. [CC/F2-historial](evidencias/capturas-conformes/F2-historial.png), del 5 de noviembre. | Commits y PR de Alexandra e Ibai desde sus cuentas, y de Enrique desde un terminal. Captura del historial de `main` y de las PR. |
| F3 | README.md (resumen, instrucciones rápidas, enlaces) | README.md | Listo | [README](README.md) con resumen, estructura, despliegue y enlace a Docker Hub. | Nada. |
| F4 | Estructura (/terraform, /app, /config, y .devcontainer) | Árbol repo | Listo | Carpetas de la Guía en `main` desde el 18 de noviembre: [CC/F4-estructura](evidencias/capturas-conformes/F4-estructura.png), tomada el 5 de noviembre en la rama que se integró. | Nada. |
| F5 | Entorno colaborativo: .devcontainer (AWS CLI, Terraform) y capturas Codespace | .devcontainer.json, proyecto.md | Listo | `devcontainer.json` con AWS CLI y Terraform, funcionando: [CC/F5-entorno](evidencias/capturas-conformes/F5-entorno.png), integrada en `PROYECTO.md`. | Opcional: vista del Codespace en el navegador. |
| F6 | Código Terraform funcional | /terraform | Listo | Código validado que creó los cinco recursos reales: [CC/F6-codigo](evidencias/capturas-conformes/F6-codigo.png) y [apply inicial](evidencias/prototipo/reto4-apply.log). | Fijar la AMI antes del siguiente `apply` (I1.4). |
| F7 | Scripts comentados | /scripts | Listo | Cabecera con qué hace, cuándo se usa y su efecto: [CC/F7-scripts](evidencias/capturas-conformes/F7-scripts.png). | Nada. |
| F8 | Mapa arquitectura propio | /diagramas | Listo | Mapa Mermaid propio, actualizado el 18 de noviembre a la topología de un manager líder y tres workers: [diagramas/arquitectura.md](diagramas/arquitectura.md) y [renderizado](diagramas/arquitectura.png). | Nada. |
| F9 | proyecto.md: Informe extenso Fases 0-5 paso a paso | proyecto.md | Listo | [PROYECTO.md](PROYECTO.md): Fases 0–5 con objetivo, contenidos, procedimientos, comandos, comprobación, incidencias reales y posibles, y conclusiones. | Las capturas que faltan se cuentan en F10. |
| F10 | Capturas de evidencias (Fases 0-5) con normativa y comentadas | proyecto.md | Parcial | 32 [capturas conformes](evidencias/capturas-conformes/INDICE.md) de los días 5, 6, 9 y 18 de noviembre, integradas en `PROYECTO.md`. Las capturas de las pruebas E2, E3, E6 y E7, las de D3 y las de los integrantes no tienen el comentario de la norma. | Las capturas de la tabla siguiente. |
| F11 | Reparto tareas y reflexión | gestion.md | Parcial | [GESTION.md](GESTION.md) recoge la organización acordada y separa lo asignado de lo realizado, con datos reales de Git y GitHub. | Trabajo real, seguimiento y reflexión de cada integrante. |
| F12 | Sin credenciales, claves ni estado de tf | Repo y .gitignore | Listo | [`.gitignore`](.gitignore) y revisión de secretos antes de integrar en `main`: [CC/F12-seguridad](evidencias/capturas-conformes/F12-seguridad.png), del 18 de noviembre, y [revisión del historial](evidencias/auditoria/registro-repositorio.txt). | Repetir `revisar-secretos.py 6f3d838 HEAD` antes de cada integración. |
| F13 | Documentación práctica individual | /practica-individual | Pendiente | [`practica-individual/`](practica-individual/README.md) solo contiene instrucciones y una plantilla. | Cada integrante debe aportar su práctica individual previa de EC2. |

### G · Exposición y defensa — 2 p (G1 0,5 · G2 1 · G3 0,5)

| Cód. | Qué pide | Evidencia exigida | Estado | Comprobación o evidencia | Pendiente |
| --- | --- | --- | --- | --- | --- |
| G1 | Exposición (10 min): demo, arquitectura, código | Día exposición | Pendiente | Material preparado: [guion, demostraciones y preguntas](entrega/DEFENSA.md) y [presentación](entrega/presentacion-cloud-g5.pptx). El material conservado describía tres managers y corresponde a un guion anterior. La coordinadora confirma que la presentación se realizó posteriormente; no consta en el repositorio qué demostraciones se hicieron en directo. | Estado de esta matriz cerrado el 18/11: no hay acta ni prueba documental de la demostración; su valoración corresponde al profesor. |
| G2 | Preguntas individuales a cualquier miembro | Día exposición | Pendiente | [Preguntas de repaso](entrega/DEFENSA.md#preguntas-del-profesor) preparadas. | Cada integrante debe prepararlas: 2 o 3 preguntas sobre cualquier parte. |
| G3 | Demostración técnica individual | Día exposición | Pendiente | [Demostraciones](entrega/DEFENSA.md#demostraciones) preparadas. | Cada integrante debe hacerla en directo. Requiere laboratorio activo y acceso SSH. |

## Capturas que faltan

**Con sesión de AWS o GitHub, en el navegador.** Deben cumplir la norma de la Guía y no mostrar el identificador de la cuenta:

1. **A2.** AWS Console → EC2 → Instances, en us-east-1, filtrando por `g5`: Name, Instance ID, Instance type, Instance state y
   Status check.
2. **A6.** En la misma vista, manager-g5 → Tags, con `PruebaA6=reto4-g5`.
3. **A3.** EC2 → Security Groups → `reto4-cloud-g5` → Inbound rules.
4. **F1.** GitHub → Settings → Collaborators, con la cuenta del profesor.
5. **F2.** GitHub → Pull requests, con las PR #1 a #5, y el historial de `main`.
6. **F5, opcional.** El Codespace abierto en el navegador.

Guardarlas en `evidencias/capturas-web/`.

**De terminal, con el laboratorio activo** ([procedimiento](entrega/PROCEDIMIENTO-CAPTURAS.md)):

- `C3-nodos`, D3 con comentario y `comprobar-laboratorio.sh` terminando con código 0.
- E2, E3, E6 y E7 antes, durante y después, con la sonda visible. Requieren autorización.
- E4 y E8 con la web definitiva, y la consola de EC2 con la instancia detenida. Requieren autorización.
- Accesos de Enrique, Alexandra e Ibai a los workers, con su comentario, y `B1-registro-*` de cada uno.
- Secuencia de A6: `validate`, plan, cambio, plan con `No changes` y destrucción, cuando se autorice.
