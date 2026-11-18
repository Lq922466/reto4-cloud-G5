# Tareas pendientes para la entrega

Situación revisada el 18 de noviembre de 2026. El último estado técnico registrado es del 9 de noviembre (Swarm, SSH y web) y del 10
de noviembre (Terraform). [Contraste con la Guía y la Rúbrica](CONTRASTE-GUIA-RUBRICA.md). La Guía y la Rúbrica no
indican la fecha de entrega. El grupo se ha fijado como objetivo interno el 20 de noviembre, pero la fecha oficial debe comprobarse en
Classroom: `[POR COMPLETAR]`.

**Estado por criterio:** [checklist final](CHECKLIST-FINAL.md). **Organización del equipo:** [GESTION.md](../GESTION.md).

## 1. Cristina (Lq922466), responsable del Producto 6, Cloud

### Lo más urgente

| # | Tarea | Por qué | Listo cuando |
| --- | --- | --- | --- |
| 1 | Iniciar Learner Lab y renovar `~/.aws/credentials` al empezar cada sesión | Las credenciales caducan con la sesión. La Rúbrica solo puntúa lo que funcione durante la corrección | `aws sts get-caller-identity` responde. **Hecho el 9 de noviembre**, y hay que repetirlo en cada sesión |
| 2 | Sustituir la regla SSH del Codespace cuando cambie su IP | La IP de salida del Codespace no es fija. Es un cambio en AWS, que requiere autorización | Hecho el 9 de noviembre: regla `172.166.151.114/32`. Hay que comprobarla de nuevo en cada sesión con `comprobar-laboratorio.sh` |
| 3 | Consultar al profesor | `vockey`, destrucción de A6, autoría de las capturas, si la práctica es de cada integrante, y la fecha de entrega | Respuestas anotadas en [REVISION.md](../REVISION.md) |
| 3b | Autorizar que se fije la imagen de Ubuntu en Terraform | El `plan` normal del 10 de noviembre propone sustituir las cuatro instancias. **No ejecutar `terraform apply`** hasta corregirlo | Imagen fijada y `terraform plan` con `No changes` |
| 4 | No borrar este Codespace | El estado de Terraform solo está aquí, en `/workspaces/reto4-revision.Geeumo/terraform`, y no debe subirse a Git. Conviene guardar una copia privada | Copia privada hecha |

### Antes de entregar

