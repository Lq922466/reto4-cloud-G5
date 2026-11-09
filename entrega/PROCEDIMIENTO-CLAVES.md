# Claves SSH de los integrantes (B1)

**Estado a 9 de noviembre, 10:44 UTC: las claves de los cuatro integrantes están instaladas en los cuatro nodos. Cristina ha entrado con la suya en los cuatro nodos, y Enrique, Alexandra e Ibai en manager-g5. Falta el acceso de Enrique, Alexandra e Ibai a los tres workers.**

- **Autorización:** Cristina autorizó los cambios en AWS y en los nodos, que se hicieron por fases y comprobando cada una. [Registro completo](../evidencias/auditoria/registro-2026-11-09-b1.txt).
- **Pendiente:** las tres claves públicas todavía no están en GitHub, y cada paso que cambia AWS, los nodos o GitHub sigue requiriendo autorización expresa de Cristina.

| Hecho comprobado | Cuándo (UTC) | Resultado |
| --- | --- | --- |
| Validación local de las tres claves | 2026-11-09 07:45 | Ed25519 válidas, una línea cada una, sin duplicados entre sí ni con `vockey` o la clave del Codespace. Sin claves privadas en el repositorio ni en su historial |
| `--comprobar` con la clave de Enrique | 2026-11-06 11:04 | `ausente` en los cuatro nodos, con `claves=2`, `vockey=1` y `permisos=600` |
| Consulta de EC2, tras renovar las credenciales | 2026-11-09 08:05 | Las cuatro instancias en `running`, con los mismos ID e IP privadas. Tres aún con las comprobaciones de estado en `initializing`. HTTP 200 en las cuatro IP públicas |
| Regla SSH frente a la IP del Codespace | 2026-11-09 08:05 | El grupo `sg-0c12ecd538a29f8d6` admite `172.166.151.115/32` y el Codespace sale por `172.166.151.114`. SSH a manager-g5: `Connection timed out` |
| Sustitución de la regla del Codespace, autorizada | 2026-11-09 09:22 | Se añadió `172.166.151.114/32` (`sgr-0983f669c504b94f8`), respondieron los cuatro nodos y se retiró `172.166.151.115/32`. Ninguna otra regla cambió |
| `actualizar-ips.sh` | 2026-11-09 09:22 | IP del manager actualizada: de `54.197.30.8` a `107.23.128.135`. Los cuatro alias responden |
| `--comprobar` con las tres claves | 2026-11-09 09:23 | `ausente`, `claves=2`, `vockey=1` y `permisos=600` en los cuatro nodos, y salida 2, como se esperaba |
| `--instalar` con las tres claves, autorizado | 2026-11-09 09:24 | Salida 0 en las tres. `claves=` pasó a 3, 4 y 5. Copias previas `authorized_keys.antes-20261109-*` en cada nodo |
| Verificación posterior | 2026-11-09 09:25 | 5 claves por nodo, sin huellas ni material repetidos. Siguen `vockey` y `reto4-g5-codespace`. Permisos 700 y 600. `--comprobar` da `presente` y salida 0 con las tres |
| Regla temporal de los integrantes, autorizada | 2026-11-09 09:26 | `88.14.93.201/32` (`sgr-01b490492a4242d7a`), con la descripción «Enrique, Alexandra e Ibai, temporal para B1». Sin SSH abierto a `0.0.0.0/0` |
| Comprobación desde el Codespace | 2026-11-09 09:26 | Cuatro nodos `ok/ok`, HTTP 200 en las cuatro IP, Swarm con 4 nodos Ready/Active y `reto4_web` en 4/4. Root y contraseña desactivados. El líder de Swarm es worker2-g5, y no se cambió nada en Swarm |
| Captura conforme `B1-clave-nodos` | 2026-11-09 09:27 | CORRECTO: las tres claves en los cuatro nodos, con `vockey` y la clave del Codespace. [Captura](../evidencias/capturas-conformes/B1-clave-nodos.png) |
| Huellas de los servidores | 2026-11-09, tras la instalación | Leídas en cada nodo: coinciden con la tabla del apartado 3.3 |
| Prueba de los integrantes en manager-g5 | 2026-11-09, de 09:34 a 09:37 | Enrique, Alexandra e Ibai entraron desde PowerShell con `ssh -i`, cada uno con su clave. `auth.log` registra un acceso aceptado con cada huella, y ningún intento fallido. [Capturas](../evidencias/capturas-integrantes/INDICE.md) y [B1-registro-manager](../evidencias/capturas-conformes/B1-registro-manager.png), CORRECTO |
| Prueba de los integrantes en los workers | 2026-11-09, 09:40 | **No hecha:** los tres workers no registran ningún acceso con estas claves |
| Instalación de la clave de Cristina, autorizada | 2026-11-09 09:54 | Huella comprobada, `SHA256:CCR0qvMq…`. Salida 0, y `claves=` pasó de 5 a 6. Siguen todas las anteriores, sin duplicados, con permisos 700 y 600 |
| Captura conforme `B1-clave-nodos`, con las cuatro claves | 2026-11-09 09:56 | CORRECTO: las claves de Cristina, Enrique, Alexandra e Ibai en los cuatro nodos. Sustituye a la de las 09:27, que tenía tres |
| Prueba de Cristina en los cuatro nodos | 2026-11-09, de 10:36 a 10:39 | Con su `config` y su clave: manager-g5 directamente, y los workers por salto. Cada nodo registra un acceso aceptado con su huella, `SHA256:CCR0qvMq…`, y las huellas de los servidores coinciden. [Capturas](../evidencias/capturas-integrantes/INDICE.md), [B1-registro-cristina](../evidencias/capturas-conformes/B1-registro-cristina.png) y `B1-registro-manager` con los cuatro: CORRECTO |
| Workers de Enrique, Alexandra e Ibai | 2026-11-09, 10:42 | **Pendiente:** ningún worker registra un acceso con sus claves |

