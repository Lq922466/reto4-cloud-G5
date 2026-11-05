# Checklist final de entrega · RETO 4 CLOUD, Grupo 5

Situación a 5 de noviembre de 2026.

| Situación | Nº | Criterios |
| --- | --- | --- |
| Completados | 29 | F3, F4, F5, F6, F7, F8, F12, A1, A2, A3, A4, A5, B2, B3, B4, B5, C1, C2, C3, C4, D1, D2, D3, E1, E2, E3, E5, E6, E7 |
| Parciales | 9 | F1, F2, F9, F10, F11, A6, B1, E4, E8 |
| Pendientes | 4 | F13, G1, G2, G3 |

**Cómo leerla.** «Completado» indica que hay una comprobación técnica registrada con su evidencia, no una calificación. La matriz procede
de un cotejo anterior, porque la Guía y la Rúbrica originales no están disponibles, así que **esta lista debe contrastarse con ellas**. El
último estado técnico comprobado es de las 09:56 UTC: [auditoría](../evidencias/auditoria/INFORME.md).

## Completados

| Criterio | Qué comprueba | Evidencia | Observación |
| --- | --- | --- | --- |
| F3 | README | [README](../README.md), [etiquetas en Docker Hub](../evidencias/D1-dockerhub-etiquetas.png) |  |
| F4 | Estructura del repositorio | [CT/F4-estructura](../evidencias/capturas-terminal/F4-estructura.png) |  |
| F5 | Codespaces | [CT/F5-entorno](../evidencias/capturas-terminal/F5-entorno.png), [registro técnico](../evidencias/revision-registro-tecnico.txt) |  |
| F6 | Terraform en el repositorio | [CT/A1-modulo-terraform](../evidencias/capturas-terminal/A1-modulo-terraform.png), [CT/F6-codigo-instancias](../evidencias/capturas-terminal/F6-codigo-instancias.png), [apply inicial](../evidencias/prototipo/reto4-apply.log) |  |
| F7 | Scripts | [CT/F7-scripts](../evidencias/capturas-terminal/F7-scripts.png) |  |
| F8 | Mapa de arquitectura | [Diagrama](../diagramas/arquitectura.md), [renderizado](../diagramas/arquitectura.png) | Contrastar la topología con la Guía |
| F12 | Seguridad del repositorio | [Revisión de todo el historial](../evidencias/auditoria/registro-repositorio.txt), [CT/F12-archivos-sensibles](../evidencias/capturas-terminal/F12-archivos-sensibles.png) | Repetir la revisión antes de integrar la PR |
| A1 | Módulo Terraform | [CT/A1-modulo-terraform](../evidencias/capturas-terminal/A1-modulo-terraform.png) |  |
| A2 | Instancias EC2 | [CT/A2-instancias](../evidencias/capturas-terminal/A2-instancias.png) | Vista de EC2 en la consola |
| A3 | Grupo de seguridad | [CT/A3-grupo-seguridad](../evidencias/capturas-terminal/A3-grupo-seguridad.png) | Inbound rules en la consola |
| A4 | Arranque de los nodos | [CT/A4-arranque](../evidencias/capturas-terminal/A4-arranque.png), [registro de arranque](../evidencias/prototipo/manager-g5.txt) | Claves individuales en B1 |
| A5 | Salida nodes | [CT/A5-salida-nodes](../evidencias/capturas-terminal/A5-salida-nodes.png) |  |
| B2 | Alias SSH | [CT/B2-alias](../evidencias/capturas-terminal/B2-alias.png) |  |
| B3 | Comandos simultáneos y copia | [CT/B3-simultaneo-sudo](../evidencias/capturas-terminal/B3-simultaneo-sudo.png), [CT/B3-copia-scp](../evidencias/capturas-terminal/B3-copia-scp.png) |  |
| B4 | Endurecimiento de SSH | [CT/B4-endurecimiento](../evidencias/capturas-terminal/B4-endurecimiento.png) |  |
| B5 | Salto SSH | [CT/B5-salto](../evidencias/capturas-terminal/B5-salto.png) |  |
| C1 | Docker y ping | [CT/C1-docker-ping](../evidencias/capturas-terminal/C1-docker-ping.png) |  |
| C2 | Swarm por IP privada e ingress | [CT/C2-red-ingress](../evidencias/capturas-terminal/C2-red-ingress.png), [registro inicial](../evidencias/prototipo/fase2-3.txt) |  |
| C3 | Nodos del clúster | [CT/C3-nodos](../evidencias/capturas-terminal/C3-nodos.png), [topología inicial](../evidencias/prototipo/fase2-3.txt) | Contrastar los tres managers con la Guía |
| C4 | Red de aplicación | [CT/C4-red-aplicacion](../evidencias/capturas-terminal/C4-red-aplicacion.png) |  |
| D1 | Imágenes 1.0 y 2.0 | [Construcción](../evidencias/D1-imagenes-definitivas.txt), [navegador](../evidencias/D1-navegador-registro.txt), [publicación](../evidencias/D1-publicacion-dockerhub.txt), [descarga](../evidencias/D1-descarga-dockerhub.txt), [etiquetas](../evidencias/D1-dockerhub-etiquetas.png), [CT/D1-imagenes](../evidencias/capturas-terminal/D1-imagenes.png) |  |
| D2 | Pila y servicio | [Despliegue](../evidencias/F3-despliegue/registro.txt), [estado](../evidencias/F3-estado-final.txt), [CT/D2-pila-servicio](../evidencias/capturas-terminal/D2-pila-servicio.png) |  |
| D3 | Acceso por las cuatro IP | [manager-g5](../evidencias/D3-navegador-manager-g5.png), [worker1-g5](../evidencias/D3-navegador-worker1-g5.png), [worker2-g5](../evidencias/D3-navegador-worker2-g5.png), [worker3-g5](../evidencias/D3-navegador-worker3-g5.png), [método](../evidencias/D3-registro.txt), [portada completa](../evidencias/F3-web-final-1.0-completa.png) | Confirmar que el profesor acepta el método |
| E1 | Balanceo | [CT/E1-reparto-peticiones](../evidencias/capturas-terminal/E1-reparto-peticiones.png), [estado](../evidencias/F3-estado-final.txt) |  |
| E2 | Escalado | [F4-E2](../evidencias/F4-E2/): registro, sondas y capturas por estado | Dos tiempos de espera aislados durante la reducción de 12 a 2 réplicas, de causa no determinada |
| E3 | Autorreparación | [F4-E3](../evidencias/F4-E3/): registro, sondas y capturas antes y después |  |
| E5 | Reinicio de Learner Lab | [Verificación final](../evidencias/E5-verificacion-final.txt), [previa](../evidencias/E5-verificacion-previa.txt), [preparación](../evidencias/E5-preparacion.txt), [CT/estado-final](../evidencias/capturas-terminal/estado-final.png) | Vista de EC2 en la consola |
| E6 | Drain | [F4-E6](../evidencias/F4-E6/): registro, sondas y capturas antes, durante y después |  |
| E7 | Actualización y rollback | [F3-actualizacion](../evidencias/F3-actualizacion/): registro, sondas y capturas, [CT/E7-historial-versiones](../evidencias/capturas-terminal/E7-historial-versiones.png) | Captura de terminal tomada durante la prueba: la actual es posterior |

