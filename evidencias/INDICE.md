# Índice de evidencias por criterio

Organiza las evidencias del repositorio con los mismos criterios que [REVISION.md](../REVISION.md).
Situación a 5 de noviembre de 2026. Último estado técnico comprobado: 09:56 UTC.

**Contexto de cada evidencia**

- **Definitiva:** web F1 final, desplegada el 5 de noviembre.
- **Provisional:** portal provisional, 4 de noviembre, con IP públicas que ya han cambiado.
- **Entorno:** no depende de la web servida.

**Tipos.** Registro: salida de comandos en texto. Terminal: captura de xterm con comandos reales.
Navegador: captura de la web. Las capturas de Chromium sin interfaz no muestran la dirección; las
de D3 sí. Autores: Codex el 4 de noviembre y Claude Code el 5 de noviembre.

`CT/` es [capturas-terminal/](capturas-terminal/INDICE.md). Cada imagen de esa carpeta tiene un
`.txt` con la misma salida.

## Fase 0 · Repositorio y entorno

| Criterio | Estado | Evidencia | Falta |
| --- | --- | --- | --- |
| F1 | Parcial | [CT/F1-colaboradores](capturas-terminal/F1-colaboradores.png) | Vista web de Settings → Collaborators. Confirmar integrantes y profesor |
| F2 | Parcial | [CT/F2-historial](capturas-terminal/F2-historial.png) | Vista web de la PR. Commits y PR de cada integrante |
| F3 | Verificado | [README](../README.md), [etiquetas en Docker Hub](D1-dockerhub-etiquetas.png) | — |
| F4 | Verificado | [CT/F4-estructura](capturas-terminal/F4-estructura.png) | — |
| F5 | Verificado con registro | [CT/F5-entorno](capturas-terminal/F5-entorno.png), [registro técnico](revision-registro-tecnico.txt) | — |
| F6 | Verificado con registro | [CT/A1-modulo-terraform](capturas-terminal/A1-modulo-terraform.png), [CT/F6-codigo-instancias](capturas-terminal/F6-codigo-instancias.png), [apply inicial](prototipo/reto4-apply.log) | — |
| F7 | Verificado | [CT/F7-scripts](capturas-terminal/F7-scripts.png) | — |
| F8 | Verificado | [Diagrama](../diagramas/arquitectura.md) | Captura del diagrama renderizado en GitHub |
| F9 | Parcial | [Estructura del informe](../entrega/INFORME-F9-estructura.md), [PROYECTO](../PROYECTO.md) | Word definitivo, tras contrastar con la Guía y la Rúbrica |
| F10 | Parcial | Este índice | Seis capturas web de [REVISION](../REVISION.md#capturas-que-faltan) |
| F11 | Parcial | [GESTION (borrador)](../GESTION.md) | Responsables, seguimiento, Trello y reflexión reales |
| F12 | Verificado en archivos revisados | [CT/F12-archivos-sensibles](capturas-terminal/F12-archivos-sensibles.png) | Repetir la revisión antes de integrar la PR |
| F13 | Pendiente | [Estructura sin contenido](../practica-individual/README.md) | Prácticas reales de cada integrante |

## Fase 1 · Infraestructura

| Criterio | Estado | Evidencia | Falta |
| --- | --- | --- | --- |
| A1 | Verificado | [CT/A1-modulo-terraform](capturas-terminal/A1-modulo-terraform.png) | — |
| A2 | Verificado con registro | [CT/A2-instancias](capturas-terminal/A2-instancias.png) | Vista de EC2 en la consola |
| A3 | Verificado con registro | [CT/A3-grupo-seguridad](capturas-terminal/A3-grupo-seguridad.png) | Inbound rules en la consola |
| A4 | Verificado con registro | [CT/A4-arranque](capturas-terminal/A4-arranque.png), [registro de arranque](prototipo/manager-g5.txt) | Claves individuales en B1 |
| A5 | Verificado con registro | [CT/A5-salida-nodes](capturas-terminal/A5-salida-nodes.png) | — |
| A6 | Parcial | [Plan final](A6-plan-final.txt), [apply del cambio](A6-apply.txt), [CT/A6-sin-cambios](capturas-terminal/A6-sin-cambios.png), [plan](prototipo/reto4-plan-cidr.log) y [apply](prototipo/reto4-apply.log) iniciales | Destrucción real, con autorización aparte. Etiqueta en la consola |

## Fase 2 · SSH

| Criterio | Estado | Evidencia | Falta |
| --- | --- | --- | --- |
| B1 | Parcial | [CT/B1-claves-autorizadas](capturas-terminal/B1-claves-autorizadas.png) | Claves individuales y criterio sobre vockey |
| B2 | Verificado con registro | [CT/B2-alias](capturas-terminal/B2-alias.png) | — |
| B3 | Verificado con registro | [CT/B3-simultaneo-sudo](capturas-terminal/B3-simultaneo-sudo.png), [CT/B3-copia-scp](capturas-terminal/B3-copia-scp.png) | — |
| B4 | Verificado con registro | [CT/B4-endurecimiento](capturas-terminal/B4-endurecimiento.png) | — |
| B5 | Verificado con registro | [CT/B5-salto](capturas-terminal/B5-salto.png) | — |

## Fase 3 · Docker Swarm

| Criterio | Estado | Evidencia | Falta |
| --- | --- | --- | --- |
| C1 | Verificado con registro | [CT/C1-docker-ping](capturas-terminal/C1-docker-ping.png) | — |
| C2 | Verificado con registro | [CT/C2-red-ingress](capturas-terminal/C2-red-ingress.png), [registro inicial](prototipo/fase2-3.txt) | — |
| C3 | Verificado con registro | [CT/C3-nodos](capturas-terminal/C3-nodos.png), [topología inicial](prototipo/fase2-3.txt) | Contrastar los tres managers con la Guía |
| C4 | Verificado con registro | [CT/C4-red-aplicacion](capturas-terminal/C4-red-aplicacion.png) | — |

## Fase 4 · Web e imágenes (definitiva)

| Criterio | Estado | Evidencia | Falta |
| --- | --- | --- | --- |
| D1 | Verificado con registro | [Construcción](D1-imagenes-definitivas.txt), [navegador](D1-navegador-registro.txt), [publicación](D1-publicacion-dockerhub.txt), [descarga](D1-descarga-dockerhub.txt), [etiquetas](D1-dockerhub-etiquetas.png), [CT/D1-imagenes](capturas-terminal/D1-imagenes.png) | — |
| D2 | Verificado con registro | [Despliegue](F3-despliegue/registro.txt), [estado](F3-estado-final.txt), [CT/D2-pila-servicio](capturas-terminal/D2-pila-servicio.png) | — |
| D3 | Verificado con registro | [manager-g5](D3-navegador-manager-g5.png), [worker1-g5](D3-navegador-worker1-g5.png), [worker2-g5](D3-navegador-worker2-g5.png), [worker3-g5](D3-navegador-worker3-g5.png), [método](D3-registro.txt), [portada completa](F3-web-final-1.0-completa.png) | Confirmar que el profesor acepta el método |

## Fase 5 · Orquestación

| Criterio | Contexto | Estado | Evidencia | Falta |
| --- | --- | --- | --- | --- |
| E1 | Definitiva | Verificado con registro | [CT/E1-reparto-peticiones](capturas-terminal/E1-reparto-peticiones.png), [estado](F3-estado-final.txt) | — |
| E2 | Definitiva | Verificado con observación | [F4-E2](F4-E2/): registro, sondas y capturas por estado | — |
| E3 | Definitiva | Verificado con registro | [F4-E3](F4-E3/): registro, sondas y capturas antes y después | — |
| E4 | Provisional | Verificado en prototipo | [Registro](E4-E5-E8-registro.txt), [sonda](prototipo/E4-E5-http.txt), [captura](E4-web-worker-down.png) | Consola y terminal solo repitiendo la prueba |
| E5 | Entorno | Verificado con registro | [Verificación final](E5-verificacion-final.txt), [previa](E5-verificacion-previa.txt), [preparación](E5-preparacion.txt), [CT/estado-final](capturas-terminal/estado-final.png) | Vista de EC2 en la consola |
| E6 | Definitiva | Verificado con registro | [F4-E6](F4-E6/): registro, sondas y capturas antes, durante y después | — |
| E7 | Definitiva | Verificado con registro | [F3-actualizacion](F3-actualizacion/): registro, sondas y capturas, [CT/E7-historial-versiones](capturas-terminal/E7-historial-versiones.png) | Captura de terminal tomada durante la prueba: la actual es posterior |
| E8 | Provisional | Elección verificada con límite de sondeo | [Registro](E8-eleccion-registro.txt), [quórum previo](prototipo/E8-quorum-previo.txt), [captura durante](E8-web-parada.png), [captura después](E8-web-recuperado.png), [comprobación posterior](verificacion-posterior.txt) | Capturas durante el cambio de líder, solo repitiendo la prueba |

**Límite de las sondas.** Toman una muestra por segundo y por IP, y no acreditan disponibilidad
continua. En E2 se registraron dos tiempos de espera aislados durante la reducción de 12 a 2 réplicas.
En E8 hubo 34 segundos sin muestras entre los dos tramos de sondeo.

## Exposición y defensa

| Criterio | Estado | Evidencia | Falta |
| --- | --- | --- | --- |
| G1 | Pendiente | [Guion de diez minutos](../REVISION.md#guion-de-exposición-de-diez-minutos) | Preparar y realizar la exposición |
| G2 | Pendiente | — | Defensa individual ante el profesor |
| G3 | Pendiente | — | Demostración técnica individual |

## Evidencias que no deben presentarse como resultado final

Son reales y se conservan como registro, pero no acreditan el estado final.

| Archivo | Qué es | Sustituida por |
| --- | --- | --- |
| [A6-plan-previo](A6-plan-previo.txt), [A6-plan-actual](A6-plan-actual.txt) | Planes de A6 anteriores al definitivo | [A6-plan-final](A6-plan-final.txt) y [A6-apply](A6-apply.txt) |
| [E5-verificacion-posterior](E5-verificacion-posterior.txt) | Verificación de E5 interrumpida por una denegación de AWS | [E5-verificacion-final](E5-verificacion-final.txt) |
| [E5-web-recuperado](E5-web-recuperado.png) | Portal tras reincorporar un worker en E4, no tras reiniciar Learner Lab | [CT/estado-final](capturas-terminal/estado-final.png) |
| [D1-publicacion-intento-fallido](D1-publicacion-intento-fallido.txt) | Primer intento rechazado por Docker Hub. Útil para Incidencias | [D1-publicacion-dockerhub](D1-publicacion-dockerhub.txt) |
| [D1-navegador 1.0](D1-navegador-1.0.png) y [2.0](D1-navegador-2.0.png), [F1-candidata-local](F1-candidata-local.png) | Web en contenedores temporales o en local, sin desplegar | [Capturas D3](D3-registro.txt) |
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
