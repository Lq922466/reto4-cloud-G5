# Revisión de seguridad — Ibai (borrador para validación)

**Responsable asignado:** Ibai (ibaiaretxabalaasir-collab)  
**Preparación documental:** ChatGPT, por encargo de Cristina, 09/11/2026  
**Estado:** pendiente de validación personal de Ibai.

## Objetivo

Comprobar la configuración de seguridad del repositorio, el acceso SSH y las reglas de red del RETO 4 CLOUD G5.

## Procedimiento

Se han leído [`.gitignore`](../.gitignore), [`config/sshd_00-reto4.conf`](../config/sshd_00-reto4.conf), [el README](../README.md) y los registros técnicos. No se han ejecutado nuevas operaciones en AWS ni un escaneo completo del historial.

## Comprobaciones

| Elemento | Resultado documental |
| --- | --- |
| `.gitignore` | Excluye estados y variables sensibles de Terraform, claves privadas y credenciales |
| Claves públicas | Permite versionar únicamente `terraform/claves/*.pub` en esa carpeta |
| `PermitRootLogin no` | Configurado en plantilla SSH |
| `PasswordAuthentication no` | Configurado en plantilla SSH |
| `KbdInteractiveAuthentication no` | Configurado en plantilla SSH |
| Accesos por clave | Registros de claves autorizadas en cuatro nodos |
| Red privada | Uso de IP privadas para la comunicación entre nodos según registros |
| Escaneo de secretos | Revisiones anteriores registradas; falta comprobación posterior a los últimos cambios |

## Incidencias técnicas detectadas

| Incidencia | Importancia | Solución |
| --- | --- | --- |
| Regla SSH temporal `88.14.93.201/32` | Media, si ya no es necesaria | Verificar acceso actual y retirarla con autorización |
| Permanencia de `vockey` como acceso de reserva | Pendiente de aclaración normativa, no vulnerabilidad confirmada | Confirmar con el profesor si debe conservarse o sustituirse; evitar pérdida de acceso |
| Comprobación efectiva de `sshd` y permisos | Verificación pendiente, no fallo demostrado | Revisar `sshd -T` y permisos reales de forma no destructiva |

**No se ha detectado una filtración de claves privadas en los archivos consultados.** Esto no sustituye un análisis del historial completo. No se presentan como fallos de seguridad confirmados las verificaciones todavía no realizadas.

## Resultado y conclusión

La configuración publicada incluye medidas de protección apropiadas. El punto operativo a revisar es la regla SSH temporal, junto con la política de acceso de reserva. Documento preparado con ChatGPT por encargo de Cristina y pendiente de confirmación personal de Ibai.
