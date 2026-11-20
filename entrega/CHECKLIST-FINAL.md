# Checklist final de entrega · RETO 4 CLOUD, Grupo 5

Revisada el 18 de noviembre de 2026, con los requisitos exactos de la Rúbrica y los mismos estados que [REVISION.md](../REVISION.md).
El último estado técnico registrado es del 9 de noviembre (Swarm, SSH y web) y del 10 de noviembre (Terraform). [Contraste completo](CONTRASTE-GUIA-RUBRICA.md).

**Regla de la Rúbrica:** cada requisito puntúa solo si funciona durante la corrección y está respaldado por la captura correspondiente (según instrucciones) y los archivos correspondientes en el repositorio. Ítem completo: puntuación entera. Ítem parcial: mitad. No conseguido: 0.

**Normas de la Guía para las capturas:** debe verse claramente el prompt con el hostname y la fecha/hora; cada captura debe incluir un comentario indicando qué prueba es, el resultado y el autor; y está estrictamente prohibido mostrar credenciales de AWS o claves privadas.

| Situación | Nº | Criterios |
| --- | --- | --- |
| Listos | 22 | A1, A4, A5, B2, B3, B4, B5, C1, C2, C4, D1, D2, E1, E5, F3, F4, F5, F6, F7, F8, F9, F12 |
| Demostrados, falta captura conforme | 9 | A2, A3, C3, D3, E2, E3, E6, E7, F1 |
| Parciales | 7 | A6, B1, E4, E8, F2, F10, F11 |
| Pendientes | 4 | F13, G1, G2, G3 |

## Listos

