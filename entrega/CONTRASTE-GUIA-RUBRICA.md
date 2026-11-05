# Contraste con la Guía y la Rúbrica originales

Revisión del 5 de noviembre de 2026 de los 42 criterios contra los documentos originales del profesor. Los originales se conservan fuera del
repositorio y no están en ningún commit. Este documento los resume con palabras propias.

## Conclusión

**El trabajo técnico está muy avanzado, pero la entrega todavía no cumple la Rúbrica.** Hay cuatro motivos principales:

1. **Todo debe funcionar durante la corrección.** Cada requisito puntúa solo si funciona ese día y tiene su captura y sus archivos. Ahora el
   laboratorio no responde.
2. **Las capturas no cumplen la norma.** Ninguna captura de terminal muestra el prompt con el hostname, y casi ninguna tiene su comentario con
   la prueba, el resultado y el autor.
3. **Falta el trabajo de grupo.** Sin commits y PR de todos, sin reparto ni prácticas individuales, y sin la defensa (2 puntos).
4. **El estado final se aparta de la Guía.** Hay tres managers con worker1-g5 de líder, y se pide manager líder y tres workers. Además, `vockey`
   sigue activa y solo hay una clave propia.

| Situación | Nº | Criterios |
| --- | --- | --- |
| **Listo** | 10 | A1, D1, D2, F3–F8, F12 |
| **Demostrado, falta captura conforme** | 17 | A2–A5, B3–B5, C1, C2, C4, D3, E1–E3, E5–E7 |
| **Parcial** | 11 | A6, B1, B2, C3, E4, E8, F1, F2, F9, F10, F11 |
| **Pendiente** | 4 | F13, G1, G2, G3 |

**Actualización.** Tras las mejoras locales, A1, F5 y F7 están listos, y B2 solo espera comprobar la conexión. Hay 11 capturas conformes generadas. Los requisitos exactos están en [REVISION.md](../REVISION.md) y en la [checklist](CHECKLIST-FINAL.md).

**Orientación sobre 8 puntos, sin la defensa:** entre 4,8 y 6,8, con el laboratorio funcionando el día de la corrección. El mínimo cuenta como
parciales los 17 criterios sin captura conforme, y el máximo los acepta completos. Es solo una estimación: **la Rúbrica no indica cuánto vale
cada ítem dentro de su bloque**, así que supone un reparto igual.

## Qué cambia respecto a lo que suponíamos

| Lo que suponíamos | Lo que dicen los originales | Consecuencia |
| --- | --- | --- |
| Hacía falta un informe Word | Ninguno pide Word. F9 es `PROYECTO.md` | **El Word no es necesario.** Se puede generar si lo queréis, pero no puntúa |
| Trello y seguimiento semanal por completar | Ninguno los menciona. `GESTION.md` pide reparto, responsables y una breve reflexión | Son opcionales |
| No hacer demostraciones que detengan instancias | La exposición debe incluir **una demostración en directo de caída de un nodo** | Guion y presentación corregidos |
| El puerto 8080 sobraba | La Guía pide abrir 80 y 8080 | Correcto: se mantiene |
| Mis 29 criterios «completados» | Exigen además la captura según la norma | Pasan a 8 listos y 18 con captura por rehacer. F7 baja a parcial |
| `/practica-individual` sin definir | Documenta la práctica individual previa de EC2 con Ubuntu 22.04 | Más concreto: cada integrante debe tenerla ya hecha |
| Claves públicas fuera del repositorio | La Guía pide las claves públicas en `/terraform` | Hay que añadirlas |

## Diferencias entre la Guía y la Rúbrica

Conviene preguntarlas al profesor.

| Asunto | Guía | Rúbrica | Situación actual |
| --- | --- | --- | --- |
| `vockey` | Queda como reserva | Sustituida | Sigue autorizada |
| Puntos | Fases 1–5: 1,5 · 1 · 0,8 · 0,7 · 2 | Bloques A–E: 2 · 1 · 1 · 0,5 · 1,5 | Ambas suman 10 con repositorio y defensa |
| Estado de Swarm | Manager líder, y después una prueba promoviendo 2 workers | Manager líder y 3 workers (C3), y prueba de nuevo líder (E8) | Sigue el estado posterior a E8 |

**La Rúbrica también exige que A6 incluya la destrucción y que todo funcione durante la corrección.** Ambas cosas no pueden hacerse a la vez sobre el mismo clúster: hay que preguntar cuándo y cómo acreditarla.

## Revisión de los 42 criterios

**Quién:** *Claude* sin AWS · *Claude-lab*, solo lectura, con el laboratorio activo · *Claude-aut*, con tu autorización · *Tú* · *Grupo*.

### A · Terraform

