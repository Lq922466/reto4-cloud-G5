# Segunda revisión independiente — RETO 4 CLOUD G5

9 de noviembre de 2026. **La entrega no se puede dar por cerrada.** Hay implementación y evidencia histórica extensa, pero persisten requisitos sin completar y aportaciones individuales sin acreditar en GitHub. La revisión técnica no ha realizado operaciones en AWS ni merges. La autorización posterior permite commit y push exclusivamente de los siete archivos de esta carpeta; se conserva todo el trabajo previo y sus cambios locales.

## Objetivo

Contrastar los requisitos con la Guía y la Rúbrica originales del profesor, sin tomar la revisión anterior como autoridad. Revisar autoría, documentación y colaboración sin asignar a una persona trabajo no demostrado.

Fuentes normativas leídas completas directamente del XML de los DOCX, fuera del repositorio:

- `/workspaces/guia-rubrica/Guia_2_ASIR_CLOUD_Reto4_GITHUB_CODESPACE_AWS_TERRAFORM_DOCKER_SWARM.docx`. SHA-256: `19f93e2fccefc784f9d579e4aef44bcd7039d350e062cd176e28067a86fe1899`.
- `/workspaces/guia-rubrica/Rubrica_2_ASIR_CLOUD_Reto4.docx`. SHA-256: `182a47822d1fb10470714808512662a874d4e177c63fba196aa6f569c4c08763`.

**Límite de alcance:** ambos originales son de Cloud, Producto 6. No permiten comprobar requisitos ni aprobar los Productos 1–5. Se ha inventariado su material visible, pero no se concluye que no exista trabajo fuera del repositorio. No se han localizado aquí sus guías/rúbricas, documentación específica de Sistemas, Redes, BD o Seguridad, ni evidencia suficiente de autoría de IWEB. No se han consultado Drive, Trello o Classroom. Su revisión completa requiere esos materiales; no se añaden requisitos ajenos a Cloud.

## Procedimiento

Se contrastaron los 42 ítems originales con código de Terraform, bootstrap, devcontainer, SSH, Dockerfile, constructor de versiones, stack, scripts, diagrama, documentación y registros de evidencia. Se examinó Git completo disponible, cambios locales, referencias remotas mediante `git ls-remote --heads origin`, ramas y PR en el conector GitHub. La búsqueda inicial de PR del conector omitió la cerrada: se comprobó expresamente PR #2 y se corroboró el listado total con `gh api` de solo lectura. Solo aparecen PR #1 y #2.

El commit base local/remoto de integración antes de publicar esta revisión es `a2675032a9a6fb76e3afb4e75ff127d7290359bb`. Se distinguen archivos del árbol local, archivos confirmados y pruebas históricas; no se presume que lo local esté publicado. Se inspeccionó visualmente la captura personal de Ibai y se contrastaron las descripciones de las restantes con el índice y los registros de autenticación; no se certifica inspección visual individual de todas las imágenes.

Se ejecutó `python3 scripts/validar-entrega.py`: 42 criterios y 0 errores. Ese programa compara enlaces y estados ya escritos: **no valida los requisitos del profesor ni la disponibilidad de AWS**. No se ejecutaron scripts de despliegue, pruebas disruptivas ni Terraform. La [matriz independiente](MATRIZ-REQUISITOS.md) evalúa por separado evidencia y pendientes.

## Alcance del commit documental

Esta carpeta contiene siete archivos: cuatro documentos individuales, este informe general, la matriz y el registro JSON. Las referencias a evidencias todavía no versionadas se muestran como rutas de texto con la indicación «solo local; pendiente de publicación». Existen en el Codespace, pero quedan fuera de este commit. Los enlaces Markdown restantes apuntan a archivos versionados o a archivos de esta misma carpeta. Los enlaces a GitHub requieren acceso al repositorio privado. Los originales del profesor permanecen fuera del repositorio.

## Evidencia

### Revisión por integrante y documentos preparados

