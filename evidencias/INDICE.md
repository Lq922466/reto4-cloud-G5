# Índice de evidencias por criterio

Organiza las evidencias del repositorio con los mismos criterios que [REVISION.md](../REVISION.md).
Situación a 5 de noviembre de 2026. Último estado técnico comprobado: 09:56 UTC. [Auditoría](auditoria/INFORME.md).

**Contexto de cada evidencia**

- **Definitiva:** web F1 final, desplegada el 5 de noviembre.
- **Provisional:** portal provisional, 4 de noviembre, con IP públicas que ya han cambiado.
- **Entorno:** no depende de la web servida.

**Tipos.** Registro: salida de comandos en texto. Terminal: captura de xterm con comandos reales.
Navegador: captura de la web. Las capturas de Chromium sin interfaz no muestran la dirección; las
de D3 sí. **Solo las de [capturas-conformes/](capturas-conformes/INDICE.md) muestran el prompt que exige la Guía.** Autores: Codex el 4 de noviembre y Claude Code el 5 de noviembre.

`CT/` es [capturas-terminal/](capturas-terminal/INDICE.md). Cada imagen de esa carpeta tiene un
`.txt` con la misma salida.

## Fase 0 · Repositorio y entorno

| Criterio | Estado | Evidencia | Falta |
| --- | --- | --- | --- |
| F1 | Parcial | [Captura conforme](capturas-conformes/F1-repositorio.png), [CT/F1-colaboradores](capturas-terminal/F1-colaboradores.png) | Confirmar integrantes e invitar al profesor antes de la fecha límite. Captura de Settings → Collaborators. Ya está la de terminal. |
| F2 | Parcial | [Captura conforme](capturas-conformes/F2-historial.png), [CT/F2-historial](capturas-terminal/F2-historial.png) | Commits y PR reales de cada integrante. Vista web de la PR. Ya está la captura del historial. |
| F3 | Listo | [README](../README.md), [etiquetas en Docker Hub](D1-dockerhub-etiquetas.png) | Nada. |
| F4 | Listo | [Captura conforme](capturas-conformes/F4-estructura.png), [CT/F4-estructura](capturas-terminal/F4-estructura.png) | Integrar la PR: `main` solo contiene `.devcontainer`, `.gitignore`, `README.md` y `terraform`. |
| F5 | Listo | [Captura conforme](capturas-conformes/F5-entorno.png), [CT/F5-entorno](capturas-terminal/F5-entorno.png), [registro técnico](revision-registro-tecnico.txt) | Nada imprescindible. Una vista del Codespace en el navegador sería un apoyo. |
| F6 | Listo | [Captura conforme](capturas-conformes/F6-codigo.png), [CT/A1-modulo-terraform](capturas-terminal/A1-modulo-terraform.png), [CT/F6-codigo-instancias](capturas-terminal/F6-codigo-instancias.png), [apply inicial](prototipo/reto4-apply.log) | Nada. Comprobar con un plan cuando el laboratorio esté activo. |
| F7 | Listo | [Captura conforme](capturas-conformes/F7-scripts.png), [CT/F7-scripts](capturas-terminal/F7-scripts.png) | Nada. Si cambian los scripts, mantener los comentarios. |
| F8 | Listo | [Diagrama](../diagramas/arquitectura.md), [renderizado](../diagramas/arquitectura.png) | Nada. Si cambia la topología, actualizar el diagrama. |
| F9 | Parcial | [Informe técnico](../PROYECTO.md), [estructura del Word](../entrega/INFORME-F9-estructura.md) | Integrar las capturas conformes que faltan, con su comentario. **El Word no es necesario.** |
| F10 | Parcial | Este índice | Hay 11 capturas conformes de 50, más las 6 con sesión de una persona. El resto requiere laboratorio activo, SSH y, para las pruebas, autorización. |
| F11 | Parcial | [GESTION (borrador)](../GESTION.md) | El grupo debe completar reparto, responsables y reflexión. Trello y el seguimiento semanal no se exigen. |
| F12 | Listo | [Captura conforme](capturas-conformes/F12-seguridad.png), [Revisión de todo el historial](auditoria/registro-repositorio.txt), [CT/F12-archivos-sensibles](capturas-terminal/F12-archivos-sensibles.png) | Repetir con `scripts/revisar-secretos.py` antes de integrar la PR. |
| F13 | Pendiente | [Estructura sin contenido](../practica-individual/README.md) | Cada integrante debe aportar la documentación de su práctica individual previa de EC2. |