| Criterio | Exige, en resumen | Situación | Qué falta | Quién |
| --- | --- | --- | --- | --- |
| A1 | Proyecto ordenado con variables | **Listo.** Incluye variables de disco, con los mismos valores | Confirmar con un plan que no hay cambios | Claude-lab |
| A2 | Manager y workers definidos una vez, con etiquetas | **Demostrado.** `count` en los workers | Captura de la consola de EC2 | Tú |
| A3 | Grupo de seguridad de mínimos | **Demostrado.** Coincide con la Guía. El 22 entre nodos es necesario para el salto | Captura de reglas en la consola | Tú |
| A4 | Arranque con hostname, zona, Docker y claves | **Demostrado.** Ya está la captura conforme del script | Captura conforme del log en los nodos | Claude-lab |
| A5 | Salidas con IP e ID | **Demostrado** | Captura conforme | Claude-lab |
| A6 | Validación, plan, cambio y destrucción | **Parcial.** Falta la destrucción y la secuencia en capturas | Decidir con el profesor. Capturar la secuencia | Tú, Claude-aut |

### B · SSH

| Criterio | Exige, en resumen | Situación | Qué falta | Quién |
| --- | --- | --- | --- | --- |
| B1 | Clave propia en los 4 nodos y `vockey` sustituida | **Parcial.** Solo una clave propia, `vockey` activa y ninguna clave en el repositorio | Claves de cada integrante en `/terraform` e instalarlas. Aclarar `vockey` | Grupo, Claude-aut |
| B2 | Config SSH con nombre corto | **Parcial.** `~/.ssh/config` y `/config` preparados. Falta probar la conexión real | Comprobar y capturar la conexión | Claude-lab |
| B3 | Control, órdenes simultáneas y copia | **Demostrado** | Captura conforme | Claude-lab |
| B4 | Sin contraseña ni root, y permisos | **Demostrado** | Captura conforme | Claude-lab |
| B5 | Workers por IP privada con salto | **Demostrado** | Captura conforme | Claude-lab |

### C · Swarm

| Criterio | Exige, en resumen | Situación | Qué falta | Quién |
| --- | --- | --- | --- | --- |
| C1 | Docker y ping por IP privada | **Demostrado** | Captura conforme | Claude-lab |
| C2 | Clúster por IP privada y MTU 1450 | **Demostrado** | Captura conforme | Claude-lab |
| C3 | 4 nodos, manager líder y 3 workers | **Parcial.** Hoy, tres managers con worker1-g5 de líder. El estado inicial solo consta en texto | Decidir si se restaura. Captura conforme | Tú, Claude-aut |
| C4 | Red overlay propia | **Demostrado** | Captura conforme | Claude-lab |

### D · Web

| Criterio | Exige, en resumen | Situación | Qué falta | Quién |
| --- | --- | --- | --- | --- |
| D1 | Imagen propia, con 1.0 y 2.0 | **Listo** | — | — |
| D2 | 4 réplicas, red del grupo y reinicio | **Listo** | — | — |
| D3 | Acceso por las 4 IP públicas | **Demostrado.** Las capturas muestran la dirección | Comentario y capturas con las IP del día | Claude-lab |

### E · Orquestación

La Guía pide capturas antes, durante y después, con un script consultando la web cada segundo.

| Criterio | Exige, en resumen | Situación | Qué falta | Quién |
| --- | --- | --- | --- | --- |
| E1 | Balanceo | **Demostrado** | Captura conforme | Claude-lab |
| E2 | Escalado a 8, 12 y 2 | **Demostrado.** Dos tiempos de espera aislados | Capturas conformes, repitiendo la prueba | Claude-aut |
| E3 | Autorreparación | **Demostrado** | Capturas conformes, repitiendo la prueba | Claude-aut |
| E4 | Caída de un worker, con script correcto | **Parcial.** Hay registro de `Down` y de la sonda, en texto y con el portal provisional | Repetir con la web definitiva y capturas | Claude-aut |
| E5 | Reincorporación, reequilibrio y reinicio del lab | **Demostrado** | Captura conforme, tras el próximo inicio del lab | Claude-lab |
| E6 | Drain | **Demostrado** | Capturas conformes, repitiendo la prueba | Claude-aut |
| E7 | Actualización sin corte y rollback | **Demostrado.** 620 respuestas sin fallos | Capturas conformes, repitiendo la prueba | Claude-aut |
| E8 | Nuevo líder, visto desde otro nodo | **Parcial.** Hay listado desde worker1-g5, en texto, sin estado durante la parada | Repetir con capturas | Claude-aut |

### F · Repositorio

