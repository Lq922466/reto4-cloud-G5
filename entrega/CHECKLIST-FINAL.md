# Checklist final de entrega · RETO 4 CLOUD, Grupo 5

Situación a 5 de noviembre de 2026, con los requisitos exactos de la Rúbrica. [Contraste completo](CONTRASTE-GUIA-RUBRICA.md).

**Regla de la Rúbrica:** cada requisito puntúa solo si funciona durante la corrección y está respaldado por la captura correspondiente (según instrucciones) y los archivos correspondientes en el repositorio. Ítem completo: puntuación entera. Ítem parcial: mitad. No conseguido: 0.

**Normas de la Guía para las capturas:** debe verse claramente el prompt con el hostname y la fecha/hora; cada captura debe incluir un comentario indicando qué prueba es, el resultado y el autor; y está estrictamente prohibido mostrar credenciales de AWS o claves privadas.

| Situación | Nº | Criterios |
| --- | --- | --- |
| Listos | 10 | A1, D1, D2, F3, F4, F5, F6, F7, F8, F12 |
| Demostrados, falta captura conforme | 17 | A2, A3, A4, A5, B3, B4, B5, C1, C2, C4, D3, E1, E2, E3, E5, E6, E7 |
| Parciales | 11 | A6, B1, B2, C3, E4, E8, F1, F2, F9, F10, F11 |
| Pendientes | 4 | F13, G1, G2, G3 |

Último estado técnico comprobado: 09:56 UTC. [Auditoría](../evidencias/auditoria/INFORME.md).

## Listos

| Cód. | Qué pide la Rúbrica | Evidencia exigida | Nuestra evidencia | Observación |
| --- | --- | --- | --- | --- |
| A1 | Proyecto organizado, con variables | Ficheros en /terraform | [Captura conforme](../evidencias/capturas-conformes/A1-modulo.png), [CT/A1-modulo-terraform](../evidencias/capturas-terminal/A1-modulo-terraform.png) | Comprobar con un plan que las variables de disco no proponen cambios, cuando el laboratorio esté activo. |
| D1 | Imagen propia (identifica contenedor); ver 1.0 y 2.0 | /app; Docker Hub | [Captura conforme](../evidencias/capturas-conformes/D1-dockerhub.png), [Construcción](../evidencias/D1-imagenes-definitivas.txt), [navegador](../evidencias/D1-navegador-registro.txt), [publicación](../evidencias/D1-publicacion-dockerhub.txt), [descarga](../evidencias/D1-descarga-dockerhub.txt), [etiquetas](../evidencias/D1-dockerhub-etiquetas.png), [CT/D1-imagenes](../evidencias/capturas-terminal/D1-imagenes.png) | Nada. Mostrar Docker Hub en la defensa. |
| D2 | Servicio 4 réplicas, red grupo, políticas reinicio | Fichero despliegue | [Despliegue](../evidencias/F3-despliegue/registro.txt), [estado](../evidencias/F3-estado-final.txt), [CT/D2-pila-servicio](../evidencias/capturas-terminal/D2-pila-servicio.png) | Nada. |
| F3 | README.md (resumen, instrucciones rápidas, enlaces) | README.md | [README](../README.md), [etiquetas en Docker Hub](../evidencias/D1-dockerhub-etiquetas.png) | Nada. |
| F4 | Estructura (/terraform, /app, /config, y .devcontainer) | Árbol repo | [Captura conforme](../evidencias/capturas-conformes/F4-estructura.png), [CT/F4-estructura](../evidencias/capturas-terminal/F4-estructura.png) | Integrar la PR: `main` solo contiene `.devcontainer`, `.gitignore`, `README.md` y `terraform`. |
| F5 | Entorno colaborativo: .devcontainer (AWS CLI, Terraform) y capturas Codespace | .devcontainer.json, proyecto.md | [Captura conforme](../evidencias/capturas-conformes/F5-entorno.png), [CT/F5-entorno](../evidencias/capturas-terminal/F5-entorno.png), [registro técnico](../evidencias/revision-registro-tecnico.txt) | Nada imprescindible. Una vista del Codespace en el navegador sería un apoyo. |
| F6 | Código Terraform funcional | /terraform | [Captura conforme](../evidencias/capturas-conformes/F6-codigo.png), [CT/A1-modulo-terraform](../evidencias/capturas-terminal/A1-modulo-terraform.png), [CT/F6-codigo-instancias](../evidencias/capturas-terminal/F6-codigo-instancias.png), [apply inicial](../evidencias/prototipo/reto4-apply.log) | Nada. Comprobar con un plan cuando el laboratorio esté activo. |
| F7 | Scripts comentados | /scripts | [Captura conforme](../evidencias/capturas-conformes/F7-scripts.png), [CT/F7-scripts](../evidencias/capturas-terminal/F7-scripts.png) | Nada. Si cambian los scripts, mantener los comentarios. |
| F8 | Mapa arquitectura propio | /diagramas | [Diagrama](../diagramas/arquitectura.md), [renderizado](../diagramas/arquitectura.png) | Nada. Si cambia la topología, actualizar el diagrama. |
| F12 | Sin credenciales, claves ni estado de tf | Repo y .gitignore | [Captura conforme](../evidencias/capturas-conformes/F12-seguridad.png), [Revisión de todo el historial](../evidencias/auditoria/registro-repositorio.txt), [CT/F12-archivos-sensibles](../evidencias/capturas-terminal/F12-archivos-sensibles.png) | Repetir con `scripts/revisar-secretos.py` antes de integrar la PR. |