| Cód. | Qué pide la Rúbrica | Evidencia exigida | Nuestra evidencia | Qué falta |
| --- | --- | --- | --- | --- |
| A1 | Proyecto organizado, con variables | Ficheros en /terraform | [Captura conforme](../evidencias/capturas-conformes/A1-modulo.png), [CT/A1-modulo-terraform](../evidencias/capturas-terminal/A1-modulo-terraform.png) | Fijar la imagen de Ubuntu antes de cualquier `apply` (incidencia I1.4 de `PROYECTO.md`). |
| A4 | Script de arranque (hostname, zona, Docker, claves) | Script /terraform; log | [Script](../evidencias/capturas-conformes/A4-script.png) y [arranque](../evidencias/capturas-conformes/A4-arranque.png) en capturas conformes, [CT/A4-arranque](../evidencias/capturas-terminal/A4-arranque.png), [registro de arranque](../evidencias/prototipo/manager-g5.txt) | Nada. |
| A5 | Salidas con IP pública, privada e ID | Salida de Terraform | [Captura conforme](../evidencias/capturas-conformes/A5-salidas.png), [CT/A5-salida-nodes](../evidencias/capturas-terminal/A5-salida-nodes.png) | Versionar un extracto del `refresh-only` del 10 de noviembre, sin datos de la cuenta. |
| B2 | Archivo config SSH con nombre corto | /config; conexión | [Plantilla](../evidencias/capturas-conformes/B2-plantilla.png) y [conexión](../evidencias/capturas-conformes/B2-conexion.png) en capturas conformes, [CT/B2-alias](../evidencias/capturas-terminal/B2-alias.png) | Regenerar los alias tras cada reinicio del laboratorio. |
| B3 | Control total, órdenes simultáneas y copia ficheros | Capturas cliente | [Órdenes simultáneas](../evidencias/capturas-conformes/B3-simultaneo.png) y [copia](../evidencias/capturas-conformes/B3-copia.png) en capturas conformes, [CT/B3-simultaneo-sudo](../evidencias/capturas-terminal/B3-simultaneo-sudo.png), [CT/B3-copia-scp](../evidencias/capturas-terminal/B3-copia-scp.png) | Nada. |
| B4 | Sin contraseña ni root; permisos locales | Config SSH; permisos | [Captura conforme](../evidencias/capturas-conformes/B4-endurecimiento.png), [CT/B4-endurecimiento](../evidencias/capturas-terminal/B4-endurecimiento.png) | Nada. |
| B5 | Acceso a workers por IP privada (salto) | Conexión con salto | [Captura conforme](../evidencias/capturas-conformes/B5-salto.png), [CT/B5-salto](../evidencias/capturas-terminal/B5-salto.png) | Nada. |
| C1 | Docker en 4 nodos; conectividad por IP privada | Ping entre nodos | [Captura conforme](../evidencias/capturas-conformes/C1-ping.png), [CT/C1-docker-ping](../evidencias/capturas-terminal/C1-docker-ping.png) | Nada. |
| C2 | Clúster por IP privada; MTU ajustado (1450) | Info clúster y redes | [Captura conforme](../evidencias/capturas-conformes/C2-cluster.png), [CT/C2-red-ingress](../evidencias/capturas-terminal/C2-red-ingress.png), [registro inicial](../evidencias/prototipo/fase2-3.txt) | Nada. |
| C4 | Red overlay propia para servicios | Listado de redes | [Captura conforme](../evidencias/capturas-conformes/C4-red.png), [CT/C4-red-aplicacion](../evidencias/capturas-terminal/C4-red-aplicacion.png) | Nada. |
| D1 | Imagen propia (identifica contenedor); ver 1.0 y 2.0 | /app; Docker Hub | [Captura conforme](../evidencias/capturas-conformes/D1-dockerhub.png), [Construcción](../evidencias/D1-imagenes-definitivas.txt), [navegador](../evidencias/D1-navegador-registro.txt), [publicación](../evidencias/D1-publicacion-dockerhub.txt), [descarga](../evidencias/D1-descarga-dockerhub.txt), [etiquetas](../evidencias/D1-dockerhub-etiquetas.png), [CT/D1-imagenes](../evidencias/capturas-terminal/D1-imagenes.png) | Nada. Mostrar Docker Hub en la defensa. |
| D2 | Servicio 4 réplicas, red grupo, políticas reinicio | Fichero despliegue | [Despliegue](../evidencias/F3-despliegue/registro.txt), [estado](../evidencias/F3-estado-final.txt), [CT/D2-pila-servicio](../evidencias/capturas-terminal/D2-pila-servicio.png) | Nada. |
| E1 | Balanceo de carga | Respuestas distintas | [Captura conforme](../evidencias/capturas-conformes/E1-balanceo.png), [CT/E1-reparto-peticiones](../evidencias/capturas-terminal/E1-reparto-peticiones.png), [estado](../evidencias/F3-estado-final.txt) | Nada. |
| E5 | Reincorporación y reequilibrio; reinicio lab | Nodos y servicio | [Captura conforme](../evidencias/capturas-conformes/E5-estado.png), [verificación final](../evidencias/E5-verificacion-final.txt), [previa](../evidencias/E5-verificacion-previa.txt), [preparación](../evidencias/E5-preparacion.txt), [CT/estado-final](../evidencias/capturas-terminal/estado-final.png) | Comprobar el clúster tras el reinicio del 10 de noviembre. |
| F3 | README.md (resumen, instrucciones rápidas, enlaces) | README.md | [README](../README.md), [etiquetas en Docker Hub](../evidencias/D1-dockerhub-etiquetas.png) | Nada. |
| F4 | Estructura (/terraform, /app, /config, y .devcontainer) | Árbol repo | [Captura conforme](../evidencias/capturas-conformes/F4-estructura.png), [CT/F4-estructura](../evidencias/capturas-terminal/F4-estructura.png) | Nada. Desde el 18 de noviembre, la estructura está en `main`. |
| F5 | Entorno colaborativo: .devcontainer (AWS CLI, Terraform) y capturas Codespace | .devcontainer.json, proyecto.md | [Captura conforme](../evidencias/capturas-conformes/F5-entorno.png), [CT/F5-entorno](../evidencias/capturas-terminal/F5-entorno.png), [registro técnico](../evidencias/revision-registro-tecnico.txt) | Nada imprescindible. Una vista del Codespace en el navegador sería un apoyo. |
| F6 | Código Terraform funcional | /terraform | [Captura conforme](../evidencias/capturas-conformes/F6-codigo.png), [CT/A1-modulo-terraform](../evidencias/capturas-terminal/A1-modulo-terraform.png), [CT/F6-codigo-instancias](../evidencias/capturas-terminal/F6-codigo-instancias.png), [apply inicial](../evidencias/prototipo/reto4-apply.log) | Fijar la imagen de Ubuntu antes del siguiente `apply`: el plan del 10 de noviembre propone sustituir las instancias. |
| F7 | Scripts comentados | /scripts | [Captura conforme](../evidencias/capturas-conformes/F7-scripts.png), [CT/F7-scripts](../evidencias/capturas-terminal/F7-scripts.png) | Nada. Si cambian los scripts, mantener los comentarios. |
| F8 | Mapa arquitectura propio | /diagramas | [Diagrama](../diagramas/arquitectura.md), [renderizado](../diagramas/arquitectura.png) | Nada. Actualizado el 18 de noviembre a un manager líder y tres workers. |
| F9 | proyecto.md: Informe extenso Fases 0-5 paso a paso | proyecto.md | [Informe técnico](../PROYECTO.md), [estructura del Word, opcional](INFORME-F9-estructura.md) | Nada. Las capturas que faltan se cuentan en F10. **El Word no es necesario.** |
| F12 | Sin credenciales, claves ni estado de tf | Repo y .gitignore | [Captura conforme](../evidencias/capturas-conformes/F12-seguridad.png) del 18 de noviembre, [revisión de todo el historial](../evidencias/auditoria/registro-repositorio.txt), [CT/F12-archivos-sensibles](../evidencias/capturas-terminal/F12-archivos-sensibles.png) | Repetir `revisar-secretos.py 6f3d838 HEAD` antes de cada integración. |

