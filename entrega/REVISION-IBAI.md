# Revisión de seguridad — Ibai (borrador para validación)

**Responsable asignado:** Ibai (ibaiaretxabalaasir-collab)  
**Preparación documental:** ChatGPT, por encargo de Cristina, 09/11/2026  
**Estado:** comprobación de archivos publicados; pendiente de validación personal de Ibai y revisión del historial completo.

## Objetivo

Comprobar que el repositorio y la configuración SSH aplican las medidas básicas de seguridad del RETO 4 CLOUD G5 sin publicar credenciales ni claves privadas.

## Procedimiento

Se han leído los archivos publicados [`.gitignore`](../.gitignore), [`config/sshd_00-reto4.conf`](../config/sshd_00-reto4.conf), [el README](../README.md) y los registros de evidencias. No se ha accedido a secretos ni se ha ejecutado un nuevo escaneo de todo el historial.

## Comprobaciones

| Elemento | Comprobación | Resultado |
| --- | --- | --- |
| `.gitignore` | Excluye `*.tfstate`, planes, `*.tfvars`, `*.pem`, `*.ppk`, `*.key`, `.aws/`, `.ssh/`, `credentials` y `*_reto4` | CORRECTO en el archivo consultado |
| Claves públicas | Se permite publicar `terraform/claves/*.pub`, como requiere la Guía | Configuración prevista; comprobar listado final |
| SSH root | `PermitRootLogin no` | CORRECTO en plantilla |
| SSH contraseña | `PasswordAuthentication no` | CORRECTO en plantilla |
| SSH teclado interactivo | `KbdInteractiveAuthentication no` | CORRECTO en plantilla |
| SSH aplicado | La plantilla indica aplicación en los cuatro nodos | Consta evidencia histórica; comprobar estado real con `sshd -T` |
| Security Group | Puertos internos restringidos al grupo y SSH a origen autorizado según configuración | Revisar estado actual en AWS Console |
| Regla SSH temporal | Consta `88.14.93.201/32` en los registros de revisión | Pendiente de retirar con autorización si ya no se necesita |
| `vockey` | Se conserva como acceso de reserva | Discrepancia entre Guía y Rúbrica; consultar al profesor |
| Escaneo de secretos | El repositorio documenta escaneos previos sin hallazgos | Repetir tras los commits recientes; no afirmar ausencia total sin comprobar |

## Incidencias y acciones pendientes

1. **Un `.gitignore` correcto no elimina secretos que se hayan publicado anteriormente.** Ejecutar `python3 scripts/revisar-secretos.py origin/main HEAD` y revisar el historial antes de la entrega.
2. Verificar en AWS las reglas reales del Security Group y decidir con Cristina la retirada de la regla temporal, sin perder acceso SSH.
3. Confirmar los permisos reales de `~/.ssh`, el estado efectivo de `sshd` y las claves autorizadas sin mostrar privadas.
4. No publicar archivos `terraform.tfstate`, `terraform.tfvars`, credenciales AWS ni tokens.

## Resultado y conclusión

Los archivos de configuración publicados contienen controles de seguridad adecuados, pero queda pendiente verificar el estado efectivo de AWS y SSH y repetir el escaneo final. **Este borrador lo ha preparado ChatGPT por encargo de Cristina; Ibai debe revisar y confirmar personalmente su contenido antes de presentarlo como trabajo propio.**