| Criterio | Exige, en resumen | Situación | Qué falta | Quién |
| --- | --- | --- | --- | --- |
| F1 | Privado, colaboradores y profesor | **Parcial** | Confirmar integrantes e invitar al profesor | Tú |
| F2 | Commits repartidos y PR de los colaboradores | **Parcial.** Solo Innnx y Codex | Commits y PR reales de cada integrante | Grupo |
| F3 | README | **Listo** | — | — |
| F4 | Estructura | **Listo** en la rama. `main` solo tiene `.devcontainer` y `terraform` | Integrar la PR antes de la entrega | Tú |
| F5 | Devcontainer y capturas del Codespace | **Listo.** Captura conforme integrada en `PROYECTO.md` | Opcional: vista del Codespace en el navegador | Tú |
| F6 | Terraform funcional | **Listo** | — | — |
| F7 | Scripts comentados | **Listo.** Comentarios ampliados y `scripts/actualizar-ips.sh` | — | — |
| F8 | Mapa de arquitectura | **Listo** | — | — |
| F9 | `PROYECTO.md`, paso a paso | **Parcial.** Con los requisitos por fase y capturas conformes locales | Integrar las capturas restantes | Claude-lab |
| F10 | Capturas según la norma y comentadas | **Parcial.** 11 de 50 conformes, con el [procedimiento](PROCEDIMIENTO-CAPTURAS.md) | Generar las demás y las de consola | Claude-lab, Tú |
| F11 | Reparto, responsables y reflexión | **Parcial.** Borrador sin esos datos | Datos reales del grupo | Grupo |
| F12 | Sin credenciales, claves ni estado | **Listo.** Revisado todo el historial | Repetir antes de integrar | Claude |
| F13 | Práctica individual previa | **Pendiente** | Documentación real | Grupo |

### G · Exposición y defensa

| Criterio | Puntos | Exige, en resumen | Situación | Quién |
| --- | --- | --- | --- | --- |
| G1 | 0,5 | 10 minutos: arquitectura, código, reparto y caída de un nodo en directo | **Pendiente.** Material corregido | Grupo |
| G2 | 1 | 2 o 3 preguntas a cualquier miembro | **Pendiente.** Repaso preparado | Grupo |
| G3 | 0,5 | Demostración técnica individual en directo | **Pendiente.** Repaso preparado | Grupo |

## Sobre el autor de las capturas

La norma pide indicar el autor en cada captura. Muchas las tomaron Codex o Claude Code, y **no se deben presentar como si las hubiera hecho un
alumno**. Hay dos opciones honestas: indicar el autor real, o que cada integrante rehaga las suyas ejecutando él mismo los comandos, lo que además
ayuda con F2 y con la defensa. Conviene preguntar al profesor si admite capturas tomadas con asistentes.

## Plan propuesto

| # | Paso | Quién | Valor |
| --- | --- | --- | --- |
| 1 | Iniciar el laboratorio, renovar credenciales y actualizar la regla SSH | Tú, Claude-aut | Desbloquea casi todo lo técnico |
| 2 | Preguntar al profesor: `vockey`, topología final, destrucción de A6 y autoría de las capturas | Tú | Evita repetir trabajo |
| 3 | **Hecho:** `~/.ssh/config`, `/config`, comentarios, script de IP, variables de disco y procedimiento de capturas | Claude | B2, F7, A1 y F5 |
| 4 | Rehacer las capturas de solo lectura con prompt real y comentario, e integrarlas en `PROYECTO.md` | Claude-lab | F9, F10 y unos 12 criterios |
| 5 | Corregir C3 y repetir E4 y E8 según el [plan](PLAN-C3-E4-E8.md), y E2, E3, E6 y E7 con capturas conformes | Claude-aut | 6 criterios. También sirve de ensayo para la caída en directo |
| 6 | Instalar las claves públicas de cada integrante | Claude-aut | B1 |
| 7 | Trabajo de cada integrante: PR, `GESTION.md`, práctica y clave | Grupo | F2, F11, F13 y B1 |
| 8 | Capturas de consola y GitHub, e invitar al profesor | Tú | A2, A3, A6, F1, F5 y F10 |
| 9 | Ensayar la defensa con la caída en directo | Grupo | 2 puntos |
| 10 | Revisar secretos e integrar la PR en `main` | Tú, Claude-aut | F2 y F4 |
| 11 | Destrucción de A6, cuando se haya aclarado | Tú, Claude-aut | A6 |

**Importante para los pasos 5 y 11:** repetir pruebas detiene instancias o reinicia tareas, y `terraform destroy` elimina el clúster. Ninguno se hará sin tu autorización.

**Fecha de entrega:** no aparece en ninguno de los dos documentos. Hay que confirmarla, porque de ella depende cuántos pasos da tiempo a hacer.
