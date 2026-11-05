# Tareas pendientes para la entrega

Situación a 5 de noviembre de 2026. La fecha de entrega no consta en el repositorio: `[POR COMPLETAR]`.

**Prioridad:** lo primero es la tarea 1 de Lq922466, la Guía y la Rúbrica, porque de ellas depende el Word y pueden
cambiar otras tareas.

## 1. Lq922466

| # | Tarea | Criterio | Listo cuando |
| --- | --- | --- | --- |
| 1 | Pasar la Guía y la Rúbrica originales a Claude Code | Todos | Se ha hecho el contraste de [REVISION.md](../REVISION.md#contraste-pendiente-con-la-guía-y-la-rúbrica) |
| 2 | Hacer las seis capturas web de [REVISION.md](../REVISION.md#capturas-que-faltan), sin mostrar el ID de la cuenta de AWS | A2, A3, A6, E5, F1, F2, F8, F10 | Las imágenes están en `evidencias/capturas-web/` |
| 3 | Confirmar quién integra el grupo y sus nombres | F1, F11 | Tabla 1 de [GESTION.md](../GESTION.md) completa |
| 4 | Dar acceso al repositorio a la cuenta del profesor, si procede | F1 | La cuenta aparece en Settings → Collaborators |
| 5 | Aportar el enlace y las capturas de Trello, o indicar que no existe | F11 | Apartado 4 de [GESTION.md](../GESTION.md) completo |
| 6 | Hacer su propia práctica individual y aportar su clave pública | F13, B1 | `practica-individual/Lq922466/` con trabajo real |
| 7 | Consultar al profesor lo que indique el contraste: vockey, capturas D3, uso de IA, E4 y E8 | B1, D3, E4, E8, F2 | Respuesta anotada en [REVISION.md](../REVISION.md) |
| 8 | Decidir cuándo ejecutar la destrucción de A6 | A6 | Decisión tomada. Recomendación: después de la defensa |
| 9 | Decidir si el Word va en el repositorio: `.gitignore` excluye `*.docx` | F9 | Decisión tomada |
| 10 | Revisar y, al final, integrar la PR #1 | F2, F4 | PR fusionada, si la Guía lo pide |

### Para no perder el entorno

- **No borrar este Codespace antes de destruir la infraestructura.** El estado de Terraform solo está aquí, en
  `/workspaces/reto4-revision.Geeumo/terraform`, y no debe subirse a Git. Sin él, `terraform destroy` no podrá gestionar
  los recursos. Conviene guardar además una copia privada.
- **Tras reiniciar Learner Lab** cambian las IP públicas y hay que renovar las credenciales de AWS en Codespaces. Las URL de
  D3 dejarán de ser las actuales.
- **Si cambia la IP del Codespace** se pierde el SSH hasta actualizar la regla del grupo de seguridad, lo que es un cambio en
  AWS que requiere autorización.

## 2. Compañeros

Para cada persona que se confirme como integrante. Las cuentas con acceso son EnriZx2, alexguerth e
ibaiaretxabalaasir-collab. Nadie debe hacer estas tareas en su nombre.

| # | Tarea | Criterio | Listo cuando |
| --- | --- | --- | --- |
| 1 | Confirmar su pertenencia al grupo y completar su fila en [GESTION.md](../GESTION.md) | F1, F11 | Nombre, rol y responsabilidades reales |
| 2 | Indicar qué trabajo ha hecho, incluida la autoría de la web F1 si le corresponde | F11 | Reparto real en [GESTION.md](../GESTION.md) |
| 3 | Aportar sus commits y una PR desde su propia cuenta | F2 | PR visible en GitHub |
| 4 | Hacer su práctica individual | F13 | `practica-individual/CUENTA/` con trabajo real |
| 5 | Facilitar su clave SSH **pública**, nunca la privada | B1 | Clave entregada a Lq922466 |
| 6 | Añadir su parte del seguimiento semanal, Trello y la reflexión | F11 | Apartados 3, 4 y 7 de [GESTION.md](../GESTION.md) |
| 7 | Revisar la PR #1 y las evidencias | F2 | Revisión registrada en GitHub |
| 8 | Preparar su defensa y demostración sobre todas las fases | G2, G3 | Realizadas ante el profesor |

**Para todo el grupo:** preparar y hacer la exposición de diez minutos (G1), con el
[guion](../REVISION.md#guion-de-exposición-de-diez-minutos) como punto de partida.

## 3. Claude Code

### Sin autorización adicional

| # | Tarea | Criterio | Necesita |
| --- | --- | --- | --- |
| 1 | Contrastar la matriz, las evidencias y la estructura del informe con los originales | Todos | Guía y Rúbrica |
| 2 | Generar el Word definitivo con las capturas reales | F9, F10 | Contraste, capturas web y datos del grupo |
| 3 | Incorporar a [GESTION.md](../GESTION.md) y a las evidencias los datos que aporte el grupo | F10, F11 | Datos reales |
| 4 | Ajustar [`practica-individual/`](../practica-individual/README.md) a lo que pida la Guía | F13 | Guía |
| 5 | Preparar material de la exposición y preguntas de repaso por fase | G1–G3 | — |
| 6 | Repetir la revisión de secretos con `scripts/revisar-secretos.py` y actualizar la PR antes de integrarla | F12, F2 | — |
| 7 | Rehacer capturas de lectura si cambian las IP | D3, F10 | Laboratorio en marcha |

### Solo con autorización expresa de Lq922466

| # | Tarea | Motivo |
| --- | --- | --- |
| 1 | Ejecutar `terraform destroy` | Elimina el clúster, de forma irreversible |
| 2 | Repetir E4 o E8 con la web definitiva | Detiene instancias |
| 3 | Instalar las claves públicas de los compañeros | Cambia los nodos. Hacerlo con Terraform cambiaría `user_data`, lo que puede detener y arrancar las instancias: conviene instalarlas por SSH |
| 4 | Actualizar la regla SSH si cambia la IP del Codespace | Cambia AWS |
| 5 | Cambiar los roles de Swarm, si la Guía exige otra topología | Cambia el clúster |
| 6 | Sacar la PR de borrador o fusionarla | Afecta a la rama de entrega |

**Claude Code no puede hacer:** las capturas con sesión de AWS o GitHub, el trabajo individual de nadie, las decisiones del
grupo, la exposición ni la defensa.
