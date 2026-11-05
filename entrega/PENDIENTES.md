# Tareas pendientes para la entrega

Situación a 5 de noviembre de 2026, tras el [contraste con la Guía y la Rúbrica](CONTRASTE-GUIA-RUBRICA.md). La fecha de entrega no aparece en esos documentos: `[POR COMPLETAR]`.

**Estado por criterio:** [checklist final](CHECKLIST-FINAL.md).

## 1. Lq922466

### Lo más urgente

| # | Tarea | Por qué | Listo cuando |
| --- | --- | --- | --- |
| 1 | Iniciar Learner Lab y renovar `~/.aws/credentials` | AWS deniega las lecturas y la web no responde. La Rúbrica solo puntúa lo que funcione durante la corrección | `aws ec2 describe-instances` responde y la web carga |
| 2 | Decidir si se actualiza la regla SSH | La IP del Codespace ya no coincide con la de la regla. Sin esto no se pueden rehacer las capturas. Es un cambio en AWS, que requiere autorización | Regla con la IP actual |
| 3 | Consultar al profesor | `vockey`, topología final, destrucción de A6, autoría de las capturas, si la práctica es de cada integrante, y la fecha de entrega | Respuestas anotadas en [REVISION.md](../REVISION.md) |
| 4 | No borrar este Codespace | El estado de Terraform solo está aquí, en `/workspaces/reto4-revision.Geeumo/terraform`, y no debe subirse a Git. Conviene guardar una copia privada | Copia privada hecha |

### Antes de entregar

| # | Tarea | Criterio | Listo cuando |
| --- | --- | --- | --- |
| 5 | Hacer las seis capturas de [REVISION.md](../REVISION.md#capturas-que-faltan), sin mostrar el ID de la cuenta de AWS | A2, A3, A6, E5, F1, F2, F5, F10 | Imágenes en `evidencias/capturas-web/` |
| 6 | Confirmar quién integra el grupo y sus nombres | F1, F11, G1 | Tabla 1 de [GESTION.md](../GESTION.md) completa, y presentación con nombres y reparto |
| 7 | Invitar al profesor al repositorio antes de la fecha límite | F1 | La cuenta aparece en Settings → Collaborators |
| 8 | Aportar su práctica individual previa y su clave pública | F13, B1 | `practica-individual/Lq922466/` con trabajo real, y clave entregada |
| 9 | Decidir cuándo ejecutar la destrucción de A6, tras consultarlo | A6 | Decisión tomada. Recomendación: después de la corrección |
| 10 | Autorizar la repetición de pruebas y la topología final | E2–E4, E6–E8, C3 | Autorización dada |
| 11 | Revisar e integrar la PR #1 en `main`, que hoy solo contiene `.devcontainer` y `terraform` | F2, F4 | PR fusionada antes de la entrega |
| 12 | Revisar en GitHub las funciones de seguridad y si se protege `main` | F12 | Revisado en Settings. El token del Codespace no permite consultarlas |

**Ya no hace falta:** el Word, Trello y el seguimiento semanal no aparecen en la Guía ni en la Rúbrica. Son opcionales.

## 2. Compañeros

Para cada persona que se confirme como integrante. Las cuentas con acceso son EnriZx2, alexguerth e ibaiaretxabalaasir-collab. Nadie debe hacer estas tareas en su nombre.

| # | Tarea | Criterio | Listo cuando |
| --- | --- | --- | --- |
| 1 | Confirmar su pertenencia al grupo y completar su fila en [GESTION.md](../GESTION.md) | F1, F11 | Nombre, rol y responsabilidades reales |
| 2 | Indicar qué trabajo ha hecho, incluida la autoría de la web F1 si le corresponde, y aportar su reflexión | F11 | Reparto real en [GESTION.md](../GESTION.md) |
| 3 | Aportar sus commits y una PR desde su propia cuenta, desde su propio terminal | F2 | PR visible en GitHub |
| 4 | Aportar su práctica individual previa de EC2 | F13 | `practica-individual/CUENTA/` con trabajo real |
| 5 | Facilitar su clave SSH **pública**, nunca la privada | B1 | Clave entregada a Lq922466 |
| 6 | Revisar la PR #1 y las evidencias | F2 | Revisión registrada en GitHub |
| 7 | Preparar las preguntas sobre cualquier parte y su demostración en vivo | G2, G3 | Realizadas ante el profesor |

**Para todo el grupo:** asignar los papeles A–D, ensayar con la [presentación](presentacion-cloud-g5.pptx) y el [guion](DEFENSA.md), incluida la caída de un nodo en directo, y hacer la exposición (G1).

## 3. Claude Code

### Sin autorización adicional ni AWS

| # | Tarea | Criterio |
| --- | --- | --- |
| 1 | Crear `~/.ssh/config` y añadir a `/config` las configuraciones aplicadas, sin secretos | B2 |
| 2 | Ampliar los comentarios de los scripts y añadir uno que actualice las IP desde EC2 | F7 |
| 3 | Convertir en variables los tamaños de disco, con los mismos valores | A1 |
| 4 | Incorporar a [GESTION.md](../GESTION.md) los datos reales que aporte el grupo | F11 |
| 5 | Repetir la revisión de secretos con `scripts/revisar-secretos.py` antes de integrar | F12, F2 |

### Solo lectura, con el laboratorio activo y SSH

| # | Tarea | Criterio |
| --- | --- | --- |
| 1 | Repetir la auditoría y un plan de Terraform | Fases 1–5 |
| 2 | Rehacer las capturas de lectura con el prompt real y comentario | A4, A5, B3–B5, C1, C2, C4, D3, E1, E5, F5 |
| 3 | Integrar las capturas conformes en `PROYECTO.md` | F9, F10 |

### Solo con autorización expresa de Lq922466

| # | Tarea | Motivo |
| --- | --- | --- |
| 1 | Actualizar la regla SSH con la IP actual del Codespace | Cambia AWS |
| 2 | Repetir E2, E3, E4, E6, E7 y E8 con la web definitiva y capturas conformes. [Qué registrar](../evidencias/auditoria/E4-E8.md#qué-haría-falta-para-cerrarlos) | Cambia el servicio y detiene instancias |
| 3 | Dejar la topología acordada | Cambia los roles de Swarm |
| 4 | Instalar las claves públicas y, si se decide, retirar `vockey` | Cambia los nodos. Con Terraform cambiaría `user_data`, lo que puede detener y arrancar las instancias: conviene hacerlo por SSH |
| 5 | Ejecutar `terraform destroy` | Elimina el clúster, de forma irreversible |
| 6 | Subir los cambios, sacar la PR de borrador o fusionarla | Afecta a GitHub y a la rama de entrega |

**Claude Code no puede hacer:** las capturas con sesión de AWS o GitHub, el trabajo individual de nadie, las decisiones del grupo, la exposición ni la defensa.
