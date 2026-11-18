# Instrucciones para completar F2: Enrique, Alexandra e Ibai

Preparadas por Claude Code por encargo de Cristina el 9 de noviembre de 2026. Explican **cómo** aportar el trabajo. El contenido de
cada aportación lo escribe cada integrante con lo que haya hecho y comprobado de verdad.

## Qué se pide

| Fuente | Texto literal |
| --- | --- |
| Rúbrica, F2 | «Commits repartidos y uso de Pull Requests por colaboradores». Evidencia: «Historial y PRs» |
| Guía, Fase 0 | «Los demás miembros del equipo utilizarán otros terminales Linux temporales (como WSL o Git Bash) para clonar, trabajar y generar cambios en el proyecto» |
| Guía, Fase 0 | «El flujo de trabajo del resto de miembros implicará hacer git add, commit y push al repositorio remoto y gestionar la integración de su código a través de Pull Requests» |
| Guía, apartado 5 | El repositorio debe «reflejar el trabajo continuo con commits y Pull Requests de todos los miembros» |

Por tanto, para cada integrante debe constar en GitHub:

1. **Commits propios hechos desde Git Bash o WSL** con su identidad. Es lo que pide la Guía. Los commits hechos con «Edit this file»
   en la web de GitHub quedan registrados con el *committer* `GitHub`, como el de la PR #2, y no lo demuestran.
2. **Una pull request propia** hacia `cloud-g5-implementacion`. También lo pide la Guía.

Además, se recomienda, aunque la Guía no fija un número:

3. **Al menos dos commits en momentos distintos**, para que el historial muestre «trabajo continuo» y «commits repartidos».
4. **Una revisión escrita en la PR de otra persona**, en la pestaña *Files changed* → *Review changes*, como muestra del «uso de
   Pull Requests por colaboradores».

## Reglas comunes

- **No empieces hasta que Cristina avise** de que ha subido sus cambios pendientes a `cloud-g5-implementacion`. Si no, partirías
  de una versión antigua y tu PR tendría conflictos.
- Trabaja solo en tu rama. No hagas push a `main` ni a `cloud-g5-implementacion`, no fusiones tu propia PR y no uses nunca
  `--force`, `git reset --hard` ni `git push -f`.
- Documenta solo lo que hayas hecho y visto tú. Si usas un asistente de IA, dilo en la descripción de la PR.
- No subas nunca tu clave privada (`*_reto4`, sin `.pub`), tokens, contraseñas ni capturas en las que se vean.
- Añade los archivos por su nombre (`git add RUTA`), no con `git add .`, y revisa `git status` antes de cada commit.
- Mensajes de commit en castellano, que digan qué cambia.

## Paso 1. Preparar Git Bash o WSL (una sola vez)

```bash
git config --global user.name "TU NOMBRE"
git config --global user.email "CORREO_DE_TU_CUENTA_DE_GITHUB"
git config --global user.name; git config --global user.email
```

El correo debe estar en *GitHub → Settings → Emails*. Así el commit aparece enlazado a tu cuenta. Si allí tienes activado
«Keep my email address private», usa la dirección `…@users.noreply.github.com` que muestra esa misma página.

Para autenticarte, Git for Windows abre el inicio de sesión de GitHub en el navegador la primera vez que haces push. En WSL puedes
usar `gh auth login`. No pegues tokens en archivos ni en capturas.

## Paso 2. Obtener el repositorio actualizado

Si todavía no lo tienes clonado:

```bash
git clone https://github.com/Lq922466/reto4-cloud-G5.git
cd reto4-cloud-G5
```

Si ya lo tienes, guarda primero cualquier cambio local para no perderlo:

```bash
cd reto4-cloud-G5
git status                                   # si aparece algún cambio, ejecuta la línea siguiente
git stash push -u -m "trabajo local antes de F2"
git fetch origin --prune
```

## Paso 3. Crear o actualizar tu rama

Cada integrante sigue solo su apartado.

### Enrique: rama nueva

La PR #2 ya está fusionada, así que hace falta una rama nueva. `--no-track` evita que la rama nueva quede asociada a
`cloud-g5-implementacion`. Así, el primer `git push -u` la asocia a su propia rama remota:

