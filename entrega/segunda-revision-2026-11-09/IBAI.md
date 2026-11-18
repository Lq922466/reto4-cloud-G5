# Documentación individual — Ibai

Fecha: 9 de noviembre de 2026. Documento preparado por Codex a partir de archivos, historial y evidencias existentes; no es una declaración escrita por Ibai. La versión local recibida indicaba correcciones de Claude Code; esta sesión de Codex ha vuelto a contrastar los datos y corregir el documento. Las tareas asignadas no prueban autoría. «Verificado» significa contrastado documentalmente en esta revisión, no ejecutado de nuevo en AWS. Los resultados del laboratorio son históricos.

**Integrante:** Ibai. **Productos asignados:** 5 — Seguridad. **Cuenta:** ibaiaretxabalaasir-collab.

## Objetivo

Documentar sus evidencias personales Cloud sin atribuirle el endurecimiento que consta ejecutado con asistentes. No se dispone de los criterios originales del Producto 5.

## Procedimiento

Aportó clave pública y accedió al manager. Existen reglas de seguridad en Terraform y restricciones SSH en el proyecto, pero sus commits y registros no acreditan que las hiciera Ibai. No consta coordinación ejecutada con Ibai más allá de la planificación de GESTION.md.

### Comandos y configuraciones relevantes

Su captura muestra `ssh -i` con `ibai_reto4` hacia el manager, y `whoami`, `hostname`, `date -Is`. Configuración grupal relevante, sin atribuirle autoría: `PermitRootLogin no`, `PasswordAuthentication no`, `KbdInteractiveAuthentication no`; puertos Swarm e ICMP limitados al grupo.

## Evidencia

`evidencias/capturas-integrantes/B1-acceso-ibai.png` (solo local; pendiente de publicación), `evidencias/capturas-conformes/B1-registro-manager.txt` (solo local; pendiente de publicación), `terraform/claves/ibai_reto4.pub` (solo local; pendiente de publicación), [configuración SSH del grupo](../../config/sshd_00-reto4.conf).

### Contribuciones en GitHub y Pull Requests

La rama real es `ibai-revision-individual`; no se ha corroborado aquí la fecha ni la cuenta que creó la referencia remota. Su SHA remoto es `6f3d838`, igual que `main`, así que no contiene commits propios. A 9 de noviembre no consta PR de Ibai. Pendiente adelantar esa rama hasta `cloud-g5-implementacion`, aportar trabajo real desde su cuenta con Git Bash o WSL y abrir una PR hacia esa rama, como explican las `entrega/INSTRUCCIONES-F2-INTEGRANTES.md` (solo local; pendiente de publicación). No se ha creado ninguna rama en esta revisión.

## Resultado/Conclusión

Acceso al manager con clave propia corroborado. La captura fue inspeccionada visualmente en esta revisión: muestra hostname y fecha, pero falta comentario de prueba, resultado y autor. No se acredita acceso propio a workers ni implementación propia del Producto 5.

### Trabajo y capturas pendientes

Utilizar `ibai-revision-individual` y documentar su seguridad real con archivos, pruebas y guía original del Producto 5. Acceso personal a los workers, comentarios de capturas, práctica individual y reflexión. Mantener separadas las configuraciones del grupo de las realizadas por Ibai.

Las capturas adicionales de accesos se proponen para acreditar el uso de claves y el salto. Los originales no fijan un número de capturas por persona o nodo.

[Volver a la revisión](README.md).
