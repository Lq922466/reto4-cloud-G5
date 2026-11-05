# Estructura del informe F9

**Es la estructura para el Word.** El contenido técnico ya está en [PROYECTO.md](../PROYECTO.md). El Word se generará después de
contrastarla con la Guía y la Rúbrica originales, que no estaban disponibles al prepararla, y el orden, los apartados y el formato
pueden cambiar con ese contraste.

Las rutas son relativas a `evidencias/`, y `CT/` equivale a `capturas-terminal/`.

## Reglas para el Word

- **Solo capturas reales y sin retocar.** Cada `[USUARIO n]` marca una captura pendiente de hacer: no debe sustituirse
  por otra imagen.
- **Pie de cada figura:** número, qué muestra, fecha y hora, autor y máquina. Por ejemplo: «Figura 12. Reparto con 12
  réplicas. 5 de noviembre de 2026, 10:35 (Madrid). Captura: Claude Code. Máquina: manager-g5».
- **Autor de la captura:** Codex el 4 de noviembre, Claude Code el 5 de noviembre y la persona que la haga en las `[USUARIO n]`.
- **Distinguir siempre** entre web definitiva y portal provisional, y no presentar el segundo como el primero.
- **No afirmar disponibilidad continua.** Las sondas toman una muestra por segundo y por IP.
- **No incluir** claves, tokens ni el identificador de la cuenta de AWS.

## Portada e índice

