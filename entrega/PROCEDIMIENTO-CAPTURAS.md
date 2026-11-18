# Procedimiento de capturas según la norma

## Qué exige la Guía

Tres normas obligatorias para las capturas:

- Debe verse claramente el prompt con el hostname (ej. `ubuntu@manager-gX`) y la fecha/hora.
- Cada captura debe incluir un comentario indicando qué prueba es, el resultado y el autor.
- Estrictamente prohibido mostrar credenciales de AWS o claves privadas.

La Rúbrica añade que cada requisito puntúa solo si funciona durante la corrección y está respaldado por la captura correspondiente y sus archivos.

## Cómo lo cumple `scripts/capturas-norma.py`

| Norma | Cómo se cumple |
| --- | --- |
| Prompt con hostname y fecha | Abre una sesión real en un terminal, y el propio shell genera el prompt en cada línea: `[2026-11-05 10:53:32 CET] ubuntu@manager-g5:~$` |
| Qué prueba es | El comentario de cabecera indica la evidencia, el criterio y la prueba |
| Resultado | Se **calcula comprobando la salida real**. Si no es la esperada, indica `NO CORRECTO` y se detiene |
| Autor | Es obligatorio indicarlo con `--autor`, y se registra además desde qué cuenta y máquina se ejecuta |
| Sin credenciales | Si la salida contiene identificadores de cuenta, claves o tokens, la captura se descarta y no se guarda |

**Además:**

- **Solo lectura.** Rechaza cualquier comando que modifique el clúster, AWS o el repositorio. Las operaciones disruptivas se ejecutan aparte, con autorización, y el script solo toma las instantáneas.
- **Trazabilidad.** Guarda el texto de la sesión, el SHA-256 de la imagen y los comandos en `manifiesto.json`, y genera [`INDICE.md`](../evidencias/capturas-conformes/INDICE.md).
- **Sin retoques.** No edita ninguna imagen.

## Regla sobre el autor

`--autor` debe ser quien ejecuta realmente la comprobación:

- Si la lanza Claude Code: `--autor "Claude Code, por encargo de Lq922466"`. Lq922466 es la cuenta de GitHub de Cristina.
- Si la lanza un integrante, en su propia sesión: `--autor "Nombre Apellido (cuenta)"`.

**Nunca se debe poner a una persona que no la haya ejecutado.** Las capturas tomadas por asistentes deben figurar como tales. Conviene preguntar al profesor si las admite.

## Uso

Requiere `xterm` e `imagemagick`. Si no hay `DISPLAY`, el script arranca Xvfb.

```bash
python3 -I scripts/capturas-norma.py --listar              # Las 57 capturas del catálogo.
python3 -I scripts/capturas-norma.py --comprobar           # Revisa que solo haya comandos de lectura.
```

| Grupo | Nº | Necesita | Comando |
| --- | --- | --- | --- |
| Local | 11 | Nada de AWS. **Ya generadas**; `F1-repositorio` y `F12-seguridad` se repitieron el 18 de noviembre | `--autor "…" --grupo local` |
| Laboratorio | 22 | Laboratorio activo, credenciales y SSH. 15 se generaron el 6 de noviembre y hay que repetirlas el día de la corrección | `--autor "…" --grupo laboratorio` |
| Pruebas | 17 | Además, `SONDA` con el registro del script, y que se esté ejecutando la prueba autorizada | `--autor "…" --solo '^E4-antes$'` |
| Claves | 7 | Claves en `terraform/claves/` e instaladas (hecho el 9 de noviembre) y prueba de cada integrante. Ya están `B1-clave-nodos`, `B1-registro-cristina` y `B1-registro-manager`. [Procedimiento](PROCEDIMIENTO-CLAVES.md) | `--autor "…" --grupo claves` |

Las capturas D3 son 4 de las 22 del laboratorio. Requieren `CHROME` con la ruta de un navegador gráfico. Se pueden excluir con `--solo`.

**Orden con el laboratorio activo:**

```bash
bash scripts/comprobar-laboratorio.sh      # Estado de EC2, IP, regla SSH, web y SSH. No cambia nada.
bash scripts/actualizar-ips.sh             # Regenera los alias con las IP actuales.
python3 -I scripts/capturas-norma.py --autor "AUTOR REAL" --grupo laboratorio --continuar
```

`--continuar` no oculta nada: cada captura indica su resultado. Sin esa opción, el script se detiene en el primer `NO CORRECTO`. Por ejemplo, la `C3-nodos` del 6 de noviembre dio `NO CORRECTO` porque había tres managers; la topología se corrigió el 9 de noviembre y la captura debe repetirse. `A6-sin-cambios` seguirá en `NO CORRECTO` mientras el plan normal proponga sustituir las instancias por la imagen de Ubuntu nueva (incidencia I1.4 de `PROYECTO.md`). Ver el [plan de C3, E4 y E8](PLAN-C3-E4-E8.md).

## Capturas que no se pueden automatizar

Requieren una sesión iniciada de una persona. Una consola web no tiene prompt: la captura debe mostrar la fecha y hora del sistema, y su comentario debe ir en `PROYECTO.md`.

| Captura | Criterio | Dónde |
| --- | --- | --- |
| Instancias con tipo, estado y controles | A2, E5 | AWS Console → EC2 → Instances |
| Etiqueta `PruebaA6=reto4-g5` | A6 | La misma vista → manager-g5 → Tags |
| Reglas de entrada | A3 | EC2 → Security Groups → `reto4-cloud-g5` → Inbound rules |
| Instancia detenida durante E4 y E8 | E4, E8 | EC2 → Instances, durante la prueba |
| Colaboradores, con el profesor | F1 | GitHub → Settings → Collaborators |
| PR | F2 | GitHub → Pull requests, con las PR #1 a #5, y el historial de `main` |

**Comentario en `PROYECTO.md`:** `Figura N. Prueba. Resultado. Autor. Fecha y hora. Máquina o servicio.`

## Después de capturar

1. Revisar cada resultado en [`INDICE.md`](../evidencias/capturas-conformes/INDICE.md) y mirar las imágenes.
2. Integrarlas en `PROYECTO.md` con su comentario. El texto de `INDICE.md` se puede reutilizar.
3. Ejecutar `python3 scripts/revisar-secretos.py 6f3d838 HEAD` (o `origin/main HEAD` desde una rama nueva) y `python3 scripts/validar-entrega.py`.
