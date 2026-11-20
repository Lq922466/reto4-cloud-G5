# Índice de evidencias por criterio

Organiza las evidencias del repositorio con los mismos criterios y estados que [REVISION.md](../REVISION.md). Revisado el 18 de
noviembre de 2026. Último estado técnico registrado: 9 de noviembre (Swarm, SSH y web) y 10 de noviembre (Terraform).

**Contexto de cada evidencia**

- **Definitiva:** web F1 final, desplegada el 5 de noviembre.
- **Provisional:** portal provisional, 4 de noviembre, con IP públicas que ya han cambiado.
- **Entorno:** no depende de la web servida.

**Tipos.** Registro: salida de comandos en texto. Terminal: captura de xterm con comandos reales.
Navegador: captura de la web. Las capturas de Chromium sin interfaz no muestran la dirección; las
de D3 sí. **Solo las de [capturas-conformes/](capturas-conformes/INDICE.md) muestran el prompt que exige la Guía.** Autores: Codex el 4 de noviembre; Claude Code, por encargo de Cristina, del 5 al 18 de noviembre; y cada integrante en [capturas-integrantes/](capturas-integrantes/INDICE.md).

`CT/` es [capturas-terminal/](capturas-terminal/INDICE.md). Cada imagen de esa carpeta tiene un
`.txt` con la misma salida.

## Fase 0 · Repositorio y entorno

| Criterio | Estado | Evidencia | Falta |
| --- | --- | --- | --- |
| F1 | Demostrado, falta captura conforme | [Captura conforme](capturas-conformes/F1-repositorio.png) del 18 de noviembre, con el profesor (jc-csl) como colaborador, [CT/F1-colaboradores](capturas-terminal/F1-colaboradores.png) | Captura de Settings → Collaborators en el navegador. |
| F2 | Parcial | [Captura conforme](capturas-conformes/F2-historial.png) del 5 de noviembre, [CT/F2-historial](capturas-terminal/F2-historial.png) | Commits y PR propios de Alexandra e Ibai, y de Enrique desde un terminal. Las PR #3–#5 se abrieron desde la cuenta de Cristina con borradores de Codex. Captura del historial de `main` y de las PR. |
| F3 | Listo | [README](../README.md), [etiquetas en Docker Hub](D1-dockerhub-etiquetas.png) | Nada. |
| F4 | Listo | [Captura conforme](capturas-conformes/F4-estructura.png), [CT/F4-estructura](capturas-terminal/F4-estructura.png) | Nada. Desde el 18 de noviembre, la estructura está en `main`. |
| F5 | Listo | [Captura conforme](capturas-conformes/F5-entorno.png), [CT/F5-entorno](capturas-terminal/F5-entorno.png), [registro técnico](revision-registro-tecnico.txt) | Nada imprescindible. Una vista del Codespace en el navegador sería un apoyo. |
| F6 | Listo | [Captura conforme](capturas-conformes/F6-codigo.png), [CT/A1-modulo-terraform](capturas-terminal/A1-modulo-terraform.png), [CT/F6-codigo-instancias](capturas-terminal/F6-codigo-instancias.png), [apply inicial](prototipo/reto4-apply.log) | Fijar la imagen de Ubuntu antes del siguiente `apply`: el plan del 10 de noviembre propone sustituir las instancias. |
| F7 | Listo | [Captura conforme](capturas-conformes/F7-scripts.png), [CT/F7-scripts](capturas-terminal/F7-scripts.png) | Nada. Si cambian los scripts, mantener los comentarios. |
| F8 | Listo | [Diagrama](../diagramas/arquitectura.md), [renderizado](../diagramas/arquitectura.png) | Nada. Actualizado el 18 de noviembre a un manager líder y tres workers. |
| F9 | Listo | [Informe técnico](../PROYECTO.md), [estructura del Word, opcional](../entrega/INFORME-F9-estructura.md) | Nada. Las capturas que faltan se cuentan en F10. **El Word no es necesario.** |
| F10 | Parcial | [Capturas conformes](capturas-conformes/INDICE.md), integradas en el informe | Hay 32 capturas conformes de los días 5, 6, 9 y 18 de noviembre. Faltan las de las pruebas con sonda, D3, C3 actual y las de la consola de AWS. |
| F11 | Parcial | [GESTION (borrador)](../GESTION.md) | Recoge la organización acordada y separa lo asignado de lo realizado. Falta el trabajo real de cada integrante, sus seguimientos y la reflexión. |
| F12 | Listo | [Captura conforme](capturas-conformes/F12-seguridad.png) del 18 de noviembre, [revisión de todo el historial](auditoria/registro-repositorio.txt), [CT/F12-archivos-sensibles](capturas-terminal/F12-archivos-sensibles.png) | Repetir `revisar-secretos.py 6f3d838 HEAD` antes de cada integración. |
| F13 | Documentado por confirmación; sin capturas originales | [Explicación de la práctica presencial sin capturas](../practica-individual/README.md) | La coordinadora confirma la práctica presencial; faltan las evidencias individuales originales. |