Título, grupo 5, 2º ASIR, integrantes `[POR COMPLETAR]`, fecha `[POR COMPLETAR]`, enlaces al repositorio y a
[Docker Hub](https://hub.docker.com/r/innnx/reto4-f1/tags).

## 1. Resumen y alcance

Evento y objetivo del reto, arquitectura en una frase y estado final con sus límites: lo demostrado y lo que no.

**Estado final comprobado (5 de noviembre, 09:56 UTC):** cuatro nodos Ready/Active, `reto4_web` en 4/4 con
`innnx/reto4-f1:1.0`, una réplica por nodo y HTTP 200 en las cuatro IP. Figura: `CT/estado-final.png`.

## 2. Equipo y gestión (F1, F2, F11)

Procede de [GESTION.md](../GESTION.md). Debe completarlo el grupo: reparto, seguimiento semanal, Trello y uso de IA.

| Figura | Archivo |
| --- | --- |
| Cuentas con acceso, por terminal | `CT/F1-colaboradores.png` |
| Historial y PR, por terminal | `CT/F2-historial.png` |
| Colaboradores en la web | `[USUARIO 4]` GitHub → Settings → Collaborators |
| PR #1 en la web | `[USUARIO 5]` GitHub → Pull requests → PR #1, Conversation y Commits |
| Tablero de Trello | `[POR COMPLETAR]`, si existe |

## 3. Arquitectura (F8)

Diagrama: [`diagramas/arquitectura.png`](../diagramas/arquitectura.png), generado a partir de [arquitectura.md](../diagramas/arquitectura.md).

**Debe explicarse:** las instancias conservan sus nombres iniciales, pero desde las pruebas E8 manager-g5, worker1-g5 y
worker2-g5 son managers de Swarm. worker1-g5 es el líder actual y solo worker3-g5 es un worker puro.

## 4. Fase 0: Codespaces y repositorio (F3, F4, F5, F7, F12)

| Figura | Archivo |
| --- | --- |
| Versiones del entorno | `CT/F5-entorno.png` |
| Estructura del repositorio | `CT/F4-estructura.png` |
| Scripts versionados | `CT/F7-scripts.png` |
| Archivos sensibles fuera de Git | `CT/F12-archivos-sensibles.png` |

**Demostrado:** entorno con AWS CLI y Terraform, estructura versionada y secretos excluidos de Git.

## 5. Fase 1: Infraestructura (F6, A1–A6)

| Figura o registro | Archivo |
| --- | --- |
| Módulo y `terraform validate` | `CT/A1-modulo-terraform.png` |
| Código de las instancias | `CT/F6-codigo-instancias.png` |
| Plan y apply iniciales | `prototipo/reto4-plan-cidr.log`, `prototipo/reto4-apply.log` |
| Instancias y controles, por terminal | `CT/A2-instancias.png` |
| Instancias en la consola | `[USUARIO 1]` EC2 → Instances |
| Reglas de entrada, por terminal | `CT/A3-grupo-seguridad.png` |
| Reglas de entrada en la consola | `[USUARIO 3]` Security Groups → `reto4-cloud-g5` → Inbound rules |
| Arranque por nodo | `CT/A4-arranque.png` |
| Salida `nodes` | `CT/A5-salida-nodes.png` |
| Cambio A6 | `A6-plan-final.txt`, `A6-apply.txt`, `CT/A6-sin-cambios.png` |
| Etiqueta en la consola | `[USUARIO 2]` Instancia manager-g5 → Tags |

**Demostrado:**

- Apply inicial con 5 recursos creados.
- Un manager t3.medium y tres workers t3.small, con cloud-init completado, zona Europe/Madrid y Docker 29.1.3.
- SSH externo limitado a una IP `/32`, HTTP 80 y 8080 públicos, y puertos de Swarm e ICMP limitados al propio grupo.
- Cambio A6: 0 altas, 1 cambio, 0 destrucciones. Solo añade `PruebaA6=reto4-g5` a manager-g5, y el plan posterior no
  propone cambios.

**No demostrado:** la destrucción con Terraform, que no se ha ejecutado. Hasta entonces, indicar que A6 está parcial.

## 6. Fase 2: SSH (B1–B5)

| Figura | Archivo |
| --- | --- |
| Claves autorizadas | `CT/B1-claves-autorizadas.png` |
| Alias y conexión | `CT/B2-alias.png` |
| Comandos simultáneos y sudo | `CT/B3-simultaneo-sudo.png` |
| Copia SCP con SHA-256 | `CT/B3-copia-scp.png` |
| Configuración de sshd y permisos | `CT/B4-endurecimiento.png` |
| Salto por el manager | `CT/B5-salto.png` |

**Demostrado:** alias, salto a IP privadas, sudo, copia con SHA-256 coincidente, root y contraseña desactivados, y
permisos 700/600.

**No demostrado:** claves individuales. Solo constan `vockey` y la clave del Codespace.

## 7. Fase 3: Docker Swarm (C1–C4)

| Figura o registro | Archivo |
| --- | --- |
| Docker y ping por IP privada | `CT/C1-docker-ping.png` |
| Direcciones de Swarm y red `red-g5` | `CT/C2-red-ingress.png` |
| Nodos | `CT/C3-nodos.png` |
| Red `red-app-g5` | `CT/C4-red-aplicacion.png` |
| Formación inicial | `prototipo/fase2-3.txt` |

**Demostrado:** Swarm por IP privada, cuatro nodos Ready/Active y dos redes overlay con MTU 1450.

**Nota para C2:** Swarm informa `estado=0.0.0.0` para el líder. Su dirección privada aparece en `manager=`.

## 8. Fase 4: Web e imágenes (F3, D1–D3)

| Figura o registro | Archivo |
| --- | --- |
| Construcción y prueba | `D1-imagenes-definitivas.txt`, `D1-navegador-registro.txt` |
| Publicación y descarga | `D1-publicacion-dockerhub.txt`, `D1-descarga-dockerhub.txt` |
| Etiquetas en Docker Hub | `D1-dockerhub-etiquetas.png`, `CT/D1-imagenes.png` |
| Pila y servicio | `CT/D2-pila-servicio.png` |
| Despliegue | `F3-despliegue/registro.txt` |
| Web por IP, con la dirección visible | `D3-navegador-manager-g5.png`, `D3-navegador-worker1-g5.png`, `D3-navegador-worker2-g5.png`, `D3-navegador-worker3-g5.png` |
| Portada completa | `F3-web-final-1.0-completa.png` |

**Demostrado:**

- Etiquetas 1.0 (`sha256:622d8343…`) y 2.0 (`sha256:1736eda0…`) publicadas, descargadas sin sesión en los tres workers
  y con el digest y el contenido de lo construido.
- Despliegue progresivo a 4/4, HTTP 200 y Chromium sin errores en las cuatro IP. Sondas: 328 correctas, 0 fallos.

**Límite:** las capturas D3 usan Chromium gráfico en un escritorio virtual del Codespace. Falta confirmar que el profesor
las acepta. Si exige otro equipo, sustituirlas por capturas de ese equipo.

**Límite de la web:** los enlaces `#` de Bilbao y de los avisos legales no tienen destino, y los formularios son de
demostración y no envían datos.

## 9. Fase 5: Orquestación (E1–E8)

Indicar el contexto de cada prueba. Las de la web definitiva son las principales.

| Prueba | Contexto | Resultado demostrado | Figuras y registros |
| --- | --- | --- | --- |
| E1 Balanceo | Definitiva | 16 peticiones por las cuatro IP, respondidas por cuatro contenedores | `CT/E1-reparto-peticiones.png` |
| E2 Escalado | Definitiva | 8/8 (2-2-2-2), 12/12 (3-3-3-3), 2/2 y 4/4 (1-1-1-1), con HTTP 200 tras cada estado. Sondas: 562 correctas y dos tiempos de espera aislados durante la reducción de 12 a 2 réplicas, de causa no determinada | `F4-E2/registro.txt`, `F4-E2/terminal-e2-*.png` |
| E3 Autorreparación | Definitiva | Contenedor eliminado (`exit 137`), tarea de reemplazo en el mismo nodo y vuelta a 4/4. Sondas: 308 correctas, 0 fallos | `F4-E3/registro.txt`, `F4-E3/terminal-e3-*.png` |
| E4 Caída de un worker. **Parcial** | Provisional | worker3-g5 detenido y `Down`, tarea reubicada y reincorporación. Sondas: 164 correctas, 0 fallos en el tramo medido | `E4-E5-E8-registro.txt`, `prototipo/E4-E5-http.txt`, `E4-web-worker-down.png` |
| E5 Reinicio de Learner Lab | Entorno | Mismas instancias y volúmenes raíz; SSH, cuórum, redes, 4/4 y HTTP correctos | `E5-verificacion-previa.txt`, `E5-verificacion-final.txt` |
| E6 Drain | Definitiva | worker3-g5 en Drain, tarea migrada a worker2-g5, vuelta a Active y `--force` con una réplica por nodo. Sondas: 488 correctas, 0 fallos | `F4-E6/registro.txt`, `F4-E6/terminal-e6-*.png` |
| E7 Actualización y rollback | Definitiva | 1.0 → 2.0 → 1.0, siempre en 4/4 al terminar. Sondas: 620 correctas, 0 fallos | `F3-actualizacion/registro.txt`, `F3-actualizacion/web-*.png`, `CT/E7-historial-versiones.png` |
| E8 Elección de líder. **Parcial** | Provisional | Comparando antes y después: worker2-g5 pasa a líder y manager-g5 vuelve como Reachable. Sondas: 38 y 130 correctas, con 34 segundos sin muestras. Sin registro del clúster durante la parada | `E8-eleccion-registro.txt`, `E8-web-parada.png`, `E8-web-recuperado.png` |

**Notas:**

- `CT/E7-historial-versiones.png` es el historial de tareas, tomado después de la prueba.
- El registro de E2 termina en `exit=1` porque entonces el script trataba cualquier fallo de sonda como error.
- E4 y E8 no se repitieron con la web definitiva, y sus capturas de consola no existen. [Análisis](../evidencias/auditoria/E4-E8.md).

## 10. Seguridad (F12, A3, B4)

Reúne secretos fuera de Git, reglas del grupo de seguridad, endurecimiento de SSH y revisión de secretos antes de cada
subida. Figuras ya citadas: `CT/F12-archivos-sensibles.png`, `CT/A3-grupo-seguridad.png` y `CT/B4-endurecimiento.png`.

**Debe indicarse:** la regla del puerto 8080 está abierta y la pila solo publica el 80. Contrastar con la Guía.

## 11. Incidencias y soluciones

Solo incidencias reales. La causa se indica únicamente cuando consta.

| Incidencia | Solución o estado | Evidencia |
| --- | --- | --- |
| La primera configuración de red se detuvo en la confirmación de Docker | Se corrigió el script | [PROYECTO](../PROYECTO.md), `prototipo/fase2-3.txt` |
| Credenciales de AWS rechazadas tras reiniciar Learner Lab (`voc-cancel-cred`) | Se renovaron las credenciales y se completó E5 | `E5-verificacion-posterior.txt`, `E5-verificacion-final.txt` |
| Cuatro páginas enlazaban a un destino inexistente (`#escuderias`) | Se añadió el destino y un validador de enlaces | Commit `bcfceee` |
| Docker no puede ejecutarse en el Codespace | Las imágenes se construyeron en manager-g5 | `D1-imagenes-definitivas.txt` |
| Docker Hub rechazó el primer token (`insufficient scopes`) | Se volvió a iniciar sesión y se publicó | `D1-publicacion-intento-fallido.txt`, `D1-publicacion-dockerhub.txt` |
| La regla SSH y los valores de `ssh_cidr` no coincidían al preparar A6 | Se usó la IP actual y se alineó el código, sin cambiar la regla | `A6-plan-actual.txt`, `A6-plan-final.txt` |
| Portal provisional y web definitiva responden ambos `version=1.0` | La verificación comprueba la imagen de cada tarea | `F3-despliegue/registro.txt` |
| Reparto desigual tras el despliegue y el rollback | E6 terminó con una réplica por nodo | `F3-estado-final.txt`, `F4-E6/registro.txt` |
| Dos tiempos de espera aislados en E2 | Causa no determinada. Criterio de supervisión para E3 y E6 | `F4-E2/registro.txt` |
| AWS y la web dejaron de responder a las 11:07 UTC, y la IP del Codespace cambió | Sin resolver | `auditoria/registro-acceso-en-vivo.txt` |

## 12. Conclusiones y reflexión

Conclusiones técnicas y reflexión del grupo: `[POR COMPLETAR por el grupo]`.

## Anexos

- [Índice de evidencias por criterio](../evidencias/INDICE.md) y [capturas de terminal](../evidencias/capturas-terminal/INDICE.md).
- [Matriz de criterios](../REVISION.md).
- Prácticas individuales: [`practica-individual/`](../practica-individual/README.md), `[POR COMPLETAR]`.
