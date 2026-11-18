# Documentación individual — Cristina

Fecha: 9 de noviembre de 2026. Documento preparado por Codex a partir de archivos, historial y evidencias existentes; no es una declaración escrita por Cristina. La versión local recibida indicaba correcciones de Claude Code; esta sesión de Codex ha vuelto a contrastar los datos y corregir el documento. Las tareas asignadas no prueban autoría. «Verificado» significa contrastado documentalmente en esta revisión, no ejecutado de nuevo en AWS. Los resultados del laboratorio son históricos.

**Integrante:** Cristina. **Productos asignados:** 1 — Sistemas/Hardware; 6 — Cloud. **Cuenta:** Lq922466 (Git: Innnx).

## Objetivo

El objetivo de Cloud es publicar la web en cuatro EC2 gestionadas con Terraform y Docker Swarm, demostrar orquestación y documentarla. No se ha localizado la Guía ni la Rúbrica del Producto 1: ese producto no se puede evaluar con las fuentes disponibles.

## Procedimiento

- Consta la creación del repositorio y del entorno en `2f5e6ea`, y Terraform inicial en `6f3d838`.
- Los archivos actuales contienen arranque con hostname y Europe/Madrid, Docker y claves; workers con `count`, salidas y reglas de red.
- Constan scripts de SSH, Swarm, imágenes y pruebas; los commits de Codex tienen autoría propia. Los de Innnx con coautoría de Claude y los registros por encargo se identifican como trabajo asistido, sin presentarlos como ejecución manual de Cristina.
- Las imágenes finales y las pruebas posteriores se documentan en los registros del 5–9 de noviembre. Esta revisión no las ha repetido.
- Sus capturas personales muestran configuración de alias, acceso al manager y acceso por salto a los tres workers.

### Comandos y configuraciones relevantes

Comandos visibles en sus capturas: `Test-Path`, `ssh -G manager-g5`, `ssh manager-g5`, `ssh worker1-g5`, `ssh worker2-g5`, `ssh worker3-g5`; dentro de los nodos, `whoami`, `hostname`, `date -Is`. Configuración del proyecto: `count = var.worker_count`, MTU 1450, 4 réplicas, puerto 80 y actualización `start-first`. No se atribuyen a Cristina como comandos personales los que solo constan en scripts de asistentes.

## Evidencia

`evidencias/capturas-integrantes/INDICE.md` (solo local; pendiente de publicación), `evidencias/capturas-conformes/B1-registro-cristina.txt` (solo local; pendiente de publicación), [Terraform](../../terraform/main.tf), [arranque](../../terraform/scripts/bootstrap.sh.tftpl), [servicio](../../app/stack.yml), [actualización](../../evidencias/F3-actualizacion/registro.txt).

### Contribuciones en GitHub y Pull Requests

23 commits con autoría Innnx en el historial disponible (incluidos trabajos asistidos y merge); 11 adicionales son de Codex y no se reasignan a Cristina. [PR #1](https://github.com/Lq922466/reto4-cloud-G5/pull/1), `cloud-g5-implementacion` → `main`, abierta en borrador, acredita uso de PR. Los originales no exigen integrar en `main` ni otra PR individual hacia una rama concreta. El destino `cloud-g5-implementacion` para nuevas aportaciones del equipo procede de las instrucciones del usuario. Esta sesión publica únicamente los siete documentos en esa rama y no hace merge. No consta otra PR individual de Cristina hacia integración.

## Resultado/Conclusión

Acceso personal a los cuatro nodos corroborado por las huellas de su clave en los registros. Código y pruebas históricas Cloud disponibles; no permiten dar por finalizados los 42 criterios. Producto 1: sin documentación específica localizable ni criterios originales para evaluarlo.

### Trabajo y capturas pendientes

Completar A6, C3, evidencias de orquestación, capturas de consola y navegador, acceso del profesor y documentación de gestión; publicar lo local únicamente con autorización. Añadir comentario de prueba, resultado y autor a sus capturas personales conservando los originales. Aportar práctica individual. Localizar trabajo y originales del Producto 1 para una revisión separada.

Las capturas adicionales de accesos se proponen para acreditar el uso de claves y el salto. Los originales no fijan un número de capturas por persona o nodo.

[Volver a la revisión](README.md).
