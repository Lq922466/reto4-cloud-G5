# Gestión del grupo 5

> **BORRADOR. No entregar todavía.** Lo que aparece como dato procede de GitHub y del historial de Git a 5 de
> noviembre de 2026. Cada campo `[POR COMPLETAR]` debe rellenarlo la persona indicada con información real.
> Ningún reparto, reunión ni aportación se ha deducido o inventado.

## 1. Equipo

Las cuentas son las que tienen acceso al repositorio. Tener acceso no confirma que sean integrantes del grupo.

| Cuenta de GitHub | Permiso | Nombre del integrante | Rol en el grupo | ¿Integrante confirmado? |
| --- | --- | --- | --- | --- |
| Lq922466 | Administrador | `[POR COMPLETAR]` | `[POR COMPLETAR]` | `[POR COMPLETAR]` |
| EnriZx2 | Escritura | `[POR COMPLETAR]` | `[POR COMPLETAR]` | `[POR COMPLETAR]` |
| alexguerth | Escritura | `[POR COMPLETAR]` | `[POR COMPLETAR]` | `[POR COMPLETAR]` |
| ibaiaretxabalaasir-collab | Escritura | `[POR COMPLETAR]` | `[POR COMPLETAR]` | `[POR COMPLETAR]` |

Cuenta del profesor con acceso al repositorio: `[POR COMPLETAR]`. El repositorio es privado.

## 2. Reparto de responsabilidades

El estado técnico procede de [REVISION.md](REVISION.md). Cada responsable debe indicarlo el grupo.

| Bloque | Criterios | Estado técnico | Responsable | Quién revisó |
| --- | --- | --- | --- | --- |
| Repositorio, Codespaces y colaboración | F1–F5 | Parcial en F1 y F2 | `[POR COMPLETAR]` | `[POR COMPLETAR]` |
| Terraform e infraestructura AWS | F6, A1–A6 | Falta la destrucción de A6 | `[POR COMPLETAR]` | `[POR COMPLETAR]` |
| Acceso SSH y seguridad | B1–B5, F12 | Faltan las claves individuales de B1 | `[POR COMPLETAR]` | `[POR COMPLETAR]` |
| Docker Swarm y redes | C1–C4, F7, F8 | Verificado | `[POR COMPLETAR]` | `[POR COMPLETAR]` |
| Web F1 | D1–D3 | Verificado | `[POR COMPLETAR]` | `[POR COMPLETAR]` |
| Pruebas de orquestación | E1–E8 | E4 y E8 solo con el portal provisional | `[POR COMPLETAR]` | `[POR COMPLETAR]` |
| Informe y evidencias | F9, F10 | Estructura preparada, sin Word | `[POR COMPLETAR]` | `[POR COMPLETAR]` |
| Gestión | F11 | Este borrador | `[POR COMPLETAR]` | `[POR COMPLETAR]` |
| Prácticas individuales | F13 | Sin contenido | Cada integrante | `[POR COMPLETAR]` |
| Exposición y defensa | G1–G3 | Sin realizar | Todo el grupo | — |

**Autoría de la web.** Según [REVISION.md](REVISION.md), el contenido de `app/f1` llegó como un ZIP del grupo. Sus autores no constan en Git:
`[POR COMPLETAR]`.

## 3. Seguimiento semanal

Solo la semana del 2 al 8 de noviembre tiene datos, y proceden del historial de Git. No constan actas ni
reuniones. Las semanas anteriores deben añadirse solo si hubo trabajo real.

### Semana del 2 al 8 de noviembre de 2026

| Fecha | Trabajo registrado en Git | Registrado por |
| --- | --- | --- |
| 3 de noviembre | Creación del repositorio y configuración de Codespaces (Fase 0) | Innnx |
| 4 de noviembre | Terraform de AWS (Fase 1) | Innnx |
| 4 de noviembre | Arranque, SSH, Swarm, portal provisional, pruebas E1–E8, revisión de criterios y preparación de la web del ZIP | Codex |
| 4 de noviembre | Apertura de la PR #1 | Cuenta Lq922466 |
| 5 de noviembre | E5, web definitiva, imágenes en Docker Hub, cambio A6, repetición de E1, E2, E3, E6 y E7, y capturas | Innnx, con Claude Code |

