# Auditoría técnica de solo lectura

Realizada por Claude Code el 5 de noviembre de 2026 y repetida en vivo el 6 de noviembre. No se ha modificado Swarm ni Terraform. En AWS, los únicos cambios son las dos sustituciones autorizadas de la regla SSH del 6 de noviembre.

> **Informe histórico del 5 y 6 de noviembre.** Algunas conclusiones han cambiado después: las claves personales se instalaron el 9 de
> noviembre, la topología de C3 se corrigió ese mismo día, el estado de Terraform se sincronizó el 10 de noviembre y todo el proyecto
> está en `main` desde el 18. El estado vigente está en [REVISION.md](../../REVISION.md) y en [PROYECTO.md](../../PROYECTO.md).

## Repetición en vivo: 6 de noviembre de 2026

Con el laboratorio activo y las credenciales renovadas, entre las 09:14 y las 09:19 UTC. [Registro completo](registro-2026-11-06.txt).

| Requisito | Observado | Resultado |
| --- | --- | --- |
| EC2 | Cuatro instancias con los tipos esperados, en ejecución y con controles `ok` | Cumple |
| Grupo de seguridad | SSH desde una IP `/32` y el propio grupo; 80 y 8080 públicos; Swarm e ICMP solo entre nodos; salida general | Cumple |
| SSH | Sin root ni contraseña, permisos 700 y 600, sudo y salto por el manager en los cuatro nodos | Cumple |
| SSH: claves individuales | Solo `vockey` y la clave del Codespace | **No cumple todavía** |
| Swarm: nodos | Cuatro Ready/Active, por IP privada | Cumple |
| Swarm: topología | Tres managers, con `manager-g5` de líder | **No coincide** |
| Redes | `red-g5` y `red-app-g5` declaran MTU 1450; sus interfaces miden 1400 dentro de los contenedores | Cumple en la configuración de la red. Falta aclarar qué pide la Guía |
| Servicio | 4/4, `innnx/reto4-f1:1.0` con el digest publicado, una réplica por nodo | Cumple |
| Web | HTTP 200 por el puerto 80 en las cuatro IP. El 8080 está abierto, pero nada responde en él | Cumple |
| Imágenes | Etiquetas 1.0 y 2.0 con los digests publicados | Cumple |
| Estado de Terraform | ID, AMI, tipo, disco, etiquetas, grupo y cuenta coinciden con AWS. Archivos sin modificar: mismo SHA-256 | Corresponde a los recursos actuales |
| Plan de Terraform | Ninguna acción sobre recursos. Solo cambiarían las salidas, por las IP públicas (código de salida 2) | Cumple en los recursos. Las salidas no están sincronizadas |
| Secretos | 0 coincidencias en los commits pendientes de `main` | Cumple |

**Después de la comprobación.** A las 10:27 UTC, la IP del Codespace había cambiado a `172.166.151.115`, mientras la regla seguía en `172.166.156.104/32`, y el SSH agotaba el tiempo de espera. A las 10:50 UTC, con nueva autorización, se añadió la regla de la IP nueva, se comprobó SSH en los cuatro nodos y se retiró la antigua. Después, nodos, servicio, redes y plan dieron los mismos resultados, y los archivos de estado de Terraform siguen sin cambios.

El resto de este informe corresponde a la auditoría del 5 de noviembre.

## Resultado

**Los requisitos auditados cumplen lo esperado según los registros de las 09:52–09:56 UTC. No se han podido comprobar en
vivo después**, porque el laboratorio dejó de responder. Hay que repetir la comprobación cuando vuelva a estar disponible.

| Fuente | Qué aporta | Hora (UTC) |
| --- | --- | --- |
| [Capturas de terminal](../capturas-terminal/INDICE.md) | Estado real de reglas, SSH, Swarm, redes e imágenes | 09:52–09:56 |
| [Registro de acceso](registro-acceso-en-vivo.txt) | Intento en vivo: AWS denegado y web sin respuesta | 11:13 |
| [Registro de Terraform](registro-terraform.txt) | Código válido; el plan no pudo ejecutarse por la denegación | 11:08 |
| [Registro del repositorio](registro-repositorio.txt) | GitHub, ramas e historial completo | 11:09 |

## Intento de comprobación en vivo (11:07–11:13 UTC)

| Comprobación | Resultado |
| --- | --- |
| EC2 y grupos de seguridad por API | `UnauthorizedOperation` con denegación explícita. La identidad sigue respondiendo |
| HTTP por las cuatro IP de la última comprobación | Sin respuesta (`000`) |
| SSH a manager-g5 | Tiempo de espera agotado |
| Conectividad del Codespace | Correcta: Docker Hub responde |
| Docker Hub | Etiquetas 1.0 y 2.0 disponibles, con los digests publicados |

**Interpretación.** Las credenciales locales son de las 07:17 UTC y la misma denegación apareció tras el anterior reinicio
de Learner Lab. Lo más probable es que la sesión del laboratorio haya terminado, pero sin acceso a la API no se puede
confirmar. **Se desconoce el estado actual de las instancias.**

**Además, cambió la IP de salida del Codespace.** Era `172.166.156.160`, la permitida por la regla SSH, y ahora es
`172.166.151.121`. Aunque el laboratorio vuelva, el SSH desde este Codespace seguirá bloqueado hasta actualizar esa regla, lo
que es un cambio en AWS y requiere autorización.

## Requisitos técnicos