## Demostrados

Hay una comprobación real, pero falta la captura concreta que pide la Rúbrica. Se generan con el [procedimiento](PROCEDIMIENTO-CAPTURAS.md).

| Cód. | Qué pide la Rúbrica | Evidencia exigida | Nuestra evidencia | Qué falta |
| --- | --- | --- | --- | --- |
| A2 | Manager + 3 workers definidos una vez; etiquetas | Código; consola EC2 | [Captura conforme](../evidencias/capturas-conformes/A2-instancias.png), [CT/A2-instancias](../evidencias/capturas-terminal/A2-instancias.png) | Captura de la consola de EC2 con la norma de capturas. |
| A3 | Security group con política de mínimos | Código; reglas EC2 | [Captura conforme](../evidencias/capturas-conformes/A3-reglas.png), [CT/A3-grupo-seguridad](../evidencias/capturas-terminal/A3-grupo-seguridad.png) | Captura de reglas en la consola. Retirar la regla temporal `88.14.93.201/32` al terminar B1. |
| C3 | 4 nodos activos, manager líder, 3 workers unidos | Listado de nodos | [Captura conforme del 6 de noviembre: NO CORRECTO](../evidencias/capturas-conformes/C3-nodos.png), [CT/C3-nodos](../evidencias/capturas-terminal/C3-nodos.png), [topología inicial](../evidencias/prototipo/fase2-3.txt) | El 9 de noviembre Codex bajó los dos managers temporales y manager-g5 quedó como único líder, con tres workers. Solo consta en su registro de sesión. Con el laboratorio activo, comprobarlo y repetir `C3-nodos`. |
| D3 | Accesible por IP pública de los 4 nodos | Navegador | [manager-g5](../evidencias/D3-navegador-manager-g5.png), [worker1-g5](../evidencias/D3-navegador-worker1-g5.png), [worker2-g5](../evidencias/D3-navegador-worker2-g5.png), [worker3-g5](../evidencias/D3-navegador-worker3-g5.png), [método](../evidencias/D3-registro.txt), [portada completa](../evidencias/F3-web-final-1.0-completa.png) | Comentario en cada captura, y rehacerlas con las IP del día. |
| E2 | Escalado (8, 12, 2) | Reparto de réplicas | [F4-E2](../evidencias/F4-E2/): registro, sondas y capturas por estado | Capturas conformes antes, durante y después, con la sonda visible. Requiere autorización. Conservar la observación de los dos tiempos de espera. |
| E3 | Autorreparación (eliminar contenedor) | Servicio antes/después | [F4-E3](../evidencias/F4-E3/): registro, sondas y capturas antes y después | Capturas conformes, con la sonda visible. Requiere autorización. |
| E6 | Mantenimiento (modo drain) | Nodos y servicio | [F4-E6](../evidencias/F4-E6/): registro, sondas y capturas antes, durante y después | Capturas conformes, con la sonda visible. Requiere autorización. |
| E7 | Actualización (1.0 a 2.0) sin corte y rollback | Script y navegador | [F3-actualizacion](../evidencias/F3-actualizacion/): registro, sondas y capturas, [CT/E7-historial-versiones](../evidencias/capturas-terminal/E7-historial-versiones.png) | Capturas conformes durante la actualización y el rollback, con la sonda y el navegador. Requiere autorización. |
| F1 | Privado, todos colaboradores, profesor invitado | Settings | [Captura conforme](../evidencias/capturas-conformes/F1-repositorio.png) del 18 de noviembre, con el profesor (jc-csl) como colaborador, [CT/F1-colaboradores](../evidencias/capturas-terminal/F1-colaboradores.png) | Captura de Settings → Collaborators en el navegador. |