## Demostrados

Hay una comprobación real, pero falta la captura conforme. Se generan con el [procedimiento](PROCEDIMIENTO-CAPTURAS.md).

| Cód. | Qué pide la Rúbrica | Evidencia exigida | Nuestra evidencia | Qué falta |
| --- | --- | --- | --- | --- |
| A2 | Manager + 3 workers definidos una vez; etiquetas | Código; consola EC2 | [CT/A2-instancias](../evidencias/capturas-terminal/A2-instancias.png) | Captura de la consola de EC2 con la norma de capturas. |
| A3 | Security group con política de mínimos | Código; reglas EC2 | [CT/A3-grupo-seguridad](../evidencias/capturas-terminal/A3-grupo-seguridad.png) | Captura de reglas en la consola. El puerto 8080 lo exige la Guía. |
| A4 | Script de arranque (hostname, zona, Docker, claves) | Script /terraform; log | [Captura conforme](../evidencias/capturas-conformes/A4-script.png), [CT/A4-arranque](../evidencias/capturas-terminal/A4-arranque.png), [registro de arranque](../evidencias/prototipo/manager-g5.txt) | Captura conforme del log de arranque en los nodos. Ya está la del script. |
| A5 | Salidas con IP pública, privada e ID | Salida de Terraform | [CT/A5-salida-nodes](../evidencias/capturas-terminal/A5-salida-nodes.png) | Rehacer la captura con prompt y comentario. |
| B3 | Control total, órdenes simultáneas y copia ficheros | Capturas cliente | [CT/B3-simultaneo-sudo](../evidencias/capturas-terminal/B3-simultaneo-sudo.png), [CT/B3-copia-scp](../evidencias/capturas-terminal/B3-copia-scp.png) | Rehacer las capturas con prompt y comentario. |
| B4 | Sin contraseña ni root; permisos locales | Config SSH; permisos | [CT/B4-endurecimiento](../evidencias/capturas-terminal/B4-endurecimiento.png) | Rehacer la captura con prompt y comentario. |
| B5 | Acceso a workers por IP privada (salto) | Conexión con salto | [CT/B5-salto](../evidencias/capturas-terminal/B5-salto.png) | Rehacer la captura con prompt y comentario. |
| C1 | Docker en 4 nodos; conectividad por IP privada | Ping entre nodos | [CT/C1-docker-ping](../evidencias/capturas-terminal/C1-docker-ping.png) | Rehacer la captura con prompt y comentario. |
| C2 | Clúster por IP privada; MTU ajustado (1450) | Info clúster y redes | [CT/C2-red-ingress](../evidencias/capturas-terminal/C2-red-ingress.png), [registro inicial](../evidencias/prototipo/fase2-3.txt) | Rehacer la captura con prompt y comentario. |
| C4 | Red overlay propia para servicios | Listado de redes | [CT/C4-red-aplicacion](../evidencias/capturas-terminal/C4-red-aplicacion.png) | Rehacer la captura con prompt y comentario. |
| D3 | Accesible por IP pública de los 4 nodos | Navegador | [manager-g5](../evidencias/D3-navegador-manager-g5.png), [worker1-g5](../evidencias/D3-navegador-worker1-g5.png), [worker2-g5](../evidencias/D3-navegador-worker2-g5.png), [worker3-g5](../evidencias/D3-navegador-worker3-g5.png), [método](../evidencias/D3-registro.txt), [portada completa](../evidencias/F3-web-final-1.0-completa.png) | Comentario en cada captura, y rehacerlas con las IP del día. |
| E1 | Balanceo de carga | Respuestas distintas | [CT/E1-reparto-peticiones](../evidencias/capturas-terminal/E1-reparto-peticiones.png), [estado](../evidencias/F3-estado-final.txt) | Rehacer la captura con prompt y comentario. |
| E2 | Escalado (8, 12, 2) | Reparto de réplicas | [F4-E2](../evidencias/F4-E2/): registro, sondas y capturas por estado | Capturas conformes antes, durante y después, con la sonda visible. Requiere autorización. Conservar la observación de los dos tiempos de espera. |
| E3 | Autorreparación (eliminar contenedor) | Servicio antes/después | [F4-E3](../evidencias/F4-E3/): registro, sondas y capturas antes y después | Capturas conformes, con la sonda visible. Requiere autorización. |
| E5 | Reincorporación y reequilibrio; reinicio lab | Nodos y servicio | [Verificación final](../evidencias/E5-verificacion-final.txt), [previa](../evidencias/E5-verificacion-previa.txt), [preparación](../evidencias/E5-preparacion.txt), [CT/estado-final](../evidencias/capturas-terminal/estado-final.png) | Captura conforme de nodos y servicio tras el próximo inicio del laboratorio, y vista de EC2. |
| E6 | Mantenimiento (modo drain) | Nodos y servicio | [F4-E6](../evidencias/F4-E6/): registro, sondas y capturas antes, durante y después | Capturas conformes, con la sonda visible. Requiere autorización. |
| E7 | Actualización (1.0 a 2.0) sin corte y rollback | Script y navegador | [F3-actualizacion](../evidencias/F3-actualizacion/): registro, sondas y capturas, [CT/E7-historial-versiones](../evidencias/capturas-terminal/E7-historial-versiones.png) | Capturas conformes durante la actualización y el rollback, con la sonda y el navegador. Requiere autorización. |

