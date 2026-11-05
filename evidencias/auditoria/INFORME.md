# Auditoría técnica de solo lectura

Realizada por Claude Code el 5 de noviembre de 2026. No se ha modificado AWS, Swarm ni Terraform.

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
| Puerto 8080 | Según la Guía | Público y sin servicio publicado | [A3](../capturas-terminal/A3-grupo-seguridad.png), [D2](../capturas-terminal/D2-pila-servicio.png) | Por contrastar |
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
| Swarm: topología | Según la Guía | Tres managers y un worker | [C3](../capturas-terminal/C3-nodos.png) | Por contrastar |
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
| Licencia | No consta. Decidir si la Guía la pide |

**Dos correcciones hechas durante esta auditoría.** El primer registro de AWS contenía el identificador de la cuenta dentro de
los mensajes de error. Se detectó antes de subirlo y se sustituyó por uno enmascarado. Además, el repositorio contiene IP
públicas del laboratorio y del Codespace: no son secretos, pero conviene tenerlo en cuenta si algún día deja de ser privado.

## E4 y E8

El análisis detallado está en [E4-E8.md](E4-E8.md).