## Fase 1 · Infraestructura

| Criterio | Estado | Evidencia | Falta |
| --- | --- | --- | --- |
| A1 | Listo | [Captura conforme](capturas-conformes/A1-modulo.png), [CT/A1-modulo-terraform](capturas-terminal/A1-modulo-terraform.png) | Fijar la imagen de Ubuntu antes de cualquier `apply` (incidencia I1.4 de `PROYECTO.md`). |
| A2 | Demostrado, falta captura conforme | [Captura conforme](capturas-conformes/A2-instancias.png), [CT/A2-instancias](capturas-terminal/A2-instancias.png) | Captura de la consola de EC2 con la norma de capturas. |
| A3 | Demostrado, falta captura conforme | [Captura conforme](capturas-conformes/A3-reglas.png), [CT/A3-grupo-seguridad](capturas-terminal/A3-grupo-seguridad.png) | Captura de reglas en la consola. Retirar la regla temporal `88.14.93.201/32` al terminar B1. |
| A4 | Listo | [Script](capturas-conformes/A4-script.png) y [arranque](capturas-conformes/A4-arranque.png) en capturas conformes, [CT/A4-arranque](capturas-terminal/A4-arranque.png), [registro de arranque](prototipo/manager-g5.txt) | Nada. |
| A5 | Listo | [Captura conforme](capturas-conformes/A5-salidas.png), [CT/A5-salida-nodes](capturas-terminal/A5-salida-nodes.png) | Versionar un extracto del `refresh-only` del 10 de noviembre, sin datos de la cuenta. |
| A6 | Parcial | [Plan final](A6-plan-final.txt), [apply del cambio](A6-apply.txt), [plan posterior: NO CORRECTO](capturas-conformes/A6-sin-cambios.png), [CT/A6-sin-cambios](capturas-terminal/A6-sin-cambios.png), [plan](prototipo/reto4-plan-cidr.log) y [apply](prototipo/reto4-apply.log) iniciales | Fijar la AMI y obtener `No changes`; destrucción real, con autorización aparte y tras aclararlo con el profesor; secuencia completa en capturas. |

## Fase 2 · SSH