## Parciales

| Cód. | Qué pide la Rúbrica | Evidencia exigida | Nuestra evidencia | Qué falta |
| --- | --- | --- | --- | --- |
| A6 | Pruebas clave: validación, plan, cambio, destrucción | Secuencia capturas | [Plan final](../evidencias/A6-plan-final.txt), [apply del cambio](../evidencias/A6-apply.txt), [plan posterior: NO CORRECTO](../evidencias/capturas-conformes/A6-sin-cambios.png), [CT/A6-sin-cambios](../evidencias/capturas-terminal/A6-sin-cambios.png), [plan](../evidencias/prototipo/reto4-plan-cidr.log) y [apply](../evidencias/prototipo/reto4-apply.log) iniciales | Fijar la AMI y obtener `No changes`; destrucción real, con autorización aparte y tras aclararlo con el profesor; secuencia completa en capturas. |
| B1 | Clave propia en 4 nodos; vockey sustituida | Repositorio; authorized_keys | [Captura conforme](../evidencias/capturas-conformes/B1-clave-nodos.png), [registro de manager-g5](../evidencias/capturas-conformes/B1-registro-manager.png), accesos de [Enrique](../evidencias/capturas-integrantes/B1-acceso-enrique.png), [Alexandra](../evidencias/capturas-integrantes/B1-acceso-alexandra.png) e [Ibai](../evidencias/capturas-integrantes/B1-acceso-ibai.png) a manager-g5, accesos de Cristina a [manager-g5](../evidencias/capturas-integrantes/B1-acceso-cristina-manager.png), [worker1-g5](../evidencias/capturas-integrantes/B1-acceso-cristina-worker1.png), [worker2-g5](../evidencias/capturas-integrantes/B1-acceso-cristina-worker2.png) y [worker3-g5](../evidencias/capturas-integrantes/B1-acceso-cristina-worker3.png), su [alias](../evidencias/capturas-integrantes/B1-cristina-config-alias.png) y su [config](../evidencias/capturas-integrantes/B1-cristina-config-ruta.png), [registro de Cristina en los cuatro nodos](../evidencias/capturas-conformes/B1-registro-cristina.png), [registro de la instalación](../evidencias/auditoria/registro-2026-11-09-b1.txt), [claves del 6 de noviembre](../evidencias/capturas-conformes/B1-claves.png), [CT/B1-claves-autorizadas](../evidencias/capturas-terminal/B1-claves-autorizadas.png) | Las cuatro claves públicas están en `terraform/claves/` y en los cuatro nodos desde el 9 de noviembre. Falta que Enrique, Alexandra e Ibai entren en los tres workers, con capturas con el comentario de la norma; la captura `B1-repositorio`; retirar la regla temporal `88.14.93.201/32`; y aclarar `vockey`: la Guía la deja de reserva y la Rúbrica la sustituye. |
| E4 | Alta disponibilidad (caída worker) | Nodo caído; script OK | [Registro](../evidencias/E4-E5-E8-registro.txt), [sonda](../evidencias/prototipo/E4-E5-http.txt), [captura](../evidencias/E4-web-worker-down.png) | Repetir con la web definitiva y capturas conformes: ver el [plan](PLAN-C3-E4-E8.md). También es la demostración obligatoria de la exposición. |
| E8 | Alta disp. managers (nuevo líder) | Listado desde otro | [Registro](../evidencias/E8-eleccion-registro.txt), [quórum previo](../evidencias/prototipo/E8-quorum-previo.txt), [captura durante](../evidencias/E8-web-parada.png), [captura después](../evidencias/E8-web-recuperado.png), [comprobación posterior](../evidencias/verificacion-posterior.txt) | Repetir con la web definitiva y capturas desde otro manager durante la parada: ver el [plan](PLAN-C3-E4-E8.md). |
| F2 | Commits repartidos y uso de Pull Requests por colaboradores | Historial y PRs | [Captura conforme](../evidencias/capturas-conformes/F2-historial.png) del 5 de noviembre, [CT/F2-historial](../evidencias/capturas-terminal/F2-historial.png) | Commits y PR propios de Alexandra e Ibai, y de Enrique desde un terminal. Las PR #3–#5 se abrieron desde la cuenta de Cristina con borradores de Codex. Captura del historial de `main` y de las PR. |
| F10 | Capturas de evidencias (Fases 0-5) con normativa y comentadas | proyecto.md | [Capturas conformes](../evidencias/capturas-conformes/INDICE.md), integradas en el informe | Hay 32 capturas conformes de los días 5, 6, 9 y 18 de noviembre. Faltan las de las pruebas con sonda, D3, C3 actual y las de la consola de AWS. |
| F11 | Reparto tareas y reflexión | gestion.md | [GESTION (borrador)](../GESTION.md) | Recoge la organización acordada y separa lo asignado de lo realizado. Falta el trabajo real de cada integrante, sus seguimientos y la reflexión. |

