# Gestión del grupo 5

> **BORRADOR. No entregar todavía.** Datos a 9 de noviembre de 2026. Proceden de tres fuentes: el documento interno de
> organización del equipo del RETO 4, que no se versiona porque contiene correos personales y un enlace de invitación; GitHub; y el
> historial de Git. Ese documento describe **cómo se ha organizado el trabajo**, y una tarea asignada no significa que esté hecha.
> Por eso este documento distingue entre responsabilidad asignada, trabajo realizado, evidencia y trabajo pendiente. Cada
> `[POR COMPLETAR]` debe rellenarlo la persona indicada. Ningún reparto, reunión ni aportación se ha deducido o inventado.

## 1. Equipo

| Integrante | Cuenta de GitHub | Permiso en el repositorio | Productos asignados en el RETO 4 |
| --- | --- | --- | --- |
| Cristina | [Lq922466](https://github.com/Lq922466). En los commits figura como Innnx, y en Docker Hub como innnx | Administración | 1, Sistemas/Hardware, y **6, Cloud** |
| Enrique | [EnriZx2](https://github.com/EnriZx2) | Escritura | 2, Redes, y 3, IWEB |
| Alexandra | [alexguerth](https://github.com/alexguerth) | Escritura | 4, Bases de Datos |
| Ibai | [ibaiaretxabalaasir-collab](https://github.com/ibaiaretxabalaasir-collab) | Escritura | 5, Seguridad |

Este repositorio es el **Producto 6, Cloud**, asignado a Cristina. Los Productos 8, 9 y 10 se realizarán entre todos. El documento
interno no detalla su contenido ni menciona un Producto 7.

Los permisos son los que mostraba GitHub el 5 de noviembre ([captura](evidencias/capturas-conformes/F1-repositorio.png)). Cuenta del
profesor con acceso al repositorio: `[POR COMPLETAR]`. El repositorio es privado.

## 2. Organización acordada

Resumen del documento interno de organización. Es una **planificación**: lo realmente hecho está en el apartado 3.

### 2.1. Responsabilidades de cada persona

Cada persona se encarga de las configuraciones de sus productos, de comprobar su funcionamiento, de guardar las capturas y de preparar
su documentación. Para cada producto debe guardar:

- los archivos de configuración;
- las capturas del proceso;
- las comprobaciones de funcionamiento;
- los errores encontrados y sus soluciones;
- un documento con los pasos realizados.

### 2.2. Coordinación entre productos

| Quiénes | Qué deben coordinar | Relación con este reto |
| --- | --- | --- |
| Cristina y Enrique | Enrique entrega la web a Cristina para desplegarla en Cloud y Sistemas. Acuerdan cómo se ejecuta y qué archivos necesita, y comprueban que funciona tras el despliegue | Directa: Fase 4 |
| Cristina e Ibai | Medidas de seguridad del acceso remoto a los servidores, y puertos y conexiones necesarios, sobre todo en Cloud | Directa: grupo de seguridad y Fase 2 |
| Enrique e Ibai | Esquema de red y direcciones IP, para que Ibai prepare las reglas del firewall | De otros productos |
| Enrique y Alexandra | Datos que necesita la web para las inscripciones, estructura de la base de datos y, si se decide, conexión con MySQL | De otros productos. La web desplegada aquí no usa base de datos |
| Todos | Participar en las decisiones generales, ayudar a resolver problemas, conocer el funcionamiento básico de todos los productos y preparar la documentación de equipo y la presentación final | Directa: `GESTION.md` y exposición |

### 2.3. Seguimiento y comunicación

- **Seguimiento formal: semanal, preferiblemente los viernes.** Cada integrante informa de su progreso, sin crear un documento nuevo
  cada semana, sino actualizando su propio documento de seguimiento. Incluye:
  - trabajo realizado;
  - trabajo pendiente;
  - problemas encontrados y si se necesita ayuda;
  - próximos objetivos;
  - enlaces a los archivos y evidencias en Google Drive o GitHub.
- **Problemas urgentes: se comunican inmediatamente.** Es lo que corresponde si algo impide continuar o afecta a otra persona, sin
  esperar al seguimiento semanal.
- **Comunicación diaria.** El documento interno propone además una revisión breve diaria del progreso. Es una coordinación informal y
  no sustituye al seguimiento formal semanal.
- **Peticiones entre compañeros.** Si alguien necesita archivos, configuraciones o ayuda de otra persona, lo comunica cuanto antes.

### 2.4. Herramientas

| Herramienta | Uso acordado |
| --- | --- |
| GitHub | Código y archivos de configuración que se puedan publicar de forma segura. El Producto 6 debe tener un repositorio con las capturas personalizadas y comentadas que exige el profesor |
| Google Drive | Documentos Word, diagramas, capturas, informes y presentaciones |
| Trello | Tablero del grupo. El enlace de invitación no se publica aquí, porque da acceso al tablero |
| Classroom | Instrucciones de cada producto y fechas oficiales de cada asignatura |

Para este reto, la Guía exige que el informe, el diagrama y las capturas estén en el repositorio. Drive puede guardar copias, pero no
sustituye al repositorio. Antes de subir cualquier archivo hay que comprobar que no contiene contraseñas, credenciales, claves
privadas ni datos sensibles, y nunca se comparten contraseñas ni claves privadas.

### 2.5. Normas del grupo

- Cumplir las tareas asignadas y avisar cuando haya dificultades.
- Mantener actualizados los archivos y la documentación.
- Comunicar el progreso, de forma formal cada semana y breve cada día.
- No modificar ni eliminar el trabajo de otros compañeros sin avisar.
- Ayudarse y participar en las decisiones importantes.
- No dejar la documentación y las capturas para el último día.
- Entregar individualmente los documentos que correspondan a cada fase del RETO 4.

### 2.6. Fechas internas

Son **objetivos internos del grupo**, no fechas oficiales. Las fechas oficiales se comprueban en Classroom, y la Guía solo indica que el
profesor debe estar invitado al repositorio «antes de la fecha límite».

| Fecha objetivo | Hito interno |
| --- | --- |
| 5 de noviembre | Cuentas, accesos, preparación y planificación inicial |
| 10 de noviembre | Primera versión funcional de los productos |
| 14 de noviembre | Configuraciones principales realizadas |
| 17 de noviembre | Pruebas y documentación técnica |
| 19 de noviembre | Revisión final de archivos y presentación |
| 20 de noviembre | Entrega final, según las indicaciones del profesorado |

## 3. Reparto en el reto CLOUD: asignado, realizado, evidencia y pendiente

El estado técnico de cada criterio está en [REVISION.md](REVISION.md). Aquí se separa **quién tiene asignado** cada bloque, según la
organización del equipo, de **quién hizo realmente** el trabajo, según Git, GitHub y los registros.

Parte del trabajo lo ejecutaron asistentes de IA:

- **Codex**, el 4 de noviembre, con commits de autoría propia.
- **Claude Code**, del 5 al 9 de noviembre, **por encargo de Cristina** y con su autorización expresa para cada operación que cambiaba
  AWS, Docker Hub o Swarm.

Ese trabajo no se atribuye a ninguna otra persona.

| Bloque | Criterios | Responsabilidad asignada | Trabajo realizado que consta | Evidencia | Pendiente |
| --- | --- | --- | --- | --- | --- |
| Repositorio, Codespaces y colaboración | F1–F5 | Cristina, como responsable del Producto 6. La Guía pide además commits y PR de todos | Repositorio, Codespace y commits de las Fases 0 y 1, de Cristina. PR #1, de Cristina. PR #2, de Enrique, con su revisión de la documentación | [F1](evidencias/capturas-conformes/F1-repositorio.png), [F2](evidencias/capturas-conformes/F2-historial.png), [F4](evidencias/capturas-conformes/F4-estructura.png), [F5](evidencias/capturas-conformes/F5-entorno.png), [revisión de Enrique](entrega/REVISION-ENRIQUE.md) | Commits y PR de Alexandra e Ibai. Trabajo desde WSL o Git Bash. Invitar al profesor |
| Terraform e infraestructura AWS | F6, A1–A6 | Cristina | Código de la Fase 1, en un commit de Cristina del 4 de noviembre. Apply inicial del 4 de noviembre. Cambio A6 del 5 de noviembre, con Claude Code | [Registros](evidencias/INDICE.md#fase-1--infraestructura) | Destrucción de A6 |
| Acceso SSH y seguridad | B1–B5, F12 | Cristina, coordinada con Ibai en el acceso remoto y los puertos | Configuración y endurecimiento, con Codex y Claude Code. Enrique, Alexandra e Ibai han entregado sus claves públicas, instaladas el 9 de noviembre por Claude Code con autorización de Cristina | [Evidencias de la Fase 2](evidencias/INDICE.md#fase-2--ssh) y [procedimiento de claves](entrega/PROCEDIMIENTO-CLAVES.md) | Los tres entraron en manager-g5 el 9 de noviembre. Falta que entren en los workers y lo capturen con comentario, y retirar la regla temporal. No consta la coordinación con Ibai |
| Docker Swarm y redes | C1–C4, F7, F8 | Cristina | Formación del clúster y redes, con Codex. Scripts, diagrama y capturas, con Claude Code | [Evidencias de la Fase 3](evidencias/INDICE.md#fase-3--docker-swarm) | Topología de C3 |
| Web F1 | D1–D3 | Enrique entrega la web, y Cristina la despliega | La web llegó como un ZIP del grupo, y su autoría no consta en Git. Imágenes, Docker Hub y despliegue del 5 de noviembre, con Claude Code | [Evidencias de la Fase 4](evidencias/INDICE.md#fase-4--web-e-imágenes-definitiva) | Confirmar quién hizo la web: `[POR COMPLETAR]`. Captura D3 conforme |
| Pruebas de orquestación | E1–E8 | Cristina | Pruebas con el portal provisional el 4 de noviembre, con Codex. Repetición con la web definitiva el 5 de noviembre, con Claude Code | [Evidencias de la Fase 5](evidencias/INDICE.md#fase-5--orquestación) | E4 y E8 con la web definitiva. Capturas conformes |
| Informe y evidencias | F9, F10 | Cristina, para el Producto 6 | `PROYECTO.md` y capturas conformes, con Claude Code. Revisión de enlaces del README, de Enrique | [PROYECTO.md](PROYECTO.md), [capturas conformes](evidencias/capturas-conformes/INDICE.md) | Capturas que faltan |
| Gestión | F11 | Todos: documentación de equipo | Este borrador, redactado con Claude Code por encargo de Cristina | Este documento | Reflexión y seguimiento de cada integrante |
| Prácticas individuales | F13 | Cada integrante | Nada en el repositorio | [Instrucciones](practica-individual/README.md) | La práctica de cada persona |
| Exposición y defensa | G1–G3 | Todos: presentación final | [Material preparado](entrega/DEFENSA.md), sin realizar | — | Repartir partes, ensayar y hacer la exposición |

## 4. Seguimiento semanal

Solo hay datos de la semana del 2 al 8 de noviembre y del inicio de la siguiente, y proceden de Git, GitHub y los registros. En el
repositorio no constan actas ni documentos de seguimiento. Cada integrante debe añadir su seguimiento real, sin reconstruir semanas en
las que no lo hubo.

### Semana del 2 al 8 de noviembre de 2026

| Fecha | Trabajo registrado | Quién |
| --- | --- | --- |
| 3 de noviembre | Creación del repositorio y configuración de Codespaces (Fase 0) | Cristina |
| 4 de noviembre | Terraform de AWS (Fase 1) | Cristina |
| 4 de noviembre | Arranque, SSH, Swarm, portal provisional, pruebas E1–E8, revisión de criterios y preparación de la web del ZIP | Codex |
| 4 de noviembre | Apertura de la PR #1 | Cristina |
| 5 de noviembre | E5, web definitiva, imágenes en Docker Hub, cambio A6, repetición de E1, E2, E3, E6 y E7, y capturas | Claude Code, por encargo de Cristina |
| 5 de noviembre | Auditoría de solo lectura, informe técnico y material de defensa | Claude Code, por encargo de Cristina |
| 6 de noviembre | Revisión de la documentación y de los enlaces del README, en la PR #2 | Enrique |
| 6 de noviembre | Fusión de la PR #2 | Cristina |
| 6 de noviembre | Capturas conformes con el laboratorio activo, y dos sustituciones de la regla SSH | Claude Code, por encargo de Cristina, con su autorización |

- Seguimiento formal del viernes 6 de noviembre: `[POR COMPLETAR]`.
- Decisiones técnicas de Cristina, el 5 de noviembre:
  - Ejecutar la publicación, el despliegue y las pruebas por fases, deteniéndose si falla una comprobación.
  - Aplicar A6 solo con un plan regenerado de 0 altas, 1 cambio y 0 destrucciones.
  - Dejar el servicio en la versión 1.0 tras el rollback.
  - Tratar los fallos HTTP aislados de E3 y E6 como registros, deteniendo la prueba si no se recuperan las réplicas, si una IP sigue
    fallando o si hay tres fallos seguidos en una IP.
  - No repetir E4 ni E8, y no ejecutar `terraform destroy` por ahora.
- Bloqueos y cómo se resolvieron: `[POR COMPLETAR]`. Las incidencias técnicas están en
  [PROYECTO.md](PROYECTO.md#incidencias-y-soluciones).

### Semana del 9 al 15 de noviembre de 2026

| Fecha | Trabajo registrado | Quién |
| --- | --- | --- |
| 9 de noviembre | Claves públicas de Enrique, Alexandra e Ibai, recibidas y verificadas, sin instalar | Las claves son de cada integrante. La verificación la hizo Claude Code, por encargo de Cristina |
| 9 de noviembre | Comprobaciones de solo lectura del laboratorio, y ampliación del README y de `PROYECTO.md` | Claude Code, por encargo de Cristina |
| 9 de noviembre | Sustitución de la regla SSH del Codespace, instalación de las tres claves en los cuatro nodos y regla temporal `88.14.93.201/32` para los integrantes | Claude Code, por encargo de Cristina, con su autorización. [Registro](evidencias/auditoria/registro-2026-11-09-b1.txt) |
| 9 de noviembre | Acceso a manager-g5, cada integrante con su clave, desde PowerShell. El registro del servidor confirma las tres claves | Enrique, Alexandra e Ibai, según sus [capturas](evidencias/capturas-integrantes/INDICE.md) |
| 9 de noviembre | Instalación de la clave propia de Cristina en los cuatro nodos | Claude Code, por encargo de Cristina y con su autorización. [Registro](evidencias/auditoria/registro-2026-11-09-b1.txt) |
| 9 de noviembre | Acceso a los cuatro nodos con su clave propia, los workers por salto. Lo confirma el registro de cada nodo | Cristina, según sus [capturas](evidencias/capturas-integrantes/INDICE.md) |
| Pendiente | Acceso de Enrique, Alexandra e Ibai a los tres workers, con capturas comentadas | Enrique, Alexandra e Ibai |

- Seguimiento formal del viernes 13 de noviembre: `[POR COMPLETAR]`.
- Tareas de la semana: consultar [PENDIENTES](entrega/PENDIENTES.md).

### Plantilla para el seguimiento semanal

```markdown
### Semana del [fecha] al [fecha]: seguimiento del viernes [fecha]

- Trabajo realizado: [tarea, persona y enlace a commit, PR, tarjeta de Trello o archivo]
- Trabajo pendiente: [tarea y persona]
- Problemas encontrados: [qué ocurrió, si se necesitó ayuda y cómo se resolvió]
- Próximos objetivos: [tarea y persona]
- Archivos y evidencias: [enlaces a GitHub o Google Drive]
```

## 5. Trello, Google Drive y GitHub

### Trello

El documento interno incluye un enlace de invitación al tablero del grupo. Desde el repositorio no se ha podido comprobar su
contenido.

| Dato | Valor |
| --- | --- |
| Integrantes con acceso | `[POR COMPLETAR]` |
| Acceso del profesor | `[POR COMPLETAR]` |
| Listas del tablero | `[POR COMPLETAR]` |
| Capturas del tablero con fecha | `[POR COMPLETAR]` |

No deben crearse tarjetas que simulen un seguimiento anterior. Las tareas de [PENDIENTES](entrega/PENDIENTES.md) pueden servir como
tarjetas.

### Google Drive

Según el documento interno, guarda los Word, diagramas, capturas, informes y presentaciones. Desde el repositorio no se ha podido
comprobar su contenido. Para este reto, lo que exige la Guía debe estar también en el repositorio, como se explica en el apartado 2.4.

### GitHub

Datos del repositorio `Lq922466/reto4-cloud-G5` a 9 de noviembre, hasta el commit `a267503`.

| Rama | Autor en Git | Persona | Commits |
| --- | --- | --- | --- |
| `main` | Innnx | Cristina | 3 |
| `cloud-g5-implementacion`, además de `main` | Codex | Asistente de IA | 11 |
| `cloud-g5-implementacion`, además de `main` | Innnx, con `Co-Authored-By` de Claude | Cristina, con Claude Code | 19 |
| `cloud-g5-implementacion`, además de `main` | Innnx: fusión de la PR #2 | Cristina | 1 |
| `cloud-g5-implementacion`, además de `main` | EnriZx2, desde la web de GitHub | Enrique | 1 |

- **Pull requests:**
  - [PR #1](https://github.com/Lq922466/reto4-cloud-G5/pull/1), de Cristina, de `cloud-g5-implementacion` hacia `main`, en borrador.
  - [PR #2](https://github.com/Lq922466/reto4-cloud-G5/pull/2), de Enrique, hacia `cloud-g5-implementacion`, fusionada por Cristina el
    6 de noviembre.
- **Ramas de los integrantes:** `enrique-revision-documentacion`, con el commit de Enrique. `alexandra-revision-evidencias`, creada
  por Alexandra el 6 de noviembre, e `ibai-revision-individual`, creada por Ibai el 9 de noviembre: ambas existen en GitHub, pero
  parten de `main` y no tienen commits propios.
- **Después de `a267503`:** el 9 de noviembre, a las 11:30 UTC, se añadió el commit `56e5a46` con la
  [segunda revisión](entrega/segunda-revision-2026-11-09/README.md). Lleva la identidad Innnx, sin línea `Co-Authored-By`, pero su
  contenido lo preparó Codex, como indica la propia revisión.
- **Sin aportaciones en el repositorio:** no constan commits ni PR de Alexandra ni de Ibai. Esto no descarta trabajo hecho fuera del
  repositorio, como la web del ZIP, Trello o Drive.
- **Pendiente:** cada integrante debe aportar su trabajo real desde su propia cuenta.

Flujo para aportar trabajo. Los pasos detallados para Enrique, Alexandra e Ibai, con sus ramas ya creadas y lo que revisa cada
integrante, están en las [instrucciones de F2](entrega/INSTRUCCIONES-F2-INTEGRANTES.md).

```bash
git switch cloud-g5-implementacion && git pull
git switch -c CUENTA/descripcion-del-cambio
# Hacer el cambio real y confirmarlo con la identidad propia.
git push -u origin CUENTA/descripcion-del-cambio
gh pr create --base cloud-g5-implementacion
```

No se deben hacer commits en nombre de otra persona ni reescribir la autoría del historial.

## 6. Uso de asistentes de IA

| Asistente | Qué consta | Cómo figura en Git |
| --- | --- | --- |
| Codex | 11 commits del 4 de noviembre, y la segunda revisión del 9 de noviembre en el commit `56e5a46` | Los 11 primeros, con autoría propia, `Codex`. El de la segunda revisión, con la identidad Innnx de Cristina y sin línea `Co-Authored-By` |
| Claude Code | 19 commits del 5 de noviembre, y el trabajo del 6 y 9 de noviembre, aún sin commit | Identidad Innnx de Cristina, con la línea `Co-Authored-By` |

Las operaciones sobre AWS, Docker Hub y Swarm se hicieron con autorización expresa de Cristina en cada sesión de trabajo. Las capturas
generadas por Claude Code indican como autor «Claude Code, por encargo de Lq922466», que es la cuenta de Cristina. La Guía y la Rúbrica
no tratan el uso de asistentes. Falta confirmar con el profesor cómo declararlo: `[POR COMPLETAR]`.

## 7. Reflexión del grupo

Debe escribirla el grupo con su experiencia real. Cada integrante completa **solo su subapartado**, desde su rama y con su propia PR,
como explican las [instrucciones de F2](entrega/INSTRUCCIONES-F2-INTEGRANTES.md). Los subapartados van separados por títulos que nadie
modifica, para que las PR de distintas personas no entren en conflicto al integrarse.

### 7.1. Reflexión común

- Qué funcionó bien en la organización: `[POR COMPLETAR: reflexión común]`
- Qué se haría de otra forma: `[POR COMPLETAR: reflexión común]`

### 7.2. Cristina

`[POR COMPLETAR: qué ha aprendido Cristina]`

### 7.3. Enrique

`[POR COMPLETAR: qué ha aprendido Enrique]`

### 7.4. Alexandra

`[POR COMPLETAR: qué ha aprendido Alexandra]`

### 7.5. Ibai

`[POR COMPLETAR: qué ha aprendido Ibai]`
