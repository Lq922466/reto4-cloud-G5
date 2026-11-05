# Tareas pendientes para la entrega

Situación a 5 de noviembre de 2026. La fecha de entrega no consta en el repositorio: `[POR COMPLETAR]`.

**Estado real por criterio:** [checklist final](CHECKLIST-FINAL.md).

## 1. Lq922466

### Lo más urgente

| # | Tarea | Por qué | Listo cuando |
| --- | --- | --- | --- |
| 1 | Pasar la Guía y la Rúbrica originales a Claude Code | No están en el Codespace y de ellas depende todo el contraste. Se pueden copiar en `/workspaces/guia-rubrica/`, fuera del repositorio | Hecho el [contraste](../REVISION.md#contraste-pendiente-con-la-guía-y-la-rúbrica) |
| 2 | Iniciar Learner Lab y renovar `~/.aws/credentials` | AWS deniega las lecturas y la web no responde desde las 11:07 UTC | `aws ec2 describe-instances` responde y la web carga |
| 3 | Decidir si se actualiza la regla SSH | La IP del Codespace cambió, de `172.166.156.160` a `172.166.151.121`. Sin esto no hay SSH para repetir la auditoría ni para las demostraciones. Es un cambio en AWS, que requiere autorización | Regla con la IP actual, o decisión de no usar SSH |
| 4 | No borrar este Codespace | El estado de Terraform solo está aquí, en `/workspaces/reto4-revision.Geeumo/terraform`, y no debe subirse a Git. Conviene guardar una copia privada | Copia privada hecha |

### Antes de entregar

| # | Tarea | Criterio | Listo cuando |
| --- | --- | --- | --- |
| 5 | Hacer las cinco capturas web de [REVISION.md](../REVISION.md#capturas-que-faltan), sin mostrar el ID de la cuenta de AWS | A2, A3, A6, E5, F1, F2, F10 | Imágenes en `evidencias/capturas-web/` |
| 6 | Confirmar quién integra el grupo y sus nombres | F1, F11 | Tabla 1 de [GESTION.md](../GESTION.md) completa, y portada de la presentación |
| 7 | Dar acceso al repositorio a la cuenta del profesor, si procede | F1 | La cuenta aparece en Settings → Collaborators |
| 8 | Aportar el enlace y las capturas de Trello, o indicar que no existe | F11 | Apartado 4 de [GESTION.md](../GESTION.md) completo |
| 9 | Hacer su propia práctica individual y aportar su clave pública | F13, B1 | `practica-individual/Lq922466/` con trabajo real |
| 10 | Consultar al profesor: vockey, capturas D3, uso de IA, topología, E4 y E8 | B1, D3, C3, F2, E4, E8 | Respuesta anotada en [REVISION.md](../REVISION.md) |
| 11 | Decidir cuándo ejecutar la destrucción de A6 | A6 | Decisión tomada. Recomendación: después de la defensa |
| 12 | Decidir si el Word va en el repositorio: `.gitignore` excluye `*.docx` | F9 | Decisión tomada |
| 13 | Revisar y, al final, integrar la PR #1 | F2, F4 | PR fusionada, si la Guía lo pide |
| 14 | Revisar en GitHub las funciones de seguridad y si se protege `main` | F12 | Revisado en Settings. El token del Codespace no permite consultarlas |

## 2. Compañeros

Para cada persona que se confirme como integrante. Las cuentas con acceso son EnriZx2, alexguerth e ibaiaretxabalaasir-collab. Nadie debe
hacer estas tareas en su nombre.

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

**Para todo el grupo:** asignar los papeles A–D, ensayar con la [presentación](presentacion-cloud-g5.pptx) y el
[guion](DEFENSA.md), y hacer la exposición (G1).

## 3. Claude Code

### Sin autorización adicional

| # | Tarea | Criterio | Necesita |
| --- | --- | --- | --- |
| 1 | Contrastar la matriz, las evidencias, el informe y la defensa con los originales | Todos | Guía y Rúbrica |
| 2 | Repetir la auditoría de solo lectura | Fases 1–5 | Laboratorio activo, credenciales y, para SSH, la regla actualizada |
| 3 | Rehacer capturas de lectura si cambian las IP | D3, F10 | Laboratorio activo |
| 4 | Generar el Word definitivo con las capturas reales | F9, F10 | Contraste, capturas web y datos del grupo |
| 5 | Incorporar a [GESTION.md](../GESTION.md) y a las evidencias los datos que aporte el grupo | F10, F11 | Datos reales |
| 6 | Ajustar [`practica-individual/`](../practica-individual/README.md) a lo que pida la Guía | F13 | Guía |
| 7 | Repetir la revisión de secretos con `scripts/revisar-secretos.py` y actualizar la PR antes de integrarla | F12, F2 | — |

### Solo con autorización expresa de Lq922466

| # | Tarea | Motivo |
| --- | --- | --- |
| 1 | Actualizar la regla SSH con la IP actual del Codespace | Cambia AWS |
| 2 | Ejecutar `terraform destroy` | Elimina el clúster, de forma irreversible |
| 3 | Repetir E4 o E8 con la web definitiva | Detiene instancias. [Qué registrar](../evidencias/auditoria/E4-E8.md#qué-haría-falta-para-cerrarlos) |
| 4 | Instalar las claves públicas de los compañeros | Cambia los nodos. Con Terraform cambiaría `user_data`, lo que puede detener y arrancar las instancias: conviene hacerlo por SSH |
| 5 | Cambiar los roles de Swarm, si la Guía exige otra topología | Cambia el clúster |
| 6 | Sacar la PR de borrador o fusionarla | Afecta a la rama de entrega |

**Claude Code no puede hacer:** las capturas con sesión de AWS o GitHub, el trabajo individual de nadie, las decisiones del grupo, la
exposición ni la defensa.
