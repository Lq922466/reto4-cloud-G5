# Documentación individual — Enrique

Fecha: 9 de noviembre de 2026. Documento preparado por Codex a partir de archivos, historial y evidencias existentes; no es una declaración escrita por Enrique. La versión local recibida indicaba correcciones de Claude Code; esta sesión de Codex ha vuelto a contrastar los datos y corregir el documento. Las tareas asignadas no prueban autoría. «Verificado» significa contrastado documentalmente en esta revisión, no ejecutado de nuevo en AWS. Los resultados del laboratorio son históricos.

**Integrante:** Enrique. **Productos asignados:** 2 — Redes; 3 — IWEB. **Cuenta:** EnriZx2.

## Objetivo

Documentar su aportación comprobable a Cloud: revisión de enlaces y acceso SSH propio. Sus Productos 2 y 3 están asignados, pero sus requisitos no figuran en los originales Cloud.

## Procedimiento

- Creó `entrega/REVISION-ENRIQUE.md` en el commit `3a67659`, con revisión declarada de siete documentos enlazados desde README.
- Presentó la PR #2, posteriormente integrada por Cristina.
- Aportó una clave pública y consta acceso personal al manager. No consta acceso personal a los workers.
- Existe código web en `app/f1`, pero llegó como ZIP y el historial no demuestra quién lo desarrolló: no se adjudica a Enrique por su asignación de IWEB.

### Comandos y configuraciones relevantes

Su captura muestra `ssh -i` con `enrique_reto4` hacia `ubuntu@<IP_PUBLICA_MANAGER>`, y `whoami`, `hostname`, `date -Is`. La dirección de destino de la captura es histórica y aquí se representa con un marcador. No constan comandos personales de configuración de redes ni de construcción de la web.

## Evidencia

[Revisión original](../REVISION-ENRIQUE.md), `evidencias/capturas-integrantes/B1-acceso-enrique.png` (solo local; pendiente de publicación), `evidencias/capturas-conformes/B1-registro-manager.txt` (solo local; pendiente de publicación), `terraform/claves/enrique_reto4.pub` (solo local; pendiente de publicación).

### Contribuciones en GitHub y Pull Requests

Rama `enrique-revision-documentacion`, commit `3a67659e48bd4389097e4e9ffe54b58c3f0d209d`. [PR #2](https://github.com/Lq922466/reto4-cloud-G5/pull/2), autoría EnriZx2, destino `cloud-g5-implementacion`, fusionada el 6 de noviembre. Contribución propia y destino correctos. El *committer* del commit es `GitHub`; este dato no acredita contribución desde WSL o Git Bash, los ejemplos de terminal Linux indicados por la Guía para el resto del equipo. Su documento conserva la errata del corchete extra ante CORRECTO; se propone que Enrique la corrija en una aportación posterior con su identidad.

## Resultado/Conclusión

Commit y contenido de la PR comprobados; la aportación consiste en un documento de revisión, no en cambios de red ni en autoría demostrada de la web. Los siete documentos revisados existen. El acceso SSH al manager está corroborado. No hay evidencia suficiente para evaluar los Productos 2 y 3.

### Trabajo y capturas pendientes

Acreditar contribuciones desde un terminal Linux, como WSL o Git Bash. Corregir la errata en una aportación posterior es una propuesta para usar ese flujo. Las instrucciones complementarias están en `entrega/INSTRUCCIONES-F2-INTEGRANTES.md` (solo local; pendiente de publicación). Completar la acreditación de uso de la clave y acceso por salto a los workers, comentarios normativos, práctica individual y reflexión. Para documentar los Productos 2 y 3, incorporar sus archivos, pruebas y guías originales; confirmar autoría de la web con evidencia. No inventar comandos de desarrollo.

Las capturas adicionales de accesos se proponen para acreditar el uso de claves y el salto. Los originales no fijan un número de capturas por persona o nodo.

[Volver a la revisión](README.md).