## Qué se pide

| Fuente | Texto |
| --- | --- |
| Guía, Fase 1 | «Abrir solo puertos 22 (SSH desde aula/alumno), 80 y 8080» |
| Guía, Fase 2 | «Cada alumno usa sus propias claves SSH; la clave vockey queda como acceso de reserva.» |
| Guía, entregables | «/terraform: Código de la infraestructura completo, script de arranque y claves públicas.» |
| Rúbrica, B1 | «Clave propia en 4 nodos; vockey sustituida». Evidencia: «Repositorio; authorized_keys» |
| Guía, capturas | «Debe verse claramente el prompt con el hostname […] y la fecha/hora. Cada captura debe incluir un comentario indicando qué prueba es, el resultado y el autor. Estrictamente prohibido mostrar credenciales de AWS o claves privadas.» |

Este procedimiento conserva `vockey`, como dice la Guía. La Rúbrica la da por sustituida: hay que aclararlo con el profesor.

## Las claves

| Integrante | Archivo | Comentario | Huella (Ed25519, 256 bits) |
| --- | --- | --- | --- |
| Enrique | [`enrique_reto4.pub`](../terraform/claves/enrique_reto4.pub) | `EnriZx2-reto4` | `SHA256:qDmJbNSoN432FHt3g+C6whK0IMM7wxroJOtKo1rZJys` |
| Alexandra | [`alexandra_reto4.pub`](../terraform/claves/alexandra_reto4.pub) | `alexguerth-reto4` | `SHA256:FJm/tkGxAxFBJKam0EQ1C5jpXbQ7konNpo8SRFHl1rs` |
| Ibai | [`ibai_reto4.pub`](../terraform/claves/ibai_reto4.pub) | `ibai-reto4` | `SHA256:zYEmGi4uoe3ljIm8NsFkKSXTcRw3hrm57WiWtjqSyp8` |
| Cristina | [`cristina_reto4.pub`](../terraform/claves/cristina_reto4.pub) | `cristina-reto4` | `SHA256:CCR0qvMqSW8DopOop+RzmuWU7lu/USgKep7m+2fN5zA` |

La clave de Cristina se recibió el 9 de noviembre. Es distinta de la del Codespace, `reto4-g5-codespace`. Con su autorización, se instaló a las 09:54 UTC, tras comprobar su huella. `--comprobar` da `presente` en los cuatro nodos, que tienen 6 claves cada uno, sin duplicados y con permisos 700 y 600. [Registro](../evidencias/auditoria/registro-2026-11-09-b1.txt).