## Parciales

| Criterio | Qué comprueba | Evidencia | Qué falta |
| --- | --- | --- | --- |
| F1 | Colaboradores y acceso | [CT/F1-colaboradores](../evidencias/capturas-terminal/F1-colaboradores.png) | Vista web de Settings → Collaborators. Confirmar integrantes y profesor |
| F2 | Commits y PR por integrante | [CT/F2-historial](../evidencias/capturas-terminal/F2-historial.png) | Vista web de la PR. Commits y PR de cada integrante |
| F9 | Informe técnico | [Informe técnico](../PROYECTO.md), [estructura del Word](../entrega/INFORME-F9-estructura.md) | Word definitivo, tras contrastar con la Guía y la Rúbrica |
| F10 | Capturas por fase | [Índice de evidencias](../evidencias/INDICE.md) | Cinco capturas web de [REVISION](../REVISION.md#capturas-que-faltan) |
| F11 | Gestión del grupo | [GESTION (borrador)](../GESTION.md) | Responsables, seguimiento, Trello y reflexión reales |
| A6 | Cambio y destrucción con Terraform | [Plan final](../evidencias/A6-plan-final.txt), [apply del cambio](../evidencias/A6-apply.txt), [CT/A6-sin-cambios](../evidencias/capturas-terminal/A6-sin-cambios.png), [plan](../evidencias/prototipo/reto4-plan-cidr.log) y [apply](../evidencias/prototipo/reto4-apply.log) iniciales | Destrucción real, con autorización aparte. Etiqueta en la consola |
| B1 | Claves individuales | [CT/B1-claves-autorizadas](../evidencias/capturas-terminal/B1-claves-autorizadas.png) | Claves individuales y criterio sobre vockey |
| E4 | Caída de un worker | [Registro](../evidencias/E4-E5-E8-registro.txt), [sonda](../evidencias/prototipo/E4-E5-http.txt), [captura](../evidencias/E4-web-worker-down.png) | Web definitiva, URL de la sonda y consola. [Análisis](../evidencias/auditoria/E4-E8.md) |
| E8 | Elección de líder | [Registro](../evidencias/E8-eleccion-registro.txt), [quórum previo](../evidencias/prototipo/E8-quorum-previo.txt), [captura durante](../evidencias/E8-web-parada.png), [captura después](../evidencias/E8-web-recuperado.png), [comprobación posterior](../evidencias/verificacion-posterior.txt) | Web definitiva, y el estado del clúster durante la parada. [Análisis](../evidencias/auditoria/E4-E8.md) |

## Pendientes

| Criterio | Qué comprueba | Material disponible | Qué falta |
| --- | --- | --- | --- |
| F13 | Prácticas individuales | [Estructura sin contenido](../practica-individual/README.md) | Prácticas reales de cada integrante |
| G1 | Exposición de grupo | [Guion](../entrega/DEFENSA.md), [presentación](../entrega/presentacion-cloud-g5.pptx) | Ensayar y realizar la exposición |
| G2 | Defensa individual | [Preguntas de repaso](../entrega/DEFENSA.md#preguntas-del-profesor) | Defensa individual ante el profesor |
| G3 | Demostración individual | [Demostraciones](../entrega/DEFENSA.md#demostraciones) | Demostración técnica individual |

## Antes de entregar

### Contraste y técnica

- [ ] Guía y Rúbrica recibidas y contrastadas con [REVISION.md](../REVISION.md#contraste-pendiente-con-la-guía-y-la-rúbrica).
- [ ] Laboratorio activo y [auditoría](../evidencias/auditoria/INFORME.md) repetida en vivo.
- [ ] `verificar-despliegue.sh` correcto con las IP del día.
- [ ] Decisión tomada sobre la destrucción de A6, y sobre repetir E4 y E8.

### Documentación

- [ ] Cinco [capturas web](../REVISION.md#capturas-que-faltan) añadidas, sin el ID de la cuenta de AWS.
- [ ] [GESTION.md](../GESTION.md) sin campos `[POR COMPLETAR]`.
- [ ] Prácticas reales de cada integrante en [`practica-individual/`](../practica-individual/README.md).
- [ ] Word generado, si la Guía lo exige, y decisión sobre versionarlo.
- [ ] Nombres de los integrantes en la [presentación](presentacion-cloud-g5.pptx).

### Repositorio

- [ ] Commits y PR de cada integrante.
- [ ] Acceso del profesor confirmado.
- [ ] `python3 scripts/revisar-secretos.py origin/main HEAD` sin coincidencias.
- [ ] PR revisada e integrada, si la Guía lo pide.

### Defensa

- [ ] Papeles A–D asignados y [guion](DEFENSA.md) ensayado en 10 minutos.
- [ ] Preparación de las demostraciones hecha ese mismo día, con el plan B a mano.
- [ ] Cada integrante puede responder las [preguntas de repaso](DEFENSA.md#preguntas-del-profesor) y hacer su demostración.
