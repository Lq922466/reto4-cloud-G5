# Documentación individual — Alexandra

Fecha: 9 de noviembre de 2026. Documento preparado por Codex a partir de archivos, historial y evidencias existentes; no es una declaración escrita por Alexandra. La versión local recibida indicaba correcciones de Claude Code; esta sesión de Codex ha vuelto a contrastar los datos y corregir el documento. Las tareas asignadas no prueban autoría. «Verificado» significa contrastado documentalmente en esta revisión, no ejecutado de nuevo en AWS. Los resultados del laboratorio son históricos.

**Integrante:** Alexandra. **Productos asignados:** 4 — Bases de Datos. **Cuenta:** alexguerth.

## Objetivo

Documentar la aportación personal que sí consta en Cloud: clave propia y acceso SSH al manager. El objetivo técnico de su Producto 4 no se puede reconstruir sin su guía original.

## Procedimiento

Aportó su clave pública y realizó una conexión al manager desde PowerShell. La instalación en los cuatro nodos la hizo Claude Code por encargo de Cristina, según los registros, no Alexandra. No se han localizado esquemas SQL, scripts o documentación de base de datos con autoría de Alexandra en este repositorio.

### Comandos y configuraciones relevantes

La captura muestra `ssh -i` con `alexandra_reto4` hacia el manager y `whoami`, `hostname`, `date -Is`. No constan comandos SQL ni configuraciones de un motor de base de datos.

## Evidencia

`evidencias/capturas-integrantes/B1-acceso-alexandra.png` (solo local; pendiente de publicación), `evidencias/capturas-conformes/B1-registro-manager.txt` (solo local; pendiente de publicación), `terraform/claves/alexandra_reto4.pub` (solo local; pendiente de publicación).

### Contribuciones en GitHub y Pull Requests

Existe `alexandra-revision-evidencias`; no se ha corroborado aquí la fecha ni la cuenta que creó la referencia remota. Su SHA remoto es `6f3d838`, igual que `main`, así que no contiene commits propios ni las evidencias, que están en `cloud-g5-implementacion`. A 9 de noviembre no constan commits de alexguerth ni PR propia. Pendiente adelantar la rama hasta `cloud-g5-implementacion`, aportar trabajo real desde su cuenta con Git Bash o WSL y abrir una PR hacia esa rama, como explican las `entrega/INSTRUCCIONES-F2-INTEGRANTES.md` (solo local; pendiente de publicación).

## Resultado/Conclusión

Acceso propio al manager corroborado por la huella de su clave. No se acredita acceso personal a workers. El portal Cloud es estático y la Guía Cloud no exige base de datos: su ausencia no incumple los originales Cloud. Producto 4: no evaluable con estas fuentes.

### Trabajo y capturas pendientes

Documentar acceso a los tres workers, comentarios normativos, práctica individual y reflexión. Incorporar archivos y evidencias reales del Producto 4 y su guía original para revisarlo. La existencia de la rama no acredita contribución.

Las capturas adicionales de accesos se proponen para acreditar el uso de claves y el salto. Los originales no fijan un número de capturas por persona o nodo.

[Volver a la revisión](README.md).