Solo está acreditada la incidencia de un salto de línea de Windows en la clave de Cristina: se retiró sin cambiar su huella, según el [registro](../evidencias/auditoria/registro-2026-11-09-b1.txt). No consta esta incidencia en las claves de Enrique, Alexandra o Ibai. `.gitignore` solo admite archivos `.pub` en esa carpeta, y excluye `*_reto4` en cualquier ruta.

Terraform no lee estos archivos. Las claves de los nodos salen de `ssh_public_keys`, en un archivo local no versionado. Conectarlo a `main.tf` cambiaría `user_data`, lo que puede detener y arrancar las instancias, así que queda como una decisión aparte.

## 1. Antes de instalar

1. **Confirmar cada huella con la persona a la que pertenece, por otra vía**, de viva voz o por un canal distinto al usado para enviar el archivo. Cada clave dará acceso al usuario `ubuntu`, con `sudo`, en los cuatro nodos. Cada integrante lee la suya con `ssh-keygen -lf ~/.ssh/NOMBRE_reto4.pub`.
2. **Recuperar el acceso del Codespace.** Iniciar Learner Lab, renovar `~/.aws/credentials` y ejecutar:
   ```bash
   bash scripts/comprobar-laboratorio.sh
   ```
   Muestra el estado de las cuatro EC2 y, si la regla SSH no coincide con la IP del Codespace, los comandos exactos para sustituirla, sin ejecutarlos. Ejecutarlos requiere autorización. Después:
   ```bash
   bash scripts/actualizar-ips.sh
   ```
3. **Comprobar el punto de partida**, solo con lectura:
   ```bash
   for n in enrique alexandra ibai; do
       bash scripts/instalar-clave-publica.sh --comprobar "terraform/claves/${n}_reto4.pub"; echo "salida=$?"
   done
   ```
   Cada una debe terminar con `salida=2` y mostrar en los cuatro nodos `ausente`, `vockey=1` y `permisos=600`.

## 2. Instalar, solo con autorización expresa

```bash
for n in enrique alexandra ibai; do
    bash scripts/instalar-clave-publica.sh --instalar "terraform/claves/${n}_reto4.pub" || break
done
```

El script comprueba los cuatro nodos antes de cambiar nada, y se detiene si alguno no responde. En cada nodo guarda una copia, `~/.ssh/authorized_keys.antes-FECHA`, añade la clave al final y comprueba que las anteriores siguen intactas. Si no lo están, restaura la copia. No toca `vockey` ni la clave del Codespace, y repetirlo no duplica nada.

Cada instalación debe terminar con código 0 y `presente` en los cuatro nodos. `claves=` sube de una en una: 3, 4 y 5. `vockey=1` y `permisos=600` no cambian.

## 3. Prueba de cada integrante, desde su propio ordenador

Cada integrante usa **solo su propia clave privada**. La privada no sale de su equipo: no se envía, no se copia al Codespace, no se sube al repositorio y no aparece en ninguna captura. Nadie hace esta prueba en nombre de otro.

### 3.1. La IP que hay que autorizar

La regla SSH solo admite la IP del Codespace. Para cada integrante hace falta una regla temporal con **su** IP pública, que obtiene cada integrante en el mismo ordenador y red desde los que hará la prueba:

```bash
curl -s https://checkip.amazonaws.com
```

| Integrante | IP que se autoriza | Regla temporal |
| --- | --- | --- |
| Enrique | `88.14.93.201/32`, compartida | Una sola regla para los tres, `sgr-01b490492a4242d7a`, **abierta el 9 de noviembre a las 09:26 UTC**. Hay que retirarla tras las pruebas |
| Alexandra | `88.14.93.201/32`, compartida | La misma regla |
| Ibai | `88.14.93.201/32`, compartida | La misma regla |

Cristina comunicó el 9 de noviembre que los tres están en la misma red y salen por `88.14.93.201`. Cada integrante debe confirmarlo
con `curl` antes de la prueba. Como comparten IP, el registro del servidor no los distingue por la dirección de origen, sino por la
huella de la clave aceptada.