| Requisito | Esperado | Observado | Fuente | Resultado |
| --- | --- | --- | --- | --- |
| SSH externo | Una sola IP `/32` | `172.166.156.160/32` | [A3](../capturas-terminal/A3-grupo-seguridad.png) | Cumple. La IP permitida ya no es la actual del Codespace |
| SSH entre nodos | Propio grupo | Grupo `sg-0c12ecd538a29f8d6` | [A3](../capturas-terminal/A3-grupo-seguridad.png) | Cumple |
| HTTP | TCP 80 público | `0.0.0.0/0` | [A3](../capturas-terminal/A3-grupo-seguridad.png) | Cumple |
| Puerto 8080 | Abierto desde Internet, según la Guía | Público, y la pila no publica nada en él | [A3](../capturas-terminal/A3-grupo-seguridad.png), [D2](../capturas-terminal/D2-pila-servicio.png) | Cumple |
| Swarm: 2377/TCP | Propio grupo | Grupo propio | [A3](../capturas-terminal/A3-grupo-seguridad.png) | Cumple |
| Swarm: 7946/TCP y UDP | Propio grupo | Grupo propio | [A3](../capturas-terminal/A3-grupo-seguridad.png) | Cumple |
| Swarm: 4789/UDP | Propio grupo | Grupo propio | [A3](../capturas-terminal/A3-grupo-seguridad.png) | Cumple |
| ICMP | Propio grupo | Grupo propio | [A3](../capturas-terminal/A3-grupo-seguridad.png) | Cumple |
| MTU de `red-g5` | Overlay, ingress, 1450 | `overlay`, `ingress=true`, `MTU=1450` | [C2](../capturas-terminal/C2-red-ingress.png) | Cumple en la configuración de la red |
| MTU de `red-app-g5` | Overlay, 1450 | `overlay`, `ingress=false`, `MTU=1450` | [C4](../capturas-terminal/C4-red-aplicacion.png) | Cumple en la configuración de la red |
| SSH: root y contraseña | Desactivados | `permitrootlogin no`, `passwordauthentication no` en los 4 nodos | [B4](../capturas-terminal/B4-endurecimiento.png) | Cumple |
| SSH: permisos | 700 y 600 | 700 y 600 en los 4 nodos y en la clave local | [B4](../capturas-terminal/B4-endurecimiento.png) | Cumple |
| SSH: salto | ProxyJump por el manager | `proxyjump manager-g5` e IP privadas | [B5](../capturas-terminal/B5-salto.png) | Cumple |
| SSH: claves individuales | Una por integrante | Solo `vockey` y la clave del Codespace | [B1](../capturas-terminal/B1-claves-autorizadas.png) | **No cumple todavía** |
| Swarm: direcciones | IP privadas | 172.31.x.x en los cuatro nodos | [C2](../capturas-terminal/C2-red-ingress.png) | Cumple |
| Swarm: nodos | Cuatro Ready/Active | Cuatro Ready/Active | [estado final](../capturas-terminal/estado-final.png) | Cumple |
| Swarm: topología | Manager líder y tres workers | Tres managers, con worker1-g5 de líder | [C3](../capturas-terminal/C3-nodos.png) | **No coincide**: estado posterior a E8 |
| Servicio | 4/4 con la imagen publicada | 4/4, `innnx/reto4-f1:1.0`, una réplica por nodo | [estado final](../capturas-terminal/estado-final.png) | Cumple |
| Imágenes | Etiquetas 1.0 y 2.0 | Publicadas, y con el digest esperado también a las 11:13 UTC | [D1](../capturas-terminal/D1-imagenes.png), [acceso](registro-acceso-en-vivo.txt) | Cumple |
| Terraform | Válido y sin cambios | `validate` y `fmt` correctos; plan sin cambios a las 09:52 UTC | [A6](../capturas-terminal/A6-sin-cambios.png), [registro](registro-terraform.txt) | Cumple en la última comprobación posible |

**Límite sobre la MTU.** Se ha comprobado la configuración de las redes con `docker network inspect`, no la interfaz dentro
de un contenedor en ejecución.

**Reglas de salida.** `terraform/main.tf` declara salida general. Las capturas de la auditoría no muestran esas reglas.

## Repositorio y seguridad

| Aspecto | Resultado |
| --- | --- |
| Visibilidad | Privado. Falta confirmar el acceso del profesor |
| Ramas | `main` y `cloud-g5-implementacion`. Ninguna está protegida. Cambiarlo es una decisión del administrador |
| PR | #1 abierta en borrador, sin fusionar |
| Secretos en todo el historial | 65.272 líneas añadidas revisadas: ninguna credencial. Dos falsos positivos explicados en el [registro](registro-repositorio.txt) |
| Archivos sensibles en cualquier commit | Ninguno. Solo aparece `terraform/grupo.example.tfvars`, una plantilla sin datos |
| Credenciales en la web, con su historial | Ninguna |
| Funciones de seguridad de GitHub y protección de ramas | No se pueden consultar con el token del Codespace. Hay que verlas en Settings |
| Licencia | No consta, y ni la Guía ni la Rúbrica la piden |

**Dos correcciones hechas durante esta auditoría.** El primer registro de AWS contenía el identificador de la cuenta dentro de
los mensajes de error. Se detectó antes de subirlo y se sustituyó por uno enmascarado. Además, el repositorio contiene IP
públicas del laboratorio y del Codespace: no son secretos, pero conviene tenerlo en cuenta si algún día deja de ser privado.

## Contraste

El resultado frente a los originales está en el [contraste con la Guía y la Rúbrica](../../entrega/CONTRASTE-GUIA-RUBRICA.md). Ahí se recoge también que
ninguna captura de terminal cumple la norma del prompt.

## E4 y E8

El análisis detallado está en [E4-E8.md](E4-E8.md).