## Fase 1 · Infraestructura

| Criterio | Estado | Evidencia | Falta |
| --- | --- | --- | --- |
| A1 | Listo | [Captura conforme](capturas-conformes/A1-modulo.png), [CT/A1-modulo-terraform](capturas-terminal/A1-modulo-terraform.png) | Comprobar con un plan que las variables de disco no proponen cambios, cuando el laboratorio esté activo. |
| A2 | Demostrado, falta captura conforme | [CT/A2-instancias](capturas-terminal/A2-instancias.png) | Captura de la consola de EC2 con la norma de capturas. |
| A3 | Demostrado, falta captura conforme | [CT/A3-grupo-seguridad](capturas-terminal/A3-grupo-seguridad.png) | Captura de reglas en la consola. El puerto 8080 lo exige la Guía. |
| A4 | Demostrado, falta captura conforme | [Captura conforme](capturas-conformes/A4-script.png), [CT/A4-arranque](capturas-terminal/A4-arranque.png), [registro de arranque](prototipo/manager-g5.txt) | Captura conforme del log de arranque en los nodos. Ya está la del script. |
| A5 | Demostrado, falta captura conforme | [CT/A5-salida-nodes](capturas-terminal/A5-salida-nodes.png) | Rehacer la captura con prompt y comentario. |
| A6 | Parcial | [Plan final](A6-plan-final.txt), [apply del cambio](A6-apply.txt), [CT/A6-sin-cambios](capturas-terminal/A6-sin-cambios.png), [plan](prototipo/reto4-plan-cidr.log) y [apply](prototipo/reto4-apply.log) iniciales | Destrucción real, con autorización aparte y tras aclararlo con el profesor. Secuencia completa en capturas. |

## Fase 2 · SSH

| Criterio | Estado | Evidencia | Falta |
| --- | --- | --- | --- |
| B1 | Parcial | [CT/B1-claves-autorizadas](capturas-terminal/B1-claves-autorizadas.png) | Clave de cada integrante, en `/terraform` e instalada. Aclarar `vockey`: la Guía la deja de reserva y la Rúbrica la sustituye. |
| B2 | Parcial | [Captura conforme](capturas-conformes/B2-plantilla.png), [CT/B2-alias](capturas-terminal/B2-alias.png) | Comprobar la conexión real con el nombre corto cuando el laboratorio esté activo, y capturarla. |
| B3 | Demostrado, falta captura conforme | [CT/B3-simultaneo-sudo](capturas-terminal/B3-simultaneo-sudo.png), [CT/B3-copia-scp](capturas-terminal/B3-copia-scp.png) | Rehacer las capturas con prompt y comentario. |
| B4 | Demostrado, falta captura conforme | [CT/B4-endurecimiento](capturas-terminal/B4-endurecimiento.png) | Rehacer la captura con prompt y comentario. |
| B5 | Demostrado, falta captura conforme | [CT/B5-salto](capturas-terminal/B5-salto.png) | Rehacer la captura con prompt y comentario. |

## Fase 3 · Docker Swarm

| Criterio | Estado | Evidencia | Falta |
| --- | --- | --- | --- |
| C1 | Demostrado, falta captura conforme | [CT/C1-docker-ping](capturas-terminal/C1-docker-ping.png) | Rehacer la captura con prompt y comentario. |
| C2 | Demostrado, falta captura conforme | [CT/C2-red-ingress](capturas-terminal/C2-red-ingress.png), [registro inicial](prototipo/fase2-3.txt) | Rehacer la captura con prompt y comentario. |
| C3 | Parcial | [CT/C3-nodos](capturas-terminal/C3-nodos.png), [topología inicial](prototipo/fase2-3.txt) | Hoy hay tres managers y el líder es worker1-g5. Ver el [plan](../entrega/PLAN-C3-E4-E8.md), que requiere autorización. |
| C4 | Demostrado, falta captura conforme | [CT/C4-red-aplicacion](capturas-terminal/C4-red-aplicacion.png) | Rehacer la captura con prompt y comentario. |

## Fase 4 · Web e imágenes (definitiva)