- Siempre `/32`, una sola dirección. **Nunca `0.0.0.0/0`** ni rangos más amplios.
- Si dos integrantes comparten red, por ejemplo en el aula, tendrán la misma IP y basta una regla.
- En una red móvil la IP puede cambiar. Si la conexión deja de responder, hay que repetir `curl` y cambiar la regla.

### 3.2. Abrir y cerrar el acceso, con autorización

Se abrió el 9 de noviembre, con autorización de Cristina:

```bash
# Literal, 09:26 UTC.
aws ec2 authorize-security-group-ingress --region us-east-1 --group-id sg-0c12ecd538a29f8d6 \
  --ip-permissions 'IpProtocol=tcp,FromPort=22,ToPort=22,IpRanges=[{CidrIp=88.14.93.201/32,Description="Enrique, Alexandra e Ibai, temporal para B1"}]'
```

Hay que retirarla cuando terminen las pruebas de los tres. Requiere autorización:

```bash
aws ec2 revoke-security-group-ingress --region us-east-1 --group-id sg-0c12ecd538a29f8d6 \
  --protocol tcp --port 22 --cidr 88.14.93.201/32
```

Comprobar que solo queda la IP del Codespace:

```bash
aws ec2 describe-security-groups --region us-east-1 --group-ids sg-0c12ecd538a29f8d6 \
  --query 'SecurityGroups[0].IpPermissions[?FromPort==`22`].IpRanges[].[CidrIp,Description]' --output text
```

Mientras exista una regla temporal, `comprobar-laboratorio.sh` avisará de que sobra, y un plan de Terraform propondrá retirarla, porque las reglas están en `main.tf`. No se aplica ese plan. Las capturas A3 y A6 se hacen sin reglas temporales.

### 3.3. Preparar el ordenador de cada integrante

Cada integrante usa **solo su propia clave privada**:

| Integrante | Clave privada en su equipo | Huella que debe ver |
| --- | --- | --- |
| Enrique | `~/.ssh/enrique_reto4` | `SHA256:qDmJbNSoN432FHt3g+C6whK0IMM7wxroJOtKo1rZJys` |
| Alexandra | `~/.ssh/alexandra_reto4` | `SHA256:FJm/tkGxAxFBJKam0EQ1C5jpXbQ7konNpo8SRFHl1rs` |
| Ibai | `~/.ssh/ibai_reto4` | `SHA256:zYEmGi4uoe3ljIm8NsFkKSXTcRw3hrm57WiWtjqSyp8` |

Si su archivo tiene otro nombre, hay que usar ese nombre en `IdentityFile`.

**1. Comprobar la IP y la clave.** El primer resultado debe ser `88.14.93.201`. Si es otro, el acceso no funcionará y hay que avisar a
Cristina antes de seguir. El segundo debe ser la huella de su fila.

Linux, WSL o Git Bash:

```bash
curl -s https://checkip.amazonaws.com
chmod 700 ~/.ssh && chmod 600 ~/.ssh/NOMBRE_reto4
ssh-keygen -y -f ~/.ssh/NOMBRE_reto4 | ssh-keygen -lf -
```

En WSL, la clave debe estar en el `~/.ssh` de Linux y no en `/mnt/c`, para que se respeten los permisos.

Windows, en PowerShell, con el cliente OpenSSH que incluye Windows 10 y 11:

```powershell
(Invoke-WebRequest -UseBasicParsing https://checkip.amazonaws.com).Content.Trim()
icacls "$env:USERPROFILE\.ssh\NOMBRE_reto4" /inheritance:r /grant:r "$($env:USERNAME):(R)"
ssh-keygen -y -f "$env:USERPROFILE\.ssh\NOMBRE_reto4" | Out-File -Encoding ascii "$env:TEMP\comprobar.pub"
ssh-keygen -lf "$env:TEMP\comprobar.pub"; Remove-Item "$env:TEMP\comprobar.pub"
```

`icacls` deja la clave privada legible solo para su usuario. Sin eso, OpenSSH para Windows la rechaza por tener permisos demasiado
abiertos.