| Criterio | Estado | Evidencia | Falta |
| --- | --- | --- | --- |
| B1 | Parcial | [Captura conforme](capturas-conformes/B1-clave-nodos.png), [registro de manager-g5](capturas-conformes/B1-registro-manager.png), accesos de [Enrique](capturas-integrantes/B1-acceso-enrique.png), [Alexandra](capturas-integrantes/B1-acceso-alexandra.png) e [Ibai](capturas-integrantes/B1-acceso-ibai.png) a manager-g5, accesos de Cristina a [manager-g5](capturas-integrantes/B1-acceso-cristina-manager.png), [worker1-g5](capturas-integrantes/B1-acceso-cristina-worker1.png), [worker2-g5](capturas-integrantes/B1-acceso-cristina-worker2.png) y [worker3-g5](capturas-integrantes/B1-acceso-cristina-worker3.png), su [alias](capturas-integrantes/B1-cristina-config-alias.png) y su [config](capturas-integrantes/B1-cristina-config-ruta.png), [registro de Cristina en los cuatro nodos](capturas-conformes/B1-registro-cristina.png), [registro de la instalación](auditoria/registro-2026-11-09-b1.txt), [claves del 6 de noviembre](capturas-conformes/B1-claves.png), [CT/B1-claves-autorizadas](capturas-terminal/B1-claves-autorizadas.png) | Las cuatro claves públicas están en `terraform/claves/` y en los cuatro nodos desde el 9 de noviembre. Falta que Enrique, Alexandra e Ibai entren en los tres workers, con capturas con el comentario de la norma; la captura `B1-repositorio`; retirar la regla temporal `88.14.93.201/32`; y aclarar `vockey`: la Guía la deja de reserva y la Rúbrica la sustituye. |
| B2 | Listo | [Plantilla](capturas-conformes/B2-plantilla.png) y [conexión](capturas-conformes/B2-conexion.png) en capturas conformes, [CT/B2-alias](capturas-terminal/B2-alias.png) | Regenerar los alias tras cada reinicio del laboratorio. |
| B3 | Listo | [Órdenes simultáneas](capturas-conformes/B3-simultaneo.png) y [copia](capturas-conformes/B3-copia.png) en capturas conformes, [CT/B3-simultaneo-sudo](capturas-terminal/B3-simultaneo-sudo.png), [CT/B3-copia-scp](capturas-terminal/B3-copia-scp.png) | Nada. |
| B4 | Listo | [Captura conforme](capturas-conformes/B4-endurecimiento.png), [CT/B4-endurecimiento](capturas-terminal/B4-endurecimiento.png) | Nada. |
| B5 | Listo | [Captura conforme](capturas-conformes/B5-salto.png), [CT/B5-salto](capturas-terminal/B5-salto.png) | Nada. |

## Fase 3 · Docker Swarm

| Criterio | Estado | Evidencia | Falta |
| --- | --- | --- | --- |
| C1 | Listo | [Captura conforme](capturas-conformes/C1-ping.png), [CT/C1-docker-ping](capturas-terminal/C1-docker-ping.png) | Nada. |
| C2 | Listo | [Captura conforme](capturas-conformes/C2-cluster.png), [CT/C2-red-ingress](capturas-terminal/C2-red-ingress.png), [registro inicial](prototipo/fase2-3.txt) | Nada. |
| C3 | Demostrado, falta captura conforme | [Captura conforme del 6 de noviembre: NO CORRECTO](capturas-conformes/C3-nodos.png), [CT/C3-nodos](capturas-terminal/C3-nodos.png), [topología inicial](prototipo/fase2-3.txt) | El 9 de noviembre Codex bajó los dos managers temporales y manager-g5 quedó como único líder, con tres workers. Solo consta en su registro de sesión. Con el laboratorio activo, comprobarlo y repetir `C3-nodos`. |
| C4 | Listo | [Captura conforme](capturas-conformes/C4-red.png), [CT/C4-red-aplicacion](capturas-terminal/C4-red-aplicacion.png) | Nada. |

## Fase 4 · Web e imágenes (definitiva)

| Criterio | Estado | Evidencia | Falta |
| --- | --- | --- | --- |
| D1 | Listo | [Captura conforme](capturas-conformes/D1-dockerhub.png), [Construcción](D1-imagenes-definitivas.txt), [navegador](D1-navegador-registro.txt), [publicación](D1-publicacion-dockerhub.txt), [descarga](D1-descarga-dockerhub.txt), [etiquetas](D1-dockerhub-etiquetas.png), [CT/D1-imagenes](capturas-terminal/D1-imagenes.png) | Nada. Mostrar Docker Hub en la defensa. |
| D2 | Listo | [Despliegue](F3-despliegue/registro.txt), [estado](F3-estado-final.txt), [CT/D2-pila-servicio](capturas-terminal/D2-pila-servicio.png) | Nada. |
| D3 | Demostrado, falta captura conforme | [manager-g5](D3-navegador-manager-g5.png), [worker1-g5](D3-navegador-worker1-g5.png), [worker2-g5](D3-navegador-worker2-g5.png), [worker3-g5](D3-navegador-worker3-g5.png), [método](D3-registro.txt), [portada completa](F3-web-final-1.0-completa.png) | Comentario en cada captura, y rehacerlas con las IP del día. |

