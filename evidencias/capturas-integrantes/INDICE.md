# Capturas de los integrantes

Capturas hechas por los propios integrantes. Cristina las facilitó el 9 de noviembre de 2026 en un documento Word, que no se versiona,
con el nombre de cada uno sobre su imagen. Se copiaron sin modificar: tienen el mismo SHA-256 que las imágenes del documento.

## Estado de B1 por integrante y nodo

Acceso con la clave propia de cada integrante, según su captura y según el registro `/var/log/auth.log` del nodo.

| Integrante | manager-g5 | worker1-g5 | worker2-g5 | worker3-g5 |
| --- | --- | --- | --- | --- |
| Cristina | **Demostrado** | **Demostrado** | **Demostrado** | **Demostrado** |
| Enrique | **Demostrado** | Pendiente | Pendiente | Pendiente |
| Alexandra | **Demostrado** | Pendiente | Pendiente | Pendiente |
| Ibai | **Demostrado** | Pendiente | Pendiente | Pendiente |

«Demostrado» significa que hay captura del integrante y que el nodo registra un acceso aceptado con la huella de su clave. «Pendiente»
significa que el nodo no registra ningún acceso con esa clave. Comprobado el 9 de noviembre a las 10:42 UTC.

Registros de los nodos: [B1-registro-manager](../capturas-conformes/B1-registro-manager.png), con los cuatro integrantes;
[B1-registro-cristina](../capturas-conformes/B1-registro-cristina.png), con los cuatro nodos; y [registro de B1](../auditoria/registro-2026-11-09-b1.txt).

## Capturas

| Captura | Integrante | Qué muestra | Hora en la captura (Madrid) | Registro del nodo (Madrid) |
| --- | --- | --- | --- | --- |
| [B1-acceso-enrique](B1-acceso-enrique.png) | Enrique | `ssh -i` con `enrique_reto4`, aceptación de la huella de manager-g5 (`SHA256:N1I1Ui…`), frase de paso, y `whoami`, `hostname` y `date -Is` en manager-g5 | 10:35:26 | manager-g5, 10:34:22, `SHA256:qDmJbNSo…` |
| [B1-acceso-alexandra](B1-acceso-alexandra.png) | Alexandra | `ssh -i` con `alexandra_reto4`, frase de paso y las mismas órdenes en manager-g5 | 10:37:03 | manager-g5, 10:36:44, `SHA256:FJm/tkGx…` |
| [B1-acceso-ibai](B1-acceso-ibai.png) | Ibai | `ssh -i` con `ibai_reto4`, frase de paso y las mismas órdenes en manager-g5 | 10:37:45 | manager-g5, 10:37:41, `SHA256:zYEmGi4u…` |
| [B1-cristina-config-ruta](B1-cristina-config-ruta.png) | Cristina | `Test-Path` del archivo `config` de SSH en su perfil: `True` | — | — |
| [B1-cristina-config-alias](B1-cristina-config-alias.png) | Cristina | `ssh -G manager-g5`: el alias resuelve `107.23.128.135` y `identityfile ~/.ssh/cristina_reto4` | — | — |
| [B1-acceso-cristina-manager](B1-acceso-cristina-manager.png) | Cristina | `ssh manager-g5` con el alias, frase de paso de `cristina_reto4`, y `whoami`, `hostname` y `date -Is` | 11:36:24 | manager-g5, 11:36:09, `SHA256:CCR0qvMq…` |
| [B1-acceso-cristina-worker1](B1-acceso-cristina-worker1.png) | Cristina | `ssh worker1-g5` por salto, aceptación de la huella `SHA256:2j/3XgX7…`, y las mismas órdenes en worker1-g5 | 11:37:38 | worker1-g5, 11:37:36, desde la IP privada del manager |
| [B1-acceso-cristina-worker2](B1-acceso-cristina-worker2.png) | Cristina | `ssh worker2-g5` por salto, huella `SHA256:j6Yx2EXL…`, y las mismas órdenes | 11:38:31 | worker2-g5, 11:38:23, desde la IP privada del manager |
| [B1-acceso-cristina-worker3](B1-acceso-cristina-worker3.png) | Cristina | `ssh worker3-g5` por salto, huella `SHA256:TI7cmQM8…`, y las mismas órdenes | 11:39:31 | worker3-g5, 11:39:16, desde la IP privada del manager |

Las tres huellas de servidor que aceptó Cristina en los workers coinciden con las leídas en los propios nodos.

## Límites

- **Norma de capturas.** Todas muestran el prompt con el hostname, y la fecha y hora solo por la salida de `date -Is`. Ninguna incluye el
  comentario con la prueba, el resultado y el autor. El nombre del autor solo figura en el documento Word.
- **Equipo.** Las capturas de los cuatro integrantes usan el mismo perfil de Windows, `C:\Users\Alumno` o `C:\Users\alumno`, y no
  permiten saber si se usó un solo equipo o varios del aula con el mismo usuario. Cada clave está protegida con frase de paso.
- **Accesos sin captura.** El registro de manager-g5 contiene además dos accesos con la clave de Cristina, a las 11:23:50 y a las 11:32:16,
  que no aparecen en ninguna captura.