```bash
git switch --no-track -c enrique-correccion-revision origin/cloud-g5-implementacion
```

### Alexandra: `alexandra-revision-evidencias`

La rama existe pero se creó desde `main` y no tiene commits propios. Se adelanta hasta `cloud-g5-implementacion` sin borrar nada:

```bash
git log --oneline origin/cloud-g5-implementacion..origin/alexandra-revision-evidencias   # debe salir vacío
git switch alexandra-revision-evidencias
git log --oneline origin/cloud-g5-implementacion..HEAD                                   # debe salir vacío
git merge --ff-only origin/cloud-g5-implementacion
git push origin alexandra-revision-evidencias
```

### Ibai: `ibai-revision-individual`

Igual que Alexandra, con su rama:

```bash
git log --oneline origin/cloud-g5-implementacion..origin/ibai-revision-individual       # debe salir vacío
git switch ibai-revision-individual
git log --oneline origin/cloud-g5-implementacion..HEAD                                   # debe salir vacío
git merge --ff-only origin/cloud-g5-implementacion
git push origin ibai-revision-individual
```

**Si alguno de los `git log` muestra commits, o si `git merge --ff-only` falla, detente y avisa a Cristina.** No lo arregles con
`reset` ni con `--force`: significaría que hay trabajo que no se debe perder.

Si en el paso 2 guardaste cambios con `git stash`, recupéralos ahora con `git stash pop` y revisa que sean los tuyos.

## Paso 4. Qué archivos revisa o modifica cada integrante

Haz **un commit por cada punto**, con su push, para que el historial refleje trabajo continuo.

### Enrique

| # | Archivo | Qué hacer | Mensaje de commit orientativo |
| --- | --- | --- | --- |
| 1 | `entrega/REVISION-ENRIQUE.md` | En la fila de `CONTRASTE-GUIA-RUBRICA.md`, cambia `[CORRECTO` por `CORRECTO` | `Corrige un corchete suelto en mi revisión` |
| 2 | `entrega/REVISION-ENRIQUE.md` | El README ha cambiado desde el 6 de noviembre. Vuelve a abrir sus enlaces y añade al final un apartado «Segunda comprobación (FECHA)» con lo que veas: qué enlaces abren y cuáles fallan | `Añade la segunda comprobación de los enlaces del README` |
| 3 | `GESTION.md`, subapartado 7.3 | Sustituye `[POR COMPLETAR: qué ha aprendido Enrique]` por tu reflexión real. No toques los títulos ni otros subapartados. Si hiciste la web F1, dilo y explica cómo se puede comprobar | `Añade mi reflexión a GESTION.md` |
| 4 | `practica-individual/EnriZx2/README.md` | Solo si tienes tu práctica previa de EC2: copia [PLANTILLA.md](../practica-individual/PLANTILLA.md) y complétala con tus capturas | `Añade mi práctica individual de EC2` |

### Alexandra

| # | Archivo | Qué hacer | Mensaje de commit orientativo |
| --- | --- | --- | --- |
| 1 | `entrega/REVISION-ALEXANDRA.md` (nuevo) | Revisa [evidencias/INDICE.md](../evidencias/INDICE.md) y [capturas-conformes/INDICE.md](../evidencias/capturas-conformes/INDICE.md). Para cada captura, comprueba que el enlace abre y que se ven el prompt con el hostname, la fecha y hora, y el comentario con prueba, resultado y autor. Anótalo en una tabla con las columnas Evidencia, Comprobación y Resultado (`CORRECTO` o la incidencia que veas) | `Añade mi revisión de las evidencias` |
| 2 | `entrega/REVISION-ALEXANDRA.md` | Añade un apartado de incidencias y conclusión. Si no encuentras ninguna, dilo | `Completa las incidencias y la conclusión de mi revisión` |
| 3 | `GESTION.md`, subapartado 7.4 | Sustituye `[POR COMPLETAR: qué ha aprendido Alexandra]` por tu reflexión real. No toques los títulos ni otros subapartados | `Añade mi reflexión a GESTION.md` |
| 4 | `practica-individual/alexguerth/README.md` | Solo si tienes tu práctica previa de EC2, con la plantilla | `Añade mi práctica individual de EC2` |

