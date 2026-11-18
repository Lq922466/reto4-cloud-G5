# Revisión de documentación — Enrique (borrador actualizado)

**Responsable asignado:** Enrique (EnriZx2)  
**Revisión original:** 06/11/2026, PR #2  
**Actualización preparada con asistencia de ChatGPT:** 09/11/2026  
**Estado:** pendiente de comprobación y conformidad personal de Enrique.

## Objetivo

Comprobar que la documentación principal del RETO 4 CLOUD G5 está disponible y permite localizar los procedimientos y las evidencias técnicas.

## Procedimiento y comprobaciones

Se han contrastado los destinos indicados en el README de la rama `cloud-g5-implementacion` con los archivos publicados.

| Documento | Comprobación | Resultado |
| --- | --- | --- |
| [PROYECTO.md](../PROYECTO.md) | Informe técnico de las fases | Disponible |
| [REVISION.md](../REVISION.md) | Estado de criterios | Disponible |
| [CHECKLIST-FINAL.md](CHECKLIST-FINAL.md) | Lista de comprobación | Disponible |
| [CONTRASTE-GUIA-RUBRICA.md](CONTRASTE-GUIA-RUBRICA.md) | Contraste de requisitos | Disponible |
| [PROCEDIMIENTO-CAPTURAS.md](PROCEDIMIENTO-CAPTURAS.md) | Procedimiento de evidencias | Disponible |
| [DEFENSA.md](DEFENSA.md) | Guion de defensa | Disponible |
| [GESTION.md](../GESTION.md) | Organización del grupo | Disponible |
| [INDICE.md](../evidencias/INDICE.md) | Índice de evidencias | Disponible |

## Incidencias técnicas detectadas

La revisión de enlaces no detecta por sí misma fallos técnicos. Al consultar el estado técnico documentado se identifican estas **incidencias del proyecto**, que requieren comprobación actual:

| Criterio | Incidencia técnica | Acción y prioridad |
| --- | --- | --- |
| C3 | El último registro muestra tres managers, cuando la topología final solicitada es un manager y tres workers | Corregible; prioridad alta. Verificar quorum antes de cambiar roles |
| A6 | El plan de Terraform registrado no está limpio; las salidas de IP pueden estar desactualizadas | Corregible tras comprobar estado y credenciales; no ejecutar `apply` o `destroy` sin autorización |
| A3 | Consta una regla SSH temporal adicional | Revisar necesidad y retirar con autorización, sin cortar el acceso |

No se consideran incidencias técnicas los errores de redacción, formato, enlaces de documentos o capturas que aún no se hayan incorporado.

## Resultado y conclusión

Los documentos principales están disponibles. Las incidencias técnicas mencionadas tienen un procedimiento de corrección, pero su resolución debe verificarse sobre el entorno real. Esta actualización fue preparada con ChatGPT por encargo de Cristina y está pendiente de validación por Enrique.
