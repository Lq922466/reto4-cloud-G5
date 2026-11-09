# Revisión de seguridad del repositorio — Ibai

**Producto asignado:** 5 — Seguridad. **Cuenta del integrante:** ibaiaretxabalaasir-collab. **Ejecución de esta revisión:** Codex, el 9 de noviembre de 2026, con identidad Git Innnx y cuenta autorizada Lq922466. No se atribuye a Ibai la ejecución de los comandos ni la configuración histórica realizada con asistentes.

## Objetivo

Comprobar los archivos reales del repositorio y su historial accesible, la exclusión de secretos y la configuración SSH disponible, sin conectar a AWS ni a los nodos.

## Procedimiento

Se ejecutó el detector existente entre origin/main y la base publicada a81b3d5; se revisaron nombres versionados y patrones reales en los blobs de texto del historial. Se probaron exclusiones con `git check-ignore --no-index`, sin `-v`: con reglas negativas, la salida detallada no permite interpretar el estado como exclusión efectiva. Se verificaron las cuatro públicas con ssh-keygen y se leyó la configuración SSH local. El instalador solo se revisó y comprobó con `bash -n`; no se ejecutó.

| Comprobación real | Resultado y límite |
| --- | --- |
| Detector existente en la base publicada | 20.365 líneas añadidas, 375 archivos, 149 imágenes excluidas; cero coincidencias y cero archivos sensibles. Sus exclusiones y patrones delimitan el alcance |
| Historial accesible, patrones de secretos reales | Sin cabeceras de privada ni tokens reales AWS/GitHub/Docker/Swarm detectados. La transcripción conserva el número de blobs revisados en esta ejecución |
| Nombres sensibles en historial | No se localizaron privadas, estado, planes ni credenciales; la plantilla grupo.example.tfvars es la excepción pública prevista |
| git ls-files terraform/claves | Solo cuatro archivos .pub |
| Públicas y huellas | Cuatro Ed25519 válidas, una línea LF y sin CR; coherentes con los registros existentes |
| Exclusiones reales | Privadas, estado, planes, tfvars locales, credenciales, .env y config/ssh.local ignorados; públicas y plantilla de ejemplo permitidas |
| config/sshd_00-reto4.conf | PermitRootLogin no, PasswordAuthentication no y KbdInteractiveAuthentication no; es lectura del fichero del repo, no prueba nueva del servidor |
| Instalador de públicas | Valida tipo y formato; conserva claves anteriores, crea copia previa y comprueba el resultado. Sintaxis Bash válida; sin instalación |

## Evidencia

[Comandos y resultados reales](../evidencias/F2/ibai-terminal.txt), [.gitignore](../.gitignore), [configuración SSH](../config/sshd_00-reto4.conf), [instalador](../scripts/instalar-clave-publica.sh), [registro histórico B4](../evidencias/capturas-conformes/B4-endurecimiento.txt) y [gestión, apartado 7.5](../GESTION.md#75-ibai).

Las huellas públicas coinciden con la tabla de [PROCEDIMIENTO-CLAVES](PROCEDIMIENTO-CLAVES.md#las-claves). Las públicas son entregables exigidos; no son claves privadas. Las IP del laboratorio y las huellas no se presentan como secretos.

## Resultado/Conclusión

No se han encontrado secretos reales ni archivos sensibles dentro del alcance comprobado. El detector no inspecciona imágenes y esta revisión no vuelve a inspeccionar las 149 capturas históricas: no se afirma una garantía absoluta frente a cualquier secreto posible.

El registro histórico B4 acredita permisos remotos 700/600 y restricciones SSH en la fecha registrada; esta sesión no los revalida. Los permisos de las públicas del Codespace no equivalen a permisos de privadas ni de authorized_keys en servidores. vockey sigue autorizada según el registro; se conserva la discrepancia entre Guía y Rúbrica.

**Verificación personal acreditada de Ibai:** acceso al manager con su clave en la captura y el registro del 9 de noviembre. No consta comprobación personal de esta revisión, acceso personal a workers, práctica individual ni defensa realizada. La ejecución de esta revisión y su PR corresponde a Codex bajo la cuenta autorizada. La reflexión personal permanece sin rellenar en GESTION.md.
