# Checklist final de entrega · RETO 4 CLOUD, Grupo 5

Situación a 5 de noviembre de 2026, contrastada con la Guía y la Rúbrica originales. [Contraste completo](CONTRASTE-GUIA-RUBRICA.md).

| Situación | Nº | Criterios |
| --- | --- | --- |
| Listos | 8 | F3, F4, F6, F8, F12, A1, D1, D2 |
| Demostrados, falta captura conforme | 18 | F5, A2, A3, A4, A5, B3, B4, B5, C1, C2, C4, D3, E1, E2, E3, E5, E6, E7 |
| Parciales | 12 | F1, F2, F7, F9, F10, F11, A6, B1, B2, C3, E4, E8 |
| Pendientes | 4 | F13, G1, G2, G3 |

**Cómo leerla.** La Rúbrica solo puntúa lo que funcione durante la corrección y tenga su captura según la norma y sus archivos. Último estado técnico
comprobado: 09:56 UTC. [Auditoría](../evidencias/auditoria/INFORME.md).

## Listos

| Criterio | Qué comprueba | Evidencia | Observación |
| --- | --- | --- | --- |
| F3 | README | [README](../README.md), [etiquetas en Docker Hub](../evidencias/D1-dockerhub-etiquetas.png) | Nada. |
| F4 | Estructura del repositorio | [CT/F4-estructura](../evidencias/capturas-terminal/F4-estructura.png) | Integrar la PR: `main` solo contiene `.devcontainer` y `terraform`. |
| F6 | Terraform funcional | [CT/A1-modulo-terraform](../evidencias/capturas-terminal/A1-modulo-terraform.png), [CT/F6-codigo-instancias](../evidencias/capturas-terminal/F6-codigo-instancias.png), [apply inicial](../evidencias/prototipo/reto4-apply.log) | Nada. Comprobar con un plan cuando el laboratorio esté activo. |
| F8 | Mapa de arquitectura | [Diagrama](../diagramas/arquitectura.md), [renderizado](../diagramas/arquitectura.png) | Nada. Si cambia la topología, actualizar el diagrama. |
| F12 | Sin credenciales, claves ni estado | [Revisión de todo el historial](../evidencias/auditoria/registro-repositorio.txt), [CT/F12-archivos-sensibles](../evidencias/capturas-terminal/F12-archivos-sensibles.png) | Repetir con `scripts/revisar-secretos.py` antes de integrar la PR. |
| A1 | Proyecto con variables | [CT/A1-modulo-terraform](../evidencias/capturas-terminal/A1-modulo-terraform.png) | Mejora: variables para el tamaño de los discos, sin cambios en AWS. |
| D1 | Imagen propia, 1.0 y 2.0 | [Construcción](../evidencias/D1-imagenes-definitivas.txt), [navegador](../evidencias/D1-navegador-registro.txt), [publicación](../evidencias/D1-publicacion-dockerhub.txt), [descarga](../evidencias/D1-descarga-dockerhub.txt), [etiquetas](../evidencias/D1-dockerhub-etiquetas.png), [CT/D1-imagenes](../evidencias/capturas-terminal/D1-imagenes.png) | Nada. Mostrar Docker Hub en la defensa. |
| D2 | Servicio de 4 réplicas | [Despliegue](../evidencias/F3-despliegue/registro.txt), [estado](../evidencias/F3-estado-final.txt), [CT/D2-pila-servicio](../evidencias/capturas-terminal/D2-pila-servicio.png) | Nada. |

## Demostrados

Hay una comprobación real, pero falta la captura conforme: prompt con hostname y fecha, y comentario con la prueba, el resultado y el autor.