- Reuniones de la semana y asistentes: `[POR COMPLETAR]`
- Decisiones tomadas por el grupo: `[POR COMPLETAR]`
- Bloqueos y cómo se resolvieron: `[POR COMPLETAR]`. Las incidencias técnicas están en
  [la estructura del informe](entrega/INFORME-F9-estructura.md#11-incidencias-y-soluciones).
- Tareas para la semana siguiente: consultar [PENDIENTES](entrega/PENDIENTES.md).

### Plantilla para cada semana

```markdown
### Semana del [fecha] al [fecha]

- Reunión: [fecha, medio y asistentes, o «sin reunión»]
- Hecho: [tarea, responsable y enlace a commit, PR o tarjeta de Trello]
- Decisiones: [qué se decidió y por qué]
- Bloqueos: [qué ocurrió y cómo se resolvió]
- Próxima semana: [tarea y responsable]
```

## 4. Trello

El repositorio no contiene ningún enlace, exportación ni captura de Trello, y no se ha podido comprobar si
existe un tablero.

| Dato | Valor |
| --- | --- |
| Enlace al tablero | `[POR COMPLETAR]` |
| Integrantes con acceso | `[POR COMPLETAR]` |
| Acceso del profesor | `[POR COMPLETAR]` |
| Listas del tablero | `[POR COMPLETAR]` |
| Capturas del tablero con fecha | `[POR COMPLETAR]` |

Si el tablero no existe y la Guía lo exige, conviene crearlo con la fecha real. Las tareas de
[PENDIENTES](entrega/PENDIENTES.md) pueden servir como primeras tarjetas. No deben crearse tarjetas que simulen
un seguimiento anterior.

## 5. GitHub

Datos del repositorio `Lq922466/reto4-cloud-G5` hasta el commit `2cca149`.

| Rama | Autor en Git | Commits |
| --- | --- | --- |
| `main` | Innnx | 3 |
| `cloud-g5-implementacion`, además de `main` | Codex | 11 |
| `cloud-g5-implementacion`, además de `main` | Innnx, con `Co-Authored-By` de Claude | 13 |

- **Pull requests:** una, la [PR #1](https://github.com/Lq922466/reto4-cloud-G5/pull/1), abierta desde la cuenta
  Lq922466 hacia `main`, en borrador y sin revisiones.
- **Otras cuentas:** no constan commits ni pull requests de EnriZx2, alexguerth ni ibaiaretxabalaasir-collab en
  este repositorio. Esto no descarta aportaciones hechas fuera de él, como la web del ZIP o Trello.
- **Pendiente:** cada integrante debe aportar su trabajo real desde su propia cuenta.

Flujo para aportar trabajo:

```bash
git switch cloud-g5-implementacion && git pull
git switch -c CUENTA/descripcion-del-cambio
# Hacer el cambio real y confirmarlo con la identidad propia.
git push -u origin CUENTA/descripcion-del-cambio
gh pr create --base cloud-g5-implementacion
```

No se deben hacer commits en nombre de otra persona ni reescribir la autoría del historial.

## 6. Uso de asistentes de IA

El historial muestra commits hechos con asistentes de IA:

- **Codex:** 11 commits de la rama, del 4 de noviembre, con autoría propia.
- **Claude Code:** 13 commits del 5 de noviembre, publicados con la identidad Innnx y la línea `Co-Authored-By`.

Las operaciones sobre AWS, Docker Hub y Swarm del 5 de noviembre se hicieron con autorización expresa dada en la
sesión de trabajo por la persona que la dirigía. Falta confirmar en la Guía o con el profesor cómo debe declararse este uso:
`[POR COMPLETAR]`.

## 7. Reflexión del grupo

Debe escribirla el grupo con su experiencia real.

- Qué funcionó bien en la organización: `[POR COMPLETAR]`
- Qué se haría de otra forma: `[POR COMPLETAR]`
- Qué ha aprendido cada integrante: `[POR COMPLETAR, una entrada por persona]`