| Criterio | Estado | Evidencia | Falta |
| --- | --- | --- | --- |
| D1 | Listo | [Captura conforme](capturas-conformes/D1-dockerhub.png), [Construcción](D1-imagenes-definitivas.txt), [navegador](D1-navegador-registro.txt), [publicación](D1-publicacion-dockerhub.txt), [descarga](D1-descarga-dockerhub.txt), [etiquetas](D1-dockerhub-etiquetas.png), [CT/D1-imagenes](capturas-terminal/D1-imagenes.png) | Nada. Mostrar Docker Hub en la defensa. |
| D2 | Listo | [Despliegue](F3-despliegue/registro.txt), [estado](F3-estado-final.txt), [CT/D2-pila-servicio](capturas-terminal/D2-pila-servicio.png) | Nada. |
| D3 | Demostrado, falta captura conforme | [manager-g5](D3-navegador-manager-g5.png), [worker1-g5](D3-navegador-worker1-g5.png), [worker2-g5](D3-navegador-worker2-g5.png), [worker3-g5](D3-navegador-worker3-g5.png), [método](D3-registro.txt), [portada completa](F3-web-final-1.0-completa.png) | Comentario en cada captura, y rehacerlas con las IP del día. |

## Fase 5 · Orquestación

| Criterio | Contexto | Estado | Evidencia | Falta |
| --- | --- | --- | --- | --- |
| E1 | Definitiva | Demostrado, falta captura conforme | [CT/E1-reparto-peticiones](capturas-terminal/E1-reparto-peticiones.png), [estado](F3-estado-final.txt) | Rehacer la captura con prompt y comentario. |
| E2 | Definitiva | Demostrado, falta captura conforme | [F4-E2](F4-E2/): registro, sondas y capturas por estado | Capturas conformes antes, durante y después, con la sonda visible. Requiere autorización. Conservar la observación de los dos tiempos de espera. |
| E3 | Definitiva | Demostrado, falta captura conforme | [F4-E3](F4-E3/): registro, sondas y capturas antes y después | Capturas conformes, con la sonda visible. Requiere autorización. |
| E4 | Provisional | Parcial | [Registro](E4-E5-E8-registro.txt), [sonda](prototipo/E4-E5-http.txt), [captura](E4-web-worker-down.png) | Repetir con la web definitiva y capturas conformes: ver el [plan](../entrega/PLAN-C3-E4-E8.md). También es la demostración obligatoria de la exposición. |
| E5 | Entorno | Demostrado, falta captura conforme | [Verificación final](E5-verificacion-final.txt), [previa](E5-verificacion-previa.txt), [preparación](E5-preparacion.txt), [CT/estado-final](capturas-terminal/estado-final.png) | Captura conforme de nodos y servicio tras el próximo inicio del laboratorio, y vista de EC2. |
| E6 | Definitiva | Demostrado, falta captura conforme | [F4-E6](F4-E6/): registro, sondas y capturas antes, durante y después | Capturas conformes, con la sonda visible. Requiere autorización. |
| E7 | Definitiva | Demostrado, falta captura conforme | [F3-actualizacion](F3-actualizacion/): registro, sondas y capturas, [CT/E7-historial-versiones](capturas-terminal/E7-historial-versiones.png) | Capturas conformes durante la actualización y el rollback, con la sonda y el navegador. Requiere autorización. |
| E8 | Provisional | Parcial | [Registro](E8-eleccion-registro.txt), [quórum previo](prototipo/E8-quorum-previo.txt), [captura durante](E8-web-parada.png), [captura después](E8-web-recuperado.png), [comprobación posterior](verificacion-posterior.txt) | Repetir con la web definitiva y capturas desde otro manager durante la parada: ver el [plan](../entrega/PLAN-C3-E4-E8.md). |

**Límite de las sondas.** Toman una muestra por segundo y por IP, y no acreditan disponibilidad
continua. En E2 se registraron dos tiempos de espera aislados durante la reducción de 12 a 2 réplicas.
En E8 hubo 34 segundos sin muestras entre los dos tramos de sondeo.

## Exposición y defensa