| Criterio | Qué comprueba | Evidencia | Qué falta |
| --- | --- | --- | --- |
| F5 | Devcontainer y Codespace | [CT/F5-entorno](../evidencias/capturas-terminal/F5-entorno.png), [registro técnico](../evidencias/revision-registro-tecnico.txt) | Captura del Codespace funcionando y capturas conformes en `PROYECTO.md`. |
| A2 | Instancias y etiquetas | [CT/A2-instancias](../evidencias/capturas-terminal/A2-instancias.png) | Captura de la consola de EC2 con la norma de capturas. |
| A3 | Grupo de seguridad | [CT/A3-grupo-seguridad](../evidencias/capturas-terminal/A3-grupo-seguridad.png) | Captura de reglas en la consola. El puerto 8080 lo exige la Guía. |
| A4 | Script de arranque | [CT/A4-arranque](../evidencias/capturas-terminal/A4-arranque.png), [registro de arranque](../evidencias/prototipo/manager-g5.txt) | Rehacer la captura con prompt y comentario. |
| A5 | Salidas | [CT/A5-salida-nodes](../evidencias/capturas-terminal/A5-salida-nodes.png) | Rehacer la captura con prompt y comentario. |
| B3 | Control, simultaneidad y copia | [CT/B3-simultaneo-sudo](../evidencias/capturas-terminal/B3-simultaneo-sudo.png), [CT/B3-copia-scp](../evidencias/capturas-terminal/B3-copia-scp.png) | Rehacer las capturas con prompt y comentario. |
| B4 | Sin root ni contraseña, y permisos | [CT/B4-endurecimiento](../evidencias/capturas-terminal/B4-endurecimiento.png) | Rehacer la captura con prompt y comentario. |
| B5 | Salto por IP privada | [CT/B5-salto](../evidencias/capturas-terminal/B5-salto.png) | Rehacer la captura con prompt y comentario. |
| C1 | Docker y ping | [CT/C1-docker-ping](../evidencias/capturas-terminal/C1-docker-ping.png) | Rehacer la captura con prompt y comentario. |
| C2 | Clúster por IP privada y MTU 1450 | [CT/C2-red-ingress](../evidencias/capturas-terminal/C2-red-ingress.png), [registro inicial](../evidencias/prototipo/fase2-3.txt) | Rehacer la captura con prompt y comentario. |
| C4 | Red overlay propia | [CT/C4-red-aplicacion](../evidencias/capturas-terminal/C4-red-aplicacion.png) | Rehacer la captura con prompt y comentario. |
| D3 | Acceso por las 4 IP | [manager-g5](../evidencias/D3-navegador-manager-g5.png), [worker1-g5](../evidencias/D3-navegador-worker1-g5.png), [worker2-g5](../evidencias/D3-navegador-worker2-g5.png), [worker3-g5](../evidencias/D3-navegador-worker3-g5.png), [método](../evidencias/D3-registro.txt), [portada completa](../evidencias/F3-web-final-1.0-completa.png) | Comentario en cada captura, y rehacerlas con las IP del día. |
| E1 | Balanceo | [CT/E1-reparto-peticiones](../evidencias/capturas-terminal/E1-reparto-peticiones.png), [estado](../evidencias/F3-estado-final.txt) | Rehacer la captura con prompt y comentario. |
| E2 | Escalado a 8, 12 y 2 | [F4-E2](../evidencias/F4-E2/): registro, sondas y capturas por estado | Capturas conformes antes, durante y después, con la sonda visible. Requiere autorización. Conservar la observación de los dos tiempos de espera. |
| E3 | Autorreparación | [F4-E3](../evidencias/F4-E3/): registro, sondas y capturas antes y después | Capturas conformes, con la sonda visible. Requiere autorización. |
| E5 | Reincorporación y reinicio del lab | [Verificación final](../evidencias/E5-verificacion-final.txt), [previa](../evidencias/E5-verificacion-previa.txt), [preparación](../evidencias/E5-preparacion.txt), [CT/estado-final](../evidencias/capturas-terminal/estado-final.png) | Captura conforme de nodos y servicio tras el próximo inicio del laboratorio, y vista de EC2. |
| E6 | Drain | [F4-E6](../evidencias/F4-E6/): registro, sondas y capturas antes, durante y después | Capturas conformes, con la sonda visible. Requiere autorización. |
| E7 | Actualización y rollback | [F3-actualizacion](../evidencias/F3-actualizacion/): registro, sondas y capturas, [CT/E7-historial-versiones](../evidencias/capturas-terminal/E7-historial-versiones.png) | Capturas conformes durante la actualización y el rollback, con la sonda y el navegador. Requiere autorización. |

## Parciales