### Ibai

| # | Archivo | Qué hacer | Mensaje de commit orientativo |
| --- | --- | --- | --- |
| 1 | `practica-individual/ibaiaretxabalaasir-collab/README.md` (nuevo) | Copia [PLANTILLA.md](../practica-individual/PLANTILLA.md) y complétala con tu práctica previa de EC2 y tus capturas reales. Si no la tienes, sáltate este punto y avisa: no se rellena con trabajo del grupo | `Añade mi práctica individual de EC2` |
| 2 | `entrega/REVISION-IBAI.md` (nuevo) | Revisión de seguridad del repositorio (F12): comprueba que [.gitignore](../.gitignore) excluye claves privadas, `tfstate` y `tfvars`; que en `terraform/claves/` solo hay archivos `.pub`; y lee [config/sshd_00-reto4.conf](../config/sshd_00-reto4.conf). Anota lo que compruebas y su resultado | `Añade mi revisión de seguridad del repositorio` |
| 3 | `GESTION.md`, subapartado 7.5 | Sustituye `[POR COMPLETAR: qué ha aprendido Ibai]` por tu reflexión real. No toques los títulos ni otros subapartados | `Añade mi reflexión a GESTION.md` |

Para el punto 2, en WSL o en un Git Bash con Python se puede ejecutar además `python3 scripts/revisar-secretos.py origin/main HEAD` y
anotar las dos últimas líneas de su salida. Lo esperado es `Coincidencias: 0 []` y `Archivos sensibles: []`.

**Para los tres:** la reflexión común del subapartado 7.1 se acuerda en grupo y la escribe una sola persona, para evitar conflictos.
No editéis los índices de evidencias (`INDICE.md`): los actualiza Cristina después de revisar cada PR.

### Cómo hacer cada commit

```bash
git status
git add RUTA/DEL/ARCHIVO
git diff --cached          # revisa exactamente lo que vas a confirmar
git commit -m "MENSAJE"
git push -u origin NOMBRE_DE_TU_RAMA
```

## Paso 5. Captura de tu terminal (evidencia de F2)

Después del último push, en el mismo terminal. La primera línea cambia el prompt para que cada orden muestre la fecha, la hora y el
nombre del equipo, como exige la norma de capturas de la Guía:

```bash
export PS1='[\D{%F %T %Z}] \u@\h:\w\$ '
echo "# Evidencia F2-terminal-NOMBRE. Prueba: commits y push desde Git Bash/WSL con mi cuenta. Autor: NOMBRE (CUENTA)"
date '+%F %T %Z'; hostname
git log -3 --format='%h %an %ad %s' --date=iso
git status -sb
echo "# Resultado: ESCRIBE LO QUE SE VE"
```

Haz la captura de la ventana entera, sin que se vea ningún token ni clave privada. Guárdala como
`evidencias/capturas-integrantes/F2-terminal-NOMBRE.png` y súbela en un último commit:
`Añade la captura de mi terminal para F2`.

## Paso 6. Abrir la pull request

En GitHub, en *Compare & pull request* o en *Pull requests → New pull request*:

- **base:** `cloud-g5-implementacion` (no `main`). **compare:** tu rama.
- **Título:** qué aporta, por ejemplo «Revisión de evidencias de Alexandra».
- **Descripción:**

```text
Autor: NOMBRE (CUENTA)
Qué cambia: ...
Cómo lo he comprobado: ...
Hecho desde: Git Bash / WSL
Uso de asistentes de IA: ninguno / cuál y para qué
```

No la fusiones. La revisa Cristina, con la ayuda de Claude Code, y la integra cuando esté correcta.

## Paso 7. Revisar la PR de otra persona

| Revisa | La PR de |
| --- | --- |
| Enrique | Alexandra |
| Alexandra | Ibai |
| Ibai | Enrique |

En la PR: *Files changed* → *Review changes* → escribe qué has comprobado → *Comment* o *Approve*. Si ves un error, márcalo en la
línea concreta con un comentario.

## Paso 8. Si te piden correcciones

Haz el cambio en tu misma rama, con un commit nuevo y `git push`. La PR se actualiza sola. No borres la rama ni abras otra PR.