**2. Configurar los alias.** Se añade al archivo de configuración de SSH: `~/.ssh/config` en Linux, WSL o Git Bash, y
`C:\Users\USUARIO\.ssh\config` en Windows. Solo cambia `IdentityFile`. La IP del manager es la del 9 de noviembre: si el laboratorio
se reinicia, cambia, y Cristina facilita la nueva, que está en [`config/ssh_config.aplicado`](../config/ssh_config.aplicado).

```text
Host manager-g5
    HostName 107.23.128.135
    HostKeyAlias manager-g5

Host worker1-g5
    HostName 172.31.17.168

Host worker2-g5
    HostName 172.31.29.192

Host worker3-g5
    HostName 172.31.31.183

Host worker?-g5
    ProxyJump manager-g5

Host manager-g5 worker?-g5
    User ubuntu
    IdentityFile ~/.ssh/NOMBRE_reto4
    IdentitiesOnly yes
```

`IdentitiesOnly yes` obliga a usar solo esa clave. Los workers se alcanzan por su IP privada a través del manager, y el cliente
presenta la misma clave en los dos saltos.

**3. Primera conexión.** SSH mostrará la huella de cada servidor y pedirá confirmarla. Debe coincidir con esta tabla, comprobada el 9
de noviembre en los propios nodos. Si no coincide, hay que contestar `no` y avisar.

| Nodo | Huella del servidor (ED25519) |
| --- | --- |
| manager-g5 | `SHA256:N1I1UiUaorsmo0XHIbj2pS+ap/Nzz8dlaZHnEWQOw2Y` |
| worker1-g5 | `SHA256:2j/3XgX7q8BuKwrN311PnGppgaaWitYO04+htQJvtiE` |
| worker2-g5 | `SHA256:j6Yx2EXLreRAoUfgcP3rpIlb8hiUhWzmgieso3k3uBg` |
| worker3-g5 | `SHA256:TI7cmQM83N6MzJJ7e3bi+OSgCHONjkqIurXJyInJxrk` |

**4. Comprobar que el servidor acepta su clave.** Funciona igual en Linux y en Windows:

```bash
ssh -v manager-g5 exit 2>&1 | grep -E "Server accepts key|Authenticated"
```

En PowerShell, `grep` se sustituye por `Select-String -Pattern "Server accepts key|Authenticated"`. Debe aparecer su propia clave,
con la huella del paso 1, y `Authenticated … using "publickey"`.

| Si aparece | Significa |
| --- | --- |
| `Connection timed out` | Su IP no es `88.14.93.201`, el laboratorio está parado o la IP del manager ha cambiado |
| `Permission denied (publickey)` | La clave privada no corresponde a la instalada, o `IdentityFile` apunta a otro archivo |
| `REMOTE HOST IDENTIFICATION HAS CHANGED` | Hay que parar y avisar: no coincide con la huella conocida |

### 3.4. La prueba y su captura

Cada integrante la hace y la captura en su propio equipo. Nadie la hace en nombre de otro.

**Prompt con fecha y hora en el equipo local.** En Linux, WSL o Git Bash:

```bash
export PS1='[\D{%F %T %Z}] \u@\h:\w\$ '
```

En PowerShell:

```powershell
function prompt { "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $env:USERNAME@$env:COMPUTERNAME> " }
```

**En cada uno de los cuatro nodos**, cambiando el nombre en `ssh`:

```bash
ssh manager-g5
export PS1='[\D{%F %T %Z}] \u@\h:\w\$ '
# Evidencia B1-acceso-NOMBRE. Prueba: acceso SSH con mi clave propia a manager-g5. Autor: NOMBRE (cuenta de GitHub).
whoami; hostname; hostname -I | cut -d' ' -f1; sudo -n true && echo "sudo: correcto"
# Resultado: escribir lo que se ha visto, por ejemplo «acceso correcto con mi clave, sin contraseña».
exit
```

Así cada captura muestra el prompt con hostname, fecha y hora, y el comentario con la prueba, el resultado y el autor. Lo ideal es
que cada integrante suba sus imágenes, como `evidencias/capturas-integrantes/B1-acceso-NOMBRE.png`, en una PR desde su cuenta, lo que
además aporta al criterio F2.