| Integrante | Realizado que consta | Verificado en esta revisión | Pendiente principal | Documento |
| --- | --- | --- | --- | --- |
| Cristina · P1/P6 | Repositorio, Codespace, Terraform inicial; trabajo asistido Cloud y accesos propios | Historial Innnx, PR #1, archivos y registros; cuatro accesos con clave propia | Cierre técnico/evidencias Cloud; P1 no evaluable | [Cristina](CRISTINA.md) |
| Enrique · P2/P3 | Revisión documental propia y acceso SSH al manager | Commit 3a67659 y PR #2 con un único documento, huella SSH | Workers, práctica y material de P2/P3; autoría web sin acreditar | [Enrique](ENRIQUE.md) |
| Alexandra · P4 | Clave pública y acceso al manager | Archivos locales y huella SSH; rama sin commits propios | Contribución/PR, workers, práctica y material BD | [Alexandra](ALEXANDRA.md) |
| Ibai · P5 | Clave pública y acceso al manager | Archivos locales, captura y huella SSH; rama existente sin commits propios | Aportar en ibai-revision-individual y abrir PR, workers, práctica y material Seguridad | [Ibai](IBAI.md) |

Los cuatro documentos siguen Objetivo, Procedimiento, Evidencia y Resultado/Conclusión. Son reconstrucciones documentales limitadas a evidencia existente, no sustituyen la práctica individual F13 ni acreditan procedimientos sin registro.

### GitHub: ramas y PR

| Rama remota | SHA corto | Conclusión |
| --- | --- | --- |
| main | 6f3d838 | Base inicial de Cristina |
| cloud-g5-implementacion | a267503 | Integración, incluye PR #2 |
| enrique-revision-documentacion | 3a67659 | Un commit propio de Enrique |
| alexandra-revision-evidencias | 6f3d838 | Igual a main, sin trabajo propio diferenciado |
| ibai-revision-individual | 6f3d838 | Igual a main, sin trabajo propio diferenciado |

