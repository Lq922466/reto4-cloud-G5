# Revisión de evidencias — Alexandra (borrador para validación)

**Responsable asignada:** Alexandra (alexguerth)  
**Preparación documental:** ChatGPT, por encargo de Cristina, 09/11/2026  
**Estado:** revisión preliminar de archivos del repositorio; pendiente de comprobación personal de Alexandra.

## Objetivo

Revisar si las evidencias de RETO 4 CLOUD G5 están localizables, correctamente identificadas y si permiten distinguir resultados correctos, incompletos y no correctos.

## Procedimiento

Se han consultado [el índice general](../evidencias/INDICE.md), [el índice de capturas conformes](../evidencias/capturas-conformes/INDICE.md) y [la matriz de requisitos](segunda-revision-2026-11-09/MATRIZ-REQUISITOS.md). Esta revisión documental **no equivale a abrir visualmente todas las imágenes ni a repetir las pruebas de AWS**.

## Comprobaciones

| Evidencia o grupo | Comprobación documental | Resultado |
| --- | --- | --- |
| [A2-instancias](../evidencias/capturas-conformes/A2-instancias.png) | Registrada con fecha, autor y resultado; falta contraste con vista EC2 actual | Documentada; verificación actual pendiente |
| [A3-reglas](../evidencias/capturas-conformes/A3-reglas.png) | Registrada; existe una regla SSH temporal que debe revisarse | Documentada; revisión de consola pendiente |
| [A6-sin-cambios](../evidencias/capturas-conformes/A6-sin-cambios.png) | El propio índice indica NO CORRECTO | No válida como prueba de plan limpio |
| [B1-clave-nodos](../evidencias/capturas-conformes/B1-clave-nodos.png) | Índice registra claves de cuatro integrantes en cuatro nodos | Documentada; faltan comprobaciones individuales de acceso a workers |
| [C3-nodos](../evidencias/capturas-conformes/C3-nodos.png) | Índice indica NO CORRECTO por tres managers | Pendiente de corrección técnica |
| [D1-dockerhub](../evidencias/capturas-conformes/D1-dockerhub.png) | Registro de versiones 1.0 y 2.0 | Documentada |
| [D2-servicio](../evidencias/capturas-conformes/D2-servicio.png) | Registro de cuatro réplicas | Documentada; comprobar estado actual |
| [D3 — navegadores](../evidencias/D3-registro.txt) | Existen pruebas históricas de las cuatro IP | Falta completar capturas normativas actuales |
| E1–E8 | Existen registros y capturas históricas de orquestación | Faltan secuencias normativas antes/durante/después en varios ensayos |
| [F1-repositorio](../evidencias/capturas-conformes/F1-repositorio.png) | Registro de repositorio privado | Falta confirmar invitación del profesor |
| [F2-historial](../evidencias/capturas-conformes/F2-historial.png) | Registro histórico de Git | No acredita aún PR y commits personales de todos |
| [F12-seguridad](../evidencias/capturas-conformes/F12-seguridad.png) | Revisión histórica sin secretos | Repetir escaneo tras cambios recientes |
| F13 | Existe [plantilla](../practica-individual/PLANTILLA.md) | Prácticas personales pendientes |

## Incidencias detectadas

- Los índices incluyen evidencias de diferentes fechas; las IP y estados pueden haber cambiado.
- Las capturas de A6 y C3 reflejan expresamente resultados **NO CORRECTO** y no deben contarse como pruebas de cumplimiento.
- La existencia de capturas de E1–E8 no garantiza que cada secuencia tenga las tres fases requeridas ni que se vea la sonda.
- El índice general contiene referencias históricas que deben actualizarse tras las últimas publicaciones y correcciones técnicas.

## Resultado y conclusión

Hay una base documental amplia de evidencias, pero **no está justificado marcar todas como completas**. La revisión visual de cada PNG y la validación personal de Alexandra siguen pendientes. Documento preparado con ChatGPT a petición de Cristina, sin atribuirle a Alexandra verificaciones no realizadas.