## Parciales

| Cód. | Qué pide la Rúbrica | Evidencia exigida | Nuestra evidencia | Qué falta |
| --- | --- | --- | --- | --- |
| A6 | Pruebas clave: validación, plan, cambio, destrucción | Secuencia capturas | [Plan final](../evidencias/A6-plan-final.txt), [apply del cambio](../evidencias/A6-apply.txt), [CT/A6-sin-cambios](../evidencias/capturas-terminal/A6-sin-cambios.png), [plan](../evidencias/prototipo/reto4-plan-cidr.log) y [apply](../evidencias/prototipo/reto4-apply.log) iniciales | Destrucción real, con autorización aparte y tras aclararlo con el profesor. Secuencia completa en capturas. |
| B1 | Clave propia en 4 nodos; vockey sustituida | Repositorio; authorized_keys | [CT/B1-claves-autorizadas](../evidencias/capturas-terminal/B1-claves-autorizadas.png) | Clave de cada integrante, en `/terraform` e instalada. Aclarar `vockey`: la Guía la deja de reserva y la Rúbrica la sustituye. |
| B2 | Archivo config SSH con nombre corto | /config; conexión | [Captura conforme](../evidencias/capturas-conformes/B2-plantilla.png), [CT/B2-alias](../evidencias/capturas-terminal/B2-alias.png) | Comprobar la conexión real con el nombre corto cuando el laboratorio esté activo, y capturarla. |
| C3 | 4 nodos activos, manager líder, 3 workers unidos | Listado de nodos | [CT/C3-nodos](../evidencias/capturas-terminal/C3-nodos.png), [topología inicial](../evidencias/prototipo/fase2-3.txt) | Hoy hay tres managers y el líder es worker1-g5. Ver el [plan](../entrega/PLAN-C3-E4-E8.md), que requiere autorización. |
| E4 | Alta disponibilidad (caída worker) | Nodo caído; script OK | [Registro](../evidencias/E4-E5-E8-registro.txt), [sonda](../evidencias/prototipo/E4-E5-http.txt), [captura](../evidencias/E4-web-worker-down.png) | Repetir con la web definitiva y capturas conformes: ver el [plan](../entrega/PLAN-C3-E4-E8.md). También es la demostración obligatoria de la exposición. |
| E8 | Alta disp. managers (nuevo líder) | Listado desde otro | [Registro](../evidencias/E8-eleccion-registro.txt), [quórum previo](../evidencias/prototipo/E8-quorum-previo.txt), [captura durante](../evidencias/E8-web-parada.png), [captura después](../evidencias/E8-web-recuperado.png), [comprobación posterior](../evidencias/verificacion-posterior.txt) | Repetir con la web definitiva y capturas desde otro manager durante la parada: ver el [plan](../entrega/PLAN-C3-E4-E8.md). |
| F1 | Privado, todos colaboradores, profesor invitado | Settings | [Captura conforme](../evidencias/capturas-conformes/F1-repositorio.png), [CT/F1-colaboradores](../evidencias/capturas-terminal/F1-colaboradores.png) | Confirmar integrantes e invitar al profesor antes de la fecha límite. Captura de Settings → Collaborators. Ya está la de terminal. |
| F2 | Commits repartidos y uso de Pull Requests por colaboradores | Historial y PRs | [Captura conforme](../evidencias/capturas-conformes/F2-historial.png), [CT/F2-historial](../evidencias/capturas-terminal/F2-historial.png) | Commits y PR reales de cada integrante. Vista web de la PR. Ya está la captura del historial. |
| F9 | proyecto.md: Informe extenso Fases 0-5 paso a paso | proyecto.md | [Informe técnico](../PROYECTO.md), [estructura del Word](../entrega/INFORME-F9-estructura.md) | Integrar las capturas conformes que faltan, con su comentario. **El Word no es necesario.** |
| F10 | Capturas de evidencias (Fases 0-5) con normativa y comentadas | proyecto.md | Este índice | Hay 11 capturas conformes de 50, más las 6 con sesión de una persona. El resto requiere laboratorio activo, SSH y, para las pruebas, autorización. |
| F11 | Reparto tareas y reflexión | gestion.md | [GESTION (borrador)](../GESTION.md) | El grupo debe completar reparto, responsables y reflexión. Trello y el seguimiento semanal no se exigen. |