[PR #1](https://github.com/Lq922466/reto4-cloud-G5/pull/1): Cristina, integración → main, abierta en borrador. Sirve para publicación global; su destino no es cloud-g5-implementacion. La Guía exige PR de todos, pero no impone ese nombre de rama; el destino de integración es una instrucción del usuario. La PR #1 acredita uso de PR; los originales no exigen otra PR de Cristina hacia una rama concreta ni integrar en main. [PR #2](https://github.com/Lq922466/reto4-cloud-G5/pull/2): Enrique → cloud-g5-implementacion, fusionada el 6 de noviembre, destino correcto. Alexandra e Ibai: sin PR propia en listado completo consultado.

En Git hay 23 commits con autor Innnx, 11 de Codex y 1 de EnriZx2. El recuento no equivale a cantidad de trabajo manual ni evaluación individual. No se asigna autoría sin evidencia a la web recibida en ZIP ni a la seguridad implementada con asistentes.

### Requisitos cumplidos documentalmente y pendientes

Consultar [los 42 criterios](MATRIZ-REQUISITOS.md). «Documentado» siempre queda sujeto a funcionamiento durante la corrección, archivos en el repositorio y captura correspondiente, tal como exige la Rúbrica. No se traslada automáticamente el antiguo resumen 10/17/11/4. F12 queda limitado al alcance de la inspección realizada.

## Resultado/Conclusión

### Errores detectados y correcciones propuestas

| Hallazgo | Corrección propuesta, sin modificar originales |
| --- | --- |
| C3-nodos declara NO CORRECTO; hay tres managers y no un manager líder con tres workers | Acordar y demostrar la topología de C3 y documentar por separado la promoción temporal de E8; ejecutar cambios solo con autorización |
| A6-sin-cambios solo recoge Changes to Outputs y el comprobador declara NO CORRECTO | Conservar la evidencia fallida. Aportar plan completo y distinguir cambios de outputs de cambios de recursos; no afirmar plan limpio por esta captura |
| Fase 5 con registros pero sin todas las capturas normativas antes/durante/después | Completar secuencias con sonda cada segundo; cualquier repetición que altere el servicio requiere autorización |
| Guía mantiene vockey como reserva; B1 de Rúbrica exige sustituirla | Dejar explícita la contradicción y solicitar criterio del profesor antes de retirar accesos |
| Los originales exigen destrucción A6 y funcionamiento en corrección | Ordenar y documentar ambas pruebas con el profesor; no son una incompatibilidad inevitable ni se dispensa el requisito |
| Resúmenes y cuerpo de PR #1 siguen describiendo claves, SSH, laboratorio y solo 11 capturas como en revisión anterior | Actualizar resumen de entrega y PR cuando se autorice publicar; hay 32 entradas actuales, dos declaran NO CORRECTO. Una imagen existente no equivale a requisito cumplido |
| Faltan capturas consola EC2 A2/A3; D3 y capturas personales carecen de todos los comentarios normativos | Obtener capturas reales y comentadas; conservar las imágenes originales; no generar capturas simuladas |
| Claves públicas, nuevas capturas y registros solo locales | Seleccionar, revisar y publicar con autorización. Las claves públicas se exigen; privadas y estado nunca |
| Rama vacía confundible con aportación individual | Alexandra e Ibai deben aportar trabajo real con su identidad y PR a integración |
| Autoría web no acreditada; configuración de seguridad no atribuible a Ibai | Confirmar con archivos fuente y evidencia propia, sin reescribir la autoría Git |
| GESTION.md conserva reflexión pendiente; el validador pasa pese a datos antiguos | Completar reflexión real y actualizar estados. El validador no prueba cumplimiento normativo |
| PR #2 y archivo local de Enrique conservan un corchete extra en CORRECTO | Proponer su corrección a Enrique en una aportación posterior; esta revisión conserva el archivo original y no incluye su modificación |

No se exige Word, Trello, actas semanales ni conexión a base de datos por estos originales. Repetir pruebas con la web definitiva y actualizar las IP para la defensa son propuestas para reforzar evidencia, no nuevos criterios inventados. La Guía y la Rúbrica no prohíben ni regulan asistentes: declarar autoría real y no dar por supuesto rechazo o aprobación del profesor.

### Antes de la entrega final

1. Acreditar invitación del profesor y confirmar plazo oficial: no figura fecha en estos dos originales.
2. Completar aportaciones reales y PR propias de Alexandra e Ibai hacia integración; Ibai utilizará ibai-revision-individual. Cristina ya tiene la PR #1; no se añade como requisito otra PR hacia integración.
3. Enrique, Alexandra e Ibai: completar la acreditación de uso de su clave y acceso por salto a los workers. Las capturas de cada conexión son una propuesta de evidencia, no un número obligatorio fijado por el profesor. Conservar capturas originales y añadir evidencia comentada con prueba, resultado, autor, hostname y fecha/hora.
4. Resolver vockey, topología C3/E8 y momento de destrucción A6; no ejecutar cambios sin autorización. Revisar también regla temporal SSH y su coherencia con Terraform.
5. Completar capturas EC2, navegador y secuencias de fase 5; conservar y explicar los fallos de sonda, sin prometer disponibilidad continua a partir de muestras.
6. Completar reflexión y práctica EC2 previa de cada integrante con su trabajo real.
7. Revisar secretos en archivos y en historial, seleccionar cambios locales, actualizar informe/índices/PR y publicar con autorización. La autorización posterior permite commit y push solo de este paquete documental; los demás cambios siguen excluidos y no se autoriza merge.
8. Ensayar exposición de 10 minutos con arquitectura, código, reparto y caída de nodo en directo; preparar al equipo para preguntas y la demostración técnica individual que solicite el profesor. Mantener laboratorio funcional durante corrección.
9. Para cerrar la revisión de Productos 1–5: localizar sus Guías/Rúbricas y material propio. Hasta entonces su estado es no evaluable, no suspenso ni aprobado.

El [registro de esta revisión](REGISTRO.json) recoge el commit base, las verificaciones antes del commit, los siete archivos autorizados y las dependencias locales excluidas. El resultado de publicación se acredita con el SHA y la referencia remota de Git; el registro no puede incluir el SHA del commit que lo contiene sin alterar ese mismo SHA. Los originales del profesor no se copian ni se modifican.