| # | Tarea | Criterio | Listo cuando |
| --- | --- | --- | --- |
| 5 | Hacer las seis capturas de [REVISION.md](../REVISION.md#capturas-que-faltan), sin mostrar el ID de la cuenta de AWS | A2, A3, A6, E5, F1, F2, F5, F10 | Imágenes en `evidencias/capturas-web/` |
| 6 | Integrantes y nombres | F1, F11, G1 | **Hecho:** Cristina, Enrique, Alexandra e Ibai, en [GESTION.md](../GESTION.md). Falta repartir las partes de la presentación |
| 7 | Invitar al profesor al repositorio antes de la fecha límite | F1 | **Hecho:** `jc-csl` con escritura, comprobado el 18 de noviembre. Falta la captura de Settings → Collaborators en el navegador |
| 8 | Aportar su práctica individual previa y su clave propia | F13, B1 | `practica-individual/Lq922466/` con trabajo real. **Clave propia, `cristina-reto4`, instalada el 9 de noviembre, y acceso con ella a los cuatro nodos demostrado ese día.** Falta repetir las capturas con el comentario de la norma |
| 9 | Decidir cuándo ejecutar la destrucción de A6, tras consultarlo | A6 | Decisión tomada. Recomendación: después de la corrección |
| 10 | Autorizar la repetición de pruebas | E2–E4, E6–E8 | Autorización dada. La topología de C3 ya se corrigió el 9 de noviembre |
| 11 | Revisar e integrar la PR #1 en `main` | F2, F4 | **Hecho el 18 de noviembre.** `main` es la única rama; las PR #3–#5 apuntan a `main` |
| 12 | Revisar en GitHub las funciones de seguridad y si se protege `main` | F12 | Revisado en Settings. El token del Codespace no permite consultarlas |

**No lo exigen ni la Guía ni la Rúbrica:**

- El informe en Word.
- Trello y el seguimiento semanal de los viernes. Son normas internas del grupo y se mantienen como organización, pero no son
  requisitos del profesor.

## 2. Enrique, Alexandra e Ibai

Son los integrantes que recoge la organización del equipo. Nadie debe hacer estas tareas en su nombre.

| # | Tarea | Criterio | Listo cuando |
| --- | --- | --- | --- |
| 1 | Revisar su fila en [GESTION.md](../GESTION.md) y completar el trabajo que ha hecho realmente | F1, F11 | Trabajo real y responsabilidades confirmadas |
| 2 | Indicar qué trabajo ha hecho y aportar su reflexión. En el caso de Enrique, también la autoría de la web F1, que la organización le asigna pero no consta en Git | F11 | Reparto real en [GESTION.md](../GESTION.md) |
| 3 | Aportar sus commits desde su propia cuenta y su propio terminal, y validar su PR (#3, #4 o #5), según las [instrucciones de F2](INSTRUCCIONES-F2-INTEGRANTES.md) | F2 | Commits propios visibles en su PR. Enrique ya tiene la PR #2, hecha desde la web |
| 4 | Aportar su práctica individual previa de EC2 | F13 | `practica-individual/CUENTA/` con trabajo real |
| 5 | Facilitar su clave SSH **pública** y entrar con ella | B1 | **Claves instaladas el 9 de noviembre, y los tres entraron en manager-g5 ese día.** Falta que cada integrante entre en worker1-g5, worker2-g5 y worker3-g5 por salto, como hizo Cristina, con el archivo de configuración del [procedimiento](PROCEDIMIENTO-CLAVES.md#33-preparar-el-ordenador-de-cada-integrante), y capturas con prompt, fecha y comentario |
| 6 | Revisar la PR de otro integrante y las evidencias | F2 | Revisión registrada en GitHub |
| 7 | Preparar las preguntas sobre cualquier parte y su demostración en vivo | G2, G3 | Realizadas ante el profesor |

**Para todo el grupo:** asignar los papeles A–D, ensayar con la [presentación](presentacion-cloud-g5.pptx) y el [guion](DEFENSA.md),
incluida la caída de un nodo en directo, y hacer la exposición (G1). Seguimiento formal cada viernes, y aviso inmediato si surge un
problema urgente.

## 3. Claude Code

### Sin autorización adicional ni AWS

| # | Tarea | Criterio |
| --- | --- | --- |
| 1 | Incorporar a [GESTION.md](../GESTION.md) los datos reales que aporte el grupo | F11 |
| 2 | Repetir la revisión de secretos con `scripts/revisar-secretos.py 6f3d838 HEAD` antes de cada integración | F12, F2 |

**Ya hecho:**

- `~/.ssh/config`, `/config`, los comentarios de los scripts, `scripts/actualizar-ips.sh` y `scripts/comprobar-laboratorio.sh`.
- Las variables de disco y el [procedimiento de capturas](PROCEDIMIENTO-CAPTURAS.md).
- Las capturas conformes del 5 y 6 de noviembre, integradas en `PROYECTO.md` el 9 de noviembre.
- La verificación de las cuatro claves públicas.
- La sincronización del estado de Terraform con `refresh-only` (10 de noviembre), con autorización.
- La revisión de `PROYECTO.md` y de la documentación, el diagrama de un manager y tres workers, y la integración de la PR #1 en `main`
  (18 de noviembre), con autorización.

### Solo lectura, con el laboratorio activo y SSH

| # | Tarea | Criterio |
| --- | --- | --- |
| 1 | Ejecutar `scripts/comprobar-laboratorio.sh` e indicar la regla SSH exacta | Todos. **Hecho el 9 de noviembre** |
| 1b | Generar `B1-registro-*` en los cuatro nodos cuando cada integrante haya entrado en los workers | B1. **Hechas `B1-registro-manager`, con los cuatro, y `B1-registro-cristina`: CORRECTO.** Faltan las de Enrique, Alexandra e Ibai |
| 2 | Repetir la auditoría y un plan de Terraform de solo lectura. El del 10 de noviembre no propone cambios de disco, pero sí sustituir las instancias por la imagen nueva | Fases 1–5, A1, A6 |
| 3 | Repetir las capturas del grupo «laboratorio» antes de entregar, empezando por `C3-nodos`. Las actuales son del 6 de noviembre | A2–A5, B1–B5, C1–C4, D2, D3, E1, E5 |
| 4 | Comprobar las claves de los integrantes con `--comprobar` | B1. **Hecho el 9 de noviembre: `presente` en los cuatro nodos** |

### Solo con autorización expresa de Cristina

| # | Tarea | Motivo |
| --- | --- | --- |
| 1 | Sustituir la regla SSH del Codespace por su IP actual | Cambia AWS. **Hecho el 9 de noviembre** |
| 2 | Instalar las claves públicas de Enrique, Alexandra e Ibai y, si se decide, retirar `vockey` | Cambia los nodos. **Claves instaladas por SSH el 9 de noviembre.** `vockey` sigue, a la espera del profesor |
| 3 | Abrir, para las pruebas de los integrantes, la regla temporal `88.14.93.201/32`, y retirarla después | Cambia AWS. **Abierta el 9 de noviembre. Falta retirarla** |
| 4 | Repetir E4 y E8 según el [plan](PLAN-C3-E4-E8.md). C3 ya se corrigió el 9 de noviembre | Cambia roles de Swarm y detiene instancias |
| 4b | Fijar la imagen de Ubuntu en Terraform y repetir el plan | Cambia el código que gestiona AWS |
| 5 | Repetir E2, E3, E6 y E7 con capturas conformes | Cambia el servicio |
| 6 | Ejecutar `terraform destroy` | Elimina el clúster, de forma irreversible |
| 7 | Subir cambios a `main` o fusionar PR | Afecta a GitHub y a la rama de entrega. **La PR #1 se fusionó el 18 de noviembre** |

**Claude Code no puede hacer:** las capturas con sesión de AWS o GitHub, el trabajo individual de nadie, las decisiones del grupo, la
exposición ni la defensa.
