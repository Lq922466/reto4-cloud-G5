# Revisión de evidencias — Alexandra (borrador para validación)

**Responsable asignada:** Alexandra (alexguerth)  
**Preparación documental:** ChatGPT, por encargo de Cristina, 09/11/2026  
**Estado:** pendiente de comprobación personal de Alexandra.

## Objetivo

Comprobar que las evidencias técnicas disponibles permiten identificar el estado de la infraestructura y las pruebas de Docker Swarm.

## Procedimiento

Se han consultado [el índice general](../evidencias/INDICE.md), [el índice de capturas conformes](../evidencias/capturas-conformes/INDICE.md) y [la matriz de requisitos](segunda-revision-2026-11-09/MATRIZ-REQUISITOS.md). Se trata de una revisión documental de resultados registrados, no de una nueva ejecución en AWS ni de una inspección visual exhaustiva de todos los PNG.

## Comprobaciones

| Prueba | Resultado registrado | Estado |
| --- | --- | --- |
| A2 — EC2 | Cuatro instancias con tipos previstos en el registro | Documentado; confirmar estado actual |
| A3 — Security Group | Reglas registradas; consta acceso SSH temporal | Revisar regla temporal |
| A6 — Terraform | Captura `A6-sin-cambios` marcada NO CORRECTO | Pendiente |
| B1 — SSH | Claves públicas de los cuatro integrantes instaladas según registro | Documentado; pruebas individuales incompletas |
| C2 — Swarm/MTU | Red ingress con MTU 1450 registrada | Documentado |
| C3 — Roles | Captura `C3-nodos` marcada NO CORRECTO | Pendiente |
| D1–D2 — Web | Versiones 1.0/2.0 y cuatro réplicas documentadas | Documentado |
| E1–E8 — Orquestación | Hay registros de balanceo, escalado, recuperación y actualización | Resultados históricos; comprobar pruebas pendientes |

## Incidencias técnicas detectadas

| Criterio | Incidencia | ¿Se puede resolver? |
| --- | --- | --- |
| C3 | El último estado registrado tiene tres managers en lugar de uno | Sí; ajustar roles con un procedimiento seguro |
| A6 | El plan no muestra todavía el estado esperado sin cambios | Sí; revisar salidas y estado Terraform, sin aplicar cambios no autorizados |
| E8 | La prueba histórica de elección de líder no cubre de forma continua todo el intervalo de parada | Sí; repetir o completar la prueba autorizada si el profesor exige esa evidencia |

La falta de una captura, de un comentario o de un enlace **no se clasifica aquí como fallo técnico**. Se trata por separado como evidencia pendiente.

## Resultado y conclusión

Las evidencias registran una implementación funcional de buena parte del proyecto. C3 y A6 siguen pendientes de corrección o comprobación; E8 necesita validación adicional de su prueba. Documento preparado con ChatGPT por encargo de Cristina y pendiente de revisión personal de Alexandra.