**Comprobación independiente desde el Codespace.** Después de la prueba de cada integrante, el registro de cada nodo debe contener un
acceso aceptado con su huella. Como los tres comparten IP, es la huella lo que los distingue:

```bash
ssh manager-g5 "grep -F 'SHA256:HUELLA_DEL_INTEGRANTE' /var/log/auth.log | tail -n 1"
```

Con esto se generan las capturas `B1-registro-enrique`, `-alexandra` e `-ibai` (apartado 4).

## 4. Capturas para acreditar B1

| Captura | Cuándo | Quién la hace | Qué acredita |
| --- | --- | --- | --- |
| `B1-repositorio` | Con las tres claves ya en GitHub | Claude Code | Las tres públicas están en la rama remota, en `/terraform`, y Git excluye las privadas |
| `B1-clave-nodos` | Tras instalar | Claude Code | Las tres huellas están en los cuatro nodos, junto con `vockey` y la clave del Codespace, con permisos 600. **Hecha el 9 de noviembre, con las cuatro claves: CORRECTO** ([captura](../evidencias/capturas-conformes/B1-clave-nodos.png)) |
| `B1-acceso-enrique`, `-alexandra`, `-ibai` | Tras instalar y abrir su regla | **Cada integrante, nadie en su nombre** | Cada integrante entra en los cuatro nodos con su clave. **9 de noviembre: solo manager-g5 y sin comentario** ([capturas](../evidencias/capturas-integrantes/INDICE.md)) |
| `B1-registro-manager` | Tras las pruebas en el manager | Claude Code | manager-g5 registra el acceso de cada integrante con su huella. **Hecha el 9 de noviembre, con los cuatro: CORRECTO** |
| `B1-registro-cristina` | Tras su prueba en los cuatro nodos | Claude Code | **Hecha el 9 de noviembre: CORRECTO** |
| `B1-registro-enrique`, `-alexandra`, `-ibai` | Tras su acceso a los workers. **Pendientes** | Claude Code | Cada uno de los cuatro nodos registra el acceso aceptado con esa huella. La IP de origen se oculta |

Las de Claude Code se generan con `scripts/capturas-norma.py`. Su resultado se calcula con la salida real, y si no es el esperado la captura dice `NO CORRECTO`.

```bash
python3 -I scripts/capturas-norma.py --autor "Claude Code, por encargo de Cristina (Lq922466)" --solo '^B1-repositorio$'
python3 -I scripts/capturas-norma.py --autor "Claude Code, por encargo de Cristina (Lq922466)" --solo '^B1-registro-alexandra$'
```

Están probadas con transcripciones de prueba, incluidos casos que deben fallar, no contra los nodos ni contra GitHub. `B1-repositorio` hace `git fetch` y lee la rama remota, así que requiere que antes se autorice el commit y el push de las tres claves. `ubuntu` puede leer `/var/log/auth.log` sin `sudo` en los cuatro nodos, comprobado el 6 de noviembre. Las capturas `B1-registro-*` deben hacerse antes de que rote el registro.

## Deshacer

Retira solo una clave de los cuatro nodos. Las copias `authorized_keys.antes-FECHA` se quedan en cada nodo.

```bash
material=$(cut -d' ' -f2 terraform/claves/NOMBRE_reto4.pub)
for n in manager-g5 worker1-g5 worker2-g5 worker3-g5; do
    ssh "$n" "sed -i '\\|$material|d' ~/.ssh/authorized_keys"
done
```

## Qué seguirá faltando en B1

- **`vockey`.** Sigue activa, como dice la Guía, y la Rúbrica la da por sustituida. Hay que aclararlo con el profesor.
- **Terraform.** Si se recrean los nodos, las claves no se instalarán solas mientras no estén en `ssh_public_keys`.
- **Las pruebas de cada integrante.** Solo cuentan las que haga cada uno con su propia clave, en su propio equipo. A 9 de noviembre no se ha hecho ninguna.
- **Retirar la regla temporal** `88.14.93.201/32` cuando terminen. Mientras exista, un plan de Terraform propondrá quitarla.
- **Subir las claves a GitHub** para la captura `B1-repositorio`. Requiere autorizar el commit y el push.