| Criterio | Estado | Evidencia | Falta |
| --- | --- | --- | --- |
| G1 | Pendiente | [Guion](../entrega/DEFENSA.md), [presentación](../entrega/presentacion-cloud-g5.pptx) | Asignar partes, ensayar y hacer la exposición, con caída de un nodo en directo. |
| G2 | Pendiente | [Preguntas de repaso](../entrega/DEFENSA.md#preguntas-del-profesor) | Cada integrante debe prepararla: 2 o 3 preguntas sobre cualquier parte. |
| G3 | Pendiente | [Demostraciones](../entrega/DEFENSA.md#demostraciones) | Cada integrante debe hacerla en directo. Requiere laboratorio activo y acceso SSH. |

## Auditoría

| Documento | Contenido |
| --- | --- |
| [Informe de la auditoría](auditoria/INFORME.md) | Reglas, MTU, SSH, Swarm, imágenes, redes y repositorio |
| [Revisión de E4 y E8](auditoria/E4-E8.md) | Qué demuestran y qué no |
| [Intento en vivo](auditoria/registro-acceso-en-vivo.txt) | Denegación de AWS y web sin respuesta, 11:13 UTC |
| [Terraform](auditoria/registro-terraform.txt) y [repositorio](auditoria/registro-repositorio.txt) | Salidas de las comprobaciones |

## Evidencias que no deben presentarse como resultado final

Son reales y se conservan como registro, pero no acreditan el estado final.

| Archivo | Qué es | Sustituida por |
| --- | --- | --- |
| [A6-plan-previo](A6-plan-previo.txt), [A6-plan-actual](A6-plan-actual.txt) | Planes de A6 anteriores al definitivo | [A6-plan-final](A6-plan-final.txt) y [A6-apply](A6-apply.txt) |
| [E5-verificacion-posterior](E5-verificacion-posterior.txt) | Verificación de E5 interrumpida por una denegación de AWS | [E5-verificacion-final](E5-verificacion-final.txt) |
| [E5-web-recuperado](E5-web-recuperado.png) | Portal tras reincorporar un worker en E4, no tras reiniciar Learner Lab | [CT/estado-final](capturas-terminal/estado-final.png) |
| [D1-publicacion-intento-fallido](D1-publicacion-intento-fallido.txt) | Primer intento rechazado por Docker Hub. Útil para Incidencias | [D1-publicacion-dockerhub](D1-publicacion-dockerhub.txt) |
| [D1-navegador 1.0](D1-navegador-1.0.png) y [2.0](D1-navegador-2.0.png), [F1-candidata-local](F1-candidata-local.png) | Web en contenedores temporales o en local, sin desplegar | [Capturas D3](D3-registro.txt) |
| [E4-web-worker-down](E4-web-worker-down.png), [E8-web-parada](E8-web-parada.png), [E8-web-recuperado](E8-web-recuperado.png) | Portal provisional, sin IP, hora ni estado del clúster. No prueban por sí solas el momento de la captura | Registros de [E4](E4-E5-E8-registro.txt) y [E8](E8-eleccion-registro.txt) |
| [F4C 1](F4C-nodo-1.png), [2](F4C-nodo-2.png), [3](F4C-nodo-3.png), [4](F4C-nodo-4.png), posterior-web de [manager](posterior-web-manager-g5.png), [worker 1](posterior-web-worker1-g5.png), [worker 2](posterior-web-worker2-g5.png) y [worker 3](posterior-web-worker3-g5.png) | Portal provisional, con IP antiguas | [Capturas D3](D3-registro.txt) |

## Registros originales del 4 de noviembre

[prototipo/](prototipo/) conserva sin cambios los registros detallados de las pruebas con el portal
provisional y del plan y apply iniciales. Antes solo existían en un worktree del Codespace.

| Prueba | Registro |
| --- | --- |
| Fases 2 y 3 | [fase2-3](prototipo/fase2-3.txt), [manager-g5](prototipo/manager-g5.txt), [worker1-g5](prototipo/worker1-g5.txt), [worker2-g5](prototipo/worker2-g5.txt), [worker3-g5](prototipo/worker3-g5.txt) |
| E1, E2, E3, E6 y E7 | [fase4-5](prototipo/fase4-5.txt), [sonda: 156 correctas](prototipo/sondeo-orquestacion.txt) |
| E4 y reincorporación | [E4-worker-down](prototipo/E4-worker-down.txt), [E4-E5](prototipo/E4-E5.txt), [sonda: 164 correctas](prototipo/E4-E5-http.txt), [E5-worker-recuperado](prototipo/E5-worker-recuperado.txt), [E5-reparto](prototipo/E5-reparto.txt) |
| E8 | [E8-eleccion](prototipo/E8-eleccion.txt), [sonda: 38 correctas](prototipo/E8-http.txt), [E8-recuperacion](prototipo/E8-recuperacion.txt), [sonda: 130 correctas](prototipo/E8-http-recuperacion.txt) |
| Terraform inicial | [plan](prototipo/reto4-plan.log), [plan con CIDR](prototipo/reto4-plan-cidr.log), [apply](prototipo/reto4-apply.log) |