## Pendientes

| Cód. | Qué pide la Rúbrica | Evidencia exigida | Material disponible | Qué falta |
| --- | --- | --- | --- | --- |
| F13 | Documentación práctica individual | /practica-individual | [Estructura sin contenido](../practica-individual/README.md) | Cada integrante debe aportar la documentación de su práctica individual previa de EC2. |
| G1 | Exposición (10 min): demo, arquitectura, código | Día exposición | [Guion](../entrega/DEFENSA.md), [presentación](../entrega/presentacion-cloud-g5.pptx) | Asignar partes, ensayar y hacer la exposición, con caída de un nodo en directo. |
| G2 | Preguntas individuales a cualquier miembro | Día exposición | [Preguntas de repaso](../entrega/DEFENSA.md#preguntas-del-profesor) | Cada integrante debe prepararla: 2 o 3 preguntas sobre cualquier parte. |
| G3 | Demostración técnica individual | Día exposición | [Demostraciones](../entrega/DEFENSA.md#demostraciones) | Cada integrante debe hacerla en directo. Requiere laboratorio activo y acceso SSH. |

## Antes de entregar

### Decisiones

- [ ] Profesor consultado: `vockey`, topología final, destrucción de A6, autoría de las capturas y fecha de entrega.
- [ ] [Plan de C3, E4 y E8](PLAN-C3-E4-E8.md) revisado y autorizado.

### Técnica

- [ ] Laboratorio activo, credenciales renovadas y regla SSH limitada a la IP actual `/32`.
- [ ] `bash scripts/comprobar-laboratorio.sh` sin nada que corregir.
- [ ] `ssh manager-g5` funciona solo con el nombre corto.
- [ ] Un plan de Terraform confirma que las variables de disco no proponen cambios.
- [ ] Claves públicas de cada integrante en `/terraform` e instaladas.
- [ ] C3 corregido, y E4 y E8 repetidos con la web definitiva.
- [ ] E2, E3, E6 y E7 repetidos con capturas conformes, si se autoriza.

### Documentación

- [ ] Capturas de los grupos «laboratorio» y «prueba» generadas e integradas en `PROYECTO.md`.
- [ ] [Capturas con sesión](../REVISION.md#capturas-que-faltan) añadidas, sin el ID de la cuenta de AWS.
- [ ] [GESTION.md](../GESTION.md) con reparto, responsables y reflexión reales.
- [ ] Práctica individual previa en [`practica-individual/`](../practica-individual/README.md).
- [ ] Nombres y reparto en la [presentación](presentacion-cloud-g5.pptx).

### Repositorio

- [ ] Commits y PR de cada integrante.
- [ ] Profesor invitado antes de la fecha límite.
- [ ] `python3 scripts/revisar-secretos.py origin/main HEAD` sin coincidencias.
- [ ] `python3 scripts/validar-entrega.py` sin errores.
- [ ] PR revisada e integrada en `main`, que hoy solo contiene `.devcontainer`, `.gitignore`, `README.md` y `terraform`.

### Defensa

- [ ] Papeles A–D asignados y [guion](DEFENSA.md) ensayado en 10 minutos.
- [ ] Caída de un nodo ensayada, con el plan B a mano.
- [ ] Guion y diagrama actualizados si cambia la topología.
- [ ] Cada integrante puede responder las [preguntas de repaso](DEFENSA.md#preguntas-del-profesor) y hacer su demostración.