| Criterio | Qué comprueba | Evidencia | Qué falta |
| --- | --- | --- | --- |
| F1 | Privado, colaboradores y profesor | [CT/F1-colaboradores](../evidencias/capturas-terminal/F1-colaboradores.png) | Confirmar integrantes e invitar al profesor antes de la fecha límite. Captura de Settings → Collaborators. |
| F2 | Commits y PR por integrante | [CT/F2-historial](../evidencias/capturas-terminal/F2-historial.png) | Commits y PR reales de cada integrante. Vista web de la PR. |
| F7 | Scripts comentados | [CT/F7-scripts](../evidencias/capturas-terminal/F7-scripts.png) | Ampliar los comentarios de los scripts con una sola línea y añadir un script que actualice las IP desde EC2. |
| F9 | PROYECTO.md, paso a paso | [Informe técnico](../PROYECTO.md), [estructura del Word](../entrega/INFORME-F9-estructura.md) | Integrar en `PROYECTO.md` las capturas conformes y comentadas. **El Word no es necesario.** |
| F10 | Capturas según la norma | Este índice | Ninguna captura de terminal muestra el prompt con el hostname. Rehacerlas, comentar cada una con prueba, resultado y autor, y añadir las de consola. |
| F11 | Reparto, responsables y reflexión | [GESTION (borrador)](../GESTION.md) | El grupo debe completar reparto, responsables y reflexión. Trello y el seguimiento semanal no se exigen. |
| A6 | Validación, plan, cambio y destrucción | [Plan final](../evidencias/A6-plan-final.txt), [apply del cambio](../evidencias/A6-apply.txt), [CT/A6-sin-cambios](../evidencias/capturas-terminal/A6-sin-cambios.png), [plan](../evidencias/prototipo/reto4-plan-cidr.log) y [apply](../evidencias/prototipo/reto4-apply.log) iniciales | Destrucción real, con autorización aparte y tras aclararlo con el profesor. Secuencia completa en capturas. |
| B1 | Claves propias y vockey | [CT/B1-claves-autorizadas](../evidencias/capturas-terminal/B1-claves-autorizadas.png) | Clave de cada integrante, en `/terraform` e instalada. Aclarar `vockey`: la Guía la deja de reserva y la Rúbrica la sustituye. |
| B2 | Config SSH con nombre corto | [CT/B2-alias](../evidencias/capturas-terminal/B2-alias.png) | Permitir `ssh manager-g5` sin `-F`, con `~/.ssh/config`. Añadir a `/config` las configuraciones aplicadas. |
| C3 | Manager líder y tres workers | [CT/C3-nodos](../evidencias/capturas-terminal/C3-nodos.png), [topología inicial](../evidencias/prototipo/fase2-3.txt) | Hoy hay tres managers y el líder es worker1-g5, y se pide manager líder y tres workers. Decidir si se restaura, con autorización, y capturar. |
| E4 | Caída de un worker | [Registro](../evidencias/E4-E5-E8-registro.txt), [sonda](../evidencias/prototipo/E4-E5-http.txt), [captura](../evidencias/E4-web-worker-down.png) | Repetir con la web definitiva y capturas conformes, con autorización. También es la demostración obligatoria de la exposición. |
| E8 | Nuevo líder | [Registro](../evidencias/E8-eleccion-registro.txt), [quórum previo](../evidencias/prototipo/E8-quorum-previo.txt), [captura durante](../evidencias/E8-web-parada.png), [captura después](../evidencias/E8-web-recuperado.png), [comprobación posterior](../evidencias/verificacion-posterior.txt) | Repetir con la web definitiva y capturas conformes, con autorización, listando desde otro manager durante la parada. |

## Pendientes

| Criterio | Qué comprueba | Material disponible | Qué falta |
| --- | --- | --- | --- |
| F13 | Práctica individual previa | [Estructura sin contenido](../practica-individual/README.md) | Cada integrante debe aportar la documentación de su práctica individual previa de EC2. |
| G1 | Exposición en grupo | [Guion](../entrega/DEFENSA.md), [presentación](../entrega/presentacion-cloud-g5.pptx) | Asignar partes, ensayar y hacer la exposición, con caída de un nodo en directo. |
| G2 | Preguntas individuales | [Preguntas de repaso](../entrega/DEFENSA.md#preguntas-del-profesor) | Cada integrante debe prepararla: 2 o 3 preguntas sobre cualquier parte. |
| G3 | Demostración individual | [Demostraciones](../entrega/DEFENSA.md#demostraciones) | Cada integrante debe hacerla en directo. Requiere laboratorio activo y acceso SSH. |

## Antes de entregar

### Decisiones

- [ ] Profesor consultado: `vockey`, topología final, destrucción de A6, autoría de las capturas y fecha de entrega.
- [ ] Topología final decidida y aplicada, con autorización.

### Técnica

- [ ] Laboratorio activo, credenciales renovadas y regla SSH con la IP actual.
- [ ] `ssh manager-g5` funciona sin `-F`, y `/config` incluye las configuraciones aplicadas.
- [ ] `verificar-despliegue.sh` correcto con las IP del día.
- [ ] Claves públicas de cada integrante en `/terraform` e instaladas.
- [ ] E2, E3, E4, E6, E7 y E8 repetidas con la web definitiva y capturas conformes, con autorización.

### Documentación

- [ ] Capturas de terminal rehechas con prompt y comentario, e integradas en `PROYECTO.md`.
- [ ] Seis [capturas web](../REVISION.md#capturas-que-faltan) añadidas, sin el ID de la cuenta de AWS.
- [ ] Comentarios de los scripts ampliados y script para actualizar las IP.
- [ ] [GESTION.md](../GESTION.md) con reparto, responsables y reflexión reales.
- [ ] Práctica individual en [`practica-individual/`](../practica-individual/README.md).
- [ ] Nombres y reparto en la [presentación](presentacion-cloud-g5.pptx).

### Repositorio

- [ ] Commits y PR de cada integrante.
- [ ] Profesor invitado antes de la fecha límite.
- [ ] `python3 scripts/revisar-secretos.py origin/main HEAD` sin coincidencias.
- [ ] PR revisada e integrada en `main`, que hoy solo contiene `.devcontainer` y `terraform`.

### Defensa

- [ ] Papeles A–D asignados y [guion](DEFENSA.md) ensayado en 10 minutos.
- [ ] Caída de un nodo ensayada, con el plan B a mano.
- [ ] Cada integrante puede responder las [preguntas de repaso](DEFENSA.md#preguntas-del-profesor) y hacer su demostración.