## Fase 5 · Orquestación

| Criterio | Contexto | Estado | Evidencia | Falta |
| --- | --- | --- | --- | --- |
| E1 | Definitiva | Listo | [Captura conforme](capturas-conformes/E1-balanceo.png), [CT/E1-reparto-peticiones](capturas-terminal/E1-reparto-peticiones.png), [estado](F3-estado-final.txt) | Nada. |
| E2 | Definitiva | Demostrado, falta captura conforme | [F4-E2](F4-E2/): registro, sondas y capturas por estado | Capturas conformes antes, durante y después, con la sonda visible. Requiere autorización. Conservar la observación de los dos tiempos de espera. |
| E3 | Definitiva | Demostrado, falta captura conforme | [F4-E3](F4-E3/): registro, sondas y capturas antes y después | Capturas conformes, con la sonda visible. Requiere autorización. |
| E4 | Provisional | Parcial | [Registro](E4-E5-E8-registro.txt), [sonda](prototipo/E4-E5-http.txt), [captura](E4-web-worker-down.png) | Repetir con la web definitiva y capturas conformes: ver el [plan](../entrega/PLAN-C3-E4-E8.md). También es la demostración obligatoria de la exposición. |
| E5 | Entorno | Listo | [Captura conforme](capturas-conformes/E5-estado.png), [verificación final](E5-verificacion-final.txt), [previa](E5-verificacion-previa.txt), [preparación](E5-preparacion.txt), [CT/estado-final](capturas-terminal/estado-final.png) | Comprobar el clúster tras el reinicio del 10 de noviembre. |
| E6 | Definitiva | Demostrado, falta captura conforme | [F4-E6](F4-E6/): registro, sondas y capturas antes, durante y después | Capturas conformes, con la sonda visible. Requiere autorización. |
| E7 | Definitiva | Demostrado, falta captura conforme | [F3-actualizacion](F3-actualizacion/): registro, sondas y capturas, [CT/E7-historial-versiones](capturas-terminal/E7-historial-versiones.png) | Capturas conformes durante la actualización y el rollback, con la sonda y el navegador. Requiere autorización. |
| E8 | Provisional | Parcial | [Registro](E8-eleccion-registro.txt), [quórum previo](prototipo/E8-quorum-previo.txt), [captura durante](E8-web-parada.png), [captura después](E8-web-recuperado.png), [comprobación posterior](verificacion-posterior.txt) | Repetir con la web definitiva y capturas desde otro manager durante la parada: ver el [plan](../entrega/PLAN-C3-E4-E8.md). |

**Límite de las sondas.** Toman una muestra por segundo y por IP, y no acreditan disponibilidad
continua. En E2 se registraron dos tiempos de espera aislados durante la reducción de 12 a 2 réplicas.
En E8 hubo 34 segundos sin muestras entre los dos tramos de sondeo.

## Exposición y defensa

| Criterio | Estado | Evidencia | Falta |
| --- | --- | --- | --- |
| G1 | Realizado según confirmación de la coordinadora | [Guion](../entrega/DEFENSA.md), [presentación](../entrega/presentacion-cloud-g5.pptx) | Asignar partes, ensayar y hacer la exposición, con caída de un nodo en directo. |
| G2 | Presentación realizada; sin registro individual en el repositorio | [Preguntas de repaso](../entrega/DEFENSA.md#preguntas-del-profesor) | Cada integrante debe prepararla: 2 o 3 preguntas sobre cualquier parte. |
| G3 | Presentación realizada; sin registro individual en el repositorio | [Demostraciones](../entrega/DEFENSA.md#demostraciones) | Cada integrante debe hacerla en directo. Requiere laboratorio activo y acceso SSH. |

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