## Pendientes

| Cód. | Qué pide la Rúbrica | Evidencia exigida | Material disponible | Qué falta |
| --- | --- | --- | --- | --- |
| F13 | Documentación práctica individual | /practica-individual | [Estructura sin contenido](../practica-individual/README.md) | Cada integrante debe aportar la documentación de su práctica individual previa de EC2. |
| G1 | Exposición (10 min): demo, arquitectura, código | Día exposición | [Guion](DEFENSA.md), [presentación](presentacion-cloud-g5.pptx) | Presentación realizada según confirmación de la coordinadora; no consta acta ni captura del directo. |
| G2 | Preguntas individuales a cualquier miembro | Día exposición | [Preguntas de repaso](DEFENSA.md#preguntas-del-profesor) | Cada integrante debe prepararla: 2 o 3 preguntas sobre cualquier parte. |
| G3 | Demostración técnica individual | Día exposición | [Demostraciones](DEFENSA.md#demostraciones) | Cada integrante debe hacerla en directo. Requiere laboratorio activo y acceso SSH. |

## Antes de entregar

### Decisiones

- [ ] Profesor consultado: `vockey`, destrucción de A6, autoría de las capturas y fecha de entrega.
- [ ] Repetición de E4 y E8 con la web definitiva, según el [plan](PLAN-C3-E4-E8.md), revisada y autorizada.
- [ ] Imagen de Ubuntu fijada en Terraform, con autorización, antes de cualquier `apply` (incidencia I1.4 de `PROYECTO.md`).

### Técnica

- [ ] Laboratorio activo, credenciales renovadas y regla SSH limitada a la IP actual `/32`.
- [ ] `bash scripts/comprobar-laboratorio.sh` sin nada que corregir, con manager-g5 como único manager.
- [ ] `ssh manager-g5` funciona solo con el nombre corto, tras `bash scripts/actualizar-ips.sh`.
- [ ] `terraform plan` de solo lectura con `No changes` después de fijar la imagen.
- [x] Claves públicas de los cuatro integrantes en `terraform/claves/` e instaladas en los cuatro nodos (9 de noviembre).
- [ ] Enrique, Alexandra e Ibai entran en los tres workers con su clave; después, retirar la regla temporal `88.14.93.201/32`.
- [x] C3 corregido el 9 de noviembre (registro de sesión de Codex).
- [ ] Captura `C3-nodos` repetida con el laboratorio activo.
- [ ] E4 y E8 repetidos con la web definitiva, y E2, E3, E6 y E7 con capturas conformes, si se autoriza.

### Documentación

- [ ] Capturas de los grupos «laboratorio» y «prueba» generadas e integradas en `PROYECTO.md`.
- [ ] [Capturas con sesión](../REVISION.md#capturas-que-faltan) añadidas, sin el ID de la cuenta de AWS.
- [ ] [GESTION.md](../GESTION.md) con reparto, responsables y reflexión reales.
- [ ] Práctica individual previa en [`practica-individual/`](../practica-individual/README.md).
- [ ] Nombres, reparto y topología actual en la [presentación](presentacion-cloud-g5.pptx): las diapositivas 3, 5 y 6 aún describen tres managers.

### Repositorio

- [ ] Commits y PR de cada integrante desde su cuenta. Las PR #3–#5 están abiertas hacia `main`, pendientes de validar.
- [x] Profesor con acceso al repositorio: `jc-csl`, con permiso de escritura (18 de noviembre).
- [x] `python3 scripts/revisar-secretos.py 6f3d838 HEAD` sin coincidencias antes de integrar (18 de noviembre).
- [x] `python3 scripts/validar-entrega.py` sin errores (18 de noviembre).
- [x] PR #1 integrada en `main`, que es la única rama de trabajo y de entrega (18 de noviembre).

### Defensa

- [ ] Papeles A–D asignados y [guion](DEFENSA.md) ensayado en 10 minutos.
- [ ] Caída de un nodo ensayada, con el plan B a mano.
- [ ] Cada integrante puede responder las [preguntas de repaso](DEFENSA.md#preguntas-del-profesor) y hacer su demostración.
