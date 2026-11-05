# Capturas conformes a la norma de la Guía

Generadas con `scripts/capturas-norma.py`. Cada captura muestra el prompt real con el hostname y la fecha y hora, y un comentario con la prueba, el resultado y el autor.
El resultado se calcula comprobando la salida real. Junto a cada imagen hay un `.txt` con la misma salida.

| Evidencia | Criterio | Prueba | Resultado | Autor | Hora (UTC) |
| --- | --- | --- | --- | --- | --- |
| [A1-modulo](A1-modulo.png) | A1, F6 | Módulo Terraform con variables y validación | CORRECTO: El módulo está organizado, usa variables y terraform validate es correcto. | Claude Code, por encargo de Lq922466 | 2026-11-05 12:22:39 |
| [A4-script](A4-script.png) | A4 | Script de arranque: hostname, zona, claves y Docker | CORRECTO: El script configura hostname, zona horaria, claves públicas, SSH y Docker. | Claude Code, por encargo de Lq922466 | 2026-11-05 12:22:45 |
| [B2-plantilla](B2-plantilla.png) | B2 | Configuración SSH con nombre corto | CORRECTO: Los alias se resuelven solo con el nombre corto. La conexión real se comprueba en B2-conexion. | Claude Code, por encargo de Lq922466 | 2026-11-05 12:23:14 |
| [D1-dockerhub](D1-dockerhub.png) | D1 | Etiquetas 1.0 y 2.0 en Docker Hub | CORRECTO: Docker Hub publica las dos etiquetas con los digests construidos. | Claude Code, por encargo de Lq922466 | 2026-11-05 12:23:12 |
| [F1-repositorio](F1-repositorio.png) | F1 | Repositorio privado y cuentas con acceso | CORRECTO: El repositorio es privado. Solo muestra las cuentas con acceso: falta confirmar integrantes y profesor. | Claude Code, por encargo de Lq922466 | 2026-11-05 12:22:47 |
| [F12-seguridad](F12-seguridad.png) | F12 | Sin credenciales, claves ni estado de Terraform | CORRECTO: Solo se versiona la plantilla de variables, y la revisión no encuentra secretos. | Claude Code, por encargo de Lq922466 | 2026-11-05 12:23:11 |
| [F2-historial](F2-historial.png) | F2 | Historial de commits y PR | CORRECTO: Muestra los autores reales: aún faltan commits y PR de los demás integrantes. | Claude Code, por encargo de Lq922466 | 2026-11-05 12:23:04 |
| [F4-estructura](F4-estructura.png) | F4 | Estructura del repositorio | CORRECTO: Existen las carpetas pedidas en la rama de implementación. | Claude Code, por encargo de Lq922466 | 2026-11-05 12:22:37 |
| [F5-entorno](F5-entorno.png) | F5 | Codespace aprovisionado con AWS CLI y Terraform | CORRECTO: El devcontainer incluye AWS CLI y Terraform, y ambos funcionan en el Codespace. | Claude Code, por encargo de Lq922466 | 2026-11-05 12:22:35 |
| [F6-codigo](F6-codigo.png) | F6 | Código Terraform: workers multiplicados con un único recurso | CORRECTO: Los workers salen de un único recurso multiplicado con count. | Claude Code, por encargo de Lq922466 | 2026-11-05 12:22:38 |
| [F7-scripts](F7-scripts.png) | F7 | Scripts comentados | CORRECTO: Los scripts están en /scripts y explican qué hacen. | Claude Code, por encargo de Lq922466 | 2026-11-05 12:22:46 |
