# Plan para corregir C3 y completar E4 y E8

**Plan sin ejecutar.** Cambia roles de Swarm y detiene instancias, así que **cada bloque requiere autorización expresa de Lq922466**. Los comandos de este documento no se han lanzado.

## Objetivo

| Criterio | Qué pide la Rúbrica | Situación actual | Resultado buscado |
| --- | --- | --- | --- |
| C3 | 4 nodos activos, manager líder, 3 workers unidos | Tres managers, con `worker1-g5` de líder | `manager-g5` líder y tres workers, con captura conforme |
| E4 | Alta disponibilidad (caída worker). Evidencia: nodo caído; script OK | Registro en texto, con el portal provisional | Repetida con la web definitiva y capturas antes, durante y después |
| E8 | Alta disp. managers (nuevo líder). Evidencia: listado desde otro | Registro en texto, sin estado durante la parada | Repetida con captura desde otro manager durante la parada |

## Orden y motivo

**C3 → E4 → E8 → C3 de nuevo.** Es el orden de la Guía: primero el clúster con manager líder, y después promover dos workers y apagar el líder. Además, `manager-g5` solo vuelve a ser líder bajando a los otros dos managers, y E8 debe terminar en el mismo estado que pide C3.

| Bloque | Acción sobre el sistema | Autorización necesaria | Duración orientativa |
| --- | --- | --- | --- |
| 0. Preparación | Regla SSH con la IP actual | **Sí:** cambia el grupo de seguridad | 5 min |
| 1. C3 | `docker node demote` de dos nodos | **Sí:** cambia roles de Swarm | 5 min |
| 2. E4 | Detener y arrancar `worker3-g5`, y actualización `--force` | **Sí:** prueba disruptiva | 10 min |
| 3. E8 | Promover dos nodos, detener y arrancar `manager-g5` | **Sí:** roles y prueba disruptiva | 15 min |
| 4. C3 final | `docker node demote` de dos nodos y `--force` | **Sí:** cambia roles de Swarm | 5 min |

Puede autorizarse por bloques. Si algo falla, el proceso se detiene y se consulta antes de seguir.

**Autor de las capturas.** El que ejecute cada comprobación. Si las lanza Claude Code, constará `Claude Code, por encargo de Lq922466`. Un integrante solo debe figurar si las ejecuta él mismo.

## Riesgos

| Riesgo | Impacto | Cómo se reduce | Si ocurre |
| --- | --- | --- | --- |
| **Con dos managers, perder uno deja sin cuórum** (bloques 1 y 4) | No se puede gestionar el clúster. Los contenedores siguen funcionando | Ejecutar los dos `demote` seguidos y sin reiniciar nada | Volver a arrancar el manager caído |
| **Con un manager, este es un punto único de fallo** | Mientras esté caído no se gestiona el clúster | Es el diseño inicial de la Guía. No apagar `manager-g5` en ese estado | Arrancarlo |
| **Detener dos managers a la vez en E8** | Pérdida de cuórum | Solo se detiene el líder, y se comprueba antes que hay tres managers | Arrancar los nodos detenidos. `docker swarm init --force-new-cluster` es el último recurso y **requiere autorización aparte** |
| **Fin de la sesión de Learner Lab durante la prueba** | Se detienen todas las instancias y se invalidan las credenciales | Comprobar antes que quedan más de 60 minutos | Reiniciar el laboratorio y volver a verificar |
| **Cambian las IP públicas** del nodo reiniciado | Falla el SSH al manager y dejan de valer esas URL | `scripts/actualizar-ips.sh` tras cada arranque | Regenerar la configuración |
| **Cambia la IP del Codespace** | Se pierde el SSH | Comprobarla antes de cada bloque | Nueva autorización para la regla |
| **Fallos puntuales de la web** al retirar tareas | Muestras fallidas en las sondas | Las sondas no apuntan al nodo que se detiene | Registrarlos. Se detiene si hay tres seguidos en una IP, si no se recuperan las réplicas o si una IP sigue fallando al terminar |
| **Reparto desigual** tras reincorporar un nodo | Un nodo queda sin tareas | Actualización `--force`, ya usada en E6 | Revisar y consultar |
| **`demote` del líder devuelve un error de tiempo** mientras cambia el líder | Salida confusa | Comprobar con `docker node ls` antes de repetir nada | Consultar si el estado no es el esperado |

**No afecta a:** instancias, discos, IP privadas, redes ni imagen del servicio. Terraform solo verá cambios en sus salidas de IP pública. No se ejecuta `terraform destroy`.

## Bloque 0: preparación

```bash
cd /workspaces/reto4-cloud-G5
bash scripts/comprobar-laboratorio.sh      # Solo lectura. Si la regla no coincide, muestra los comandos exactos.
# Con autorización, los comandos que indique para limitar la regla a la IP actual /32:
#   aws ec2 authorize-security-group-ingress --region us-east-1 --group-id sg-0c12ecd538a29f8d6 --protocol tcp --port 22 --cidr IP_CODESPACE/32
#   aws ec2 revoke-security-group-ingress    --region us-east-1 --group-id sg-0c12ecd538a29f8d6 --protocol tcp --port 22 --cidr IP_ANTERIOR/32
bash scripts/actualizar-ips.sh             # Actualiza los alias con las IP actuales.
bash scripts/verificar-despliegue.sh config/ssh.local innnx/reto4-f1 1.0   # 4/4 y HTTP 200 en las cuatro IP.
ssh manager-g5 'docker node ls'            # Anotar quién es el líder.

REG=evidencias/F5-repeticion; mkdir -p "$REG"
AUTOR="Claude Code, por encargo de Lq922466"
CAPTURA="python3 -I scripts/capturas-norma.py --autor \"$AUTOR\""
```

**Se detiene si:** hay menos de 4 nodos listos, el servicio no está en 4/4, o quedan menos de 60 minutos de laboratorio.

## Bloque 1: corregir C3

```bash
# Primero el manager que NO es líder. Se comprueba antes quién es: aquí se supone worker1-g5.
ssh manager-g5 'docker node demote worker2-g5'
ssh manager-g5 'docker node ls'
# En este punto hay dos managers: seguir sin pausa.
ssh manager-g5 'docker node demote worker1-g5'
ssh manager-g5 'docker node ls; docker service ls'
eval "$CAPTURA --solo '^C3-nodos$'"        # Comprueba manager-g5 líder y tres workers.
```

**Resultado esperado:** `manager-g5` Leader, los tres workers sin estado de manager, y el servicio en 4/4. Los contenedores no se reinician.

**Se detiene si:** `manager-g5` no queda como líder o el servicio no está en 4/4.

## Bloque 2: E4, caída de un worker

```bash
IP_M=$(ssh -G manager-g5 | awk '/^hostname /{print $2}')
bash scripts/sondear-web.sh "http://$IP_M/identidad.txt" > "$REG/E4-sonda.txt" &   # Una IP que sigue activa.
SONDEO=$!; export SONDA="$REG/E4-sonda.txt"; sleep 5

eval "$CAPTURA --solo '^E4-antes$'"
aws ec2 stop-instances --region us-east-1 --instance-ids i-0446409b26cf0a662       # Solo worker3-g5.
aws ec2 wait instance-stopped --region us-east-1 --instance-ids i-0446409b26cf0a662
until ssh manager-g5 'docker node ls' | grep -q 'worker3-g5.*Down'; do sleep 3; done
eval "$CAPTURA --solo '^E4-durante$'"      # Nodo Down, estado stopped, tareas reubicadas y sonda correcta.

aws ec2 start-instances --region us-east-1 --instance-ids i-0446409b26cf0a662
aws ec2 wait instance-running --region us-east-1 --instance-ids i-0446409b26cf0a662
until ssh manager-g5 'docker node ls' | grep -q 'worker3-g5.*Ready.*Active'; do sleep 3; done
eval "$CAPTURA --solo '^E4-despues$'"

ssh manager-g5 'docker service update --quiet --detach=false --force reto4_web'    # Reequilibrio, para E5.
eval "$CAPTURA --solo '^E5-reequilibrio$'"
kill "$SONDEO"; grep -c ' FALLO' "$REG/E4-sonda.txt"
```

**Intervención humana:** captura de la consola de EC2 con `worker3-g5` detenido.

**Se detiene si:** el nodo no aparece `Down`, las réplicas no se recuperan, hay tres fallos seguidos en la sonda o el nodo no se reincorpora.

**Se mostrará:** el contador puede indicar `5/4` un momento, como en la prueba anterior.

## Bloque 3: E8, elección de un nuevo líder

**Importante.** Con `manager-g5` apagado **no funciona el salto SSH**, así que `worker1-g5` se consulta directamente por su IP pública, que la misma regla `/32` permite. La sonda no debe apuntar a `manager-g5`.

```bash
ssh manager-g5 'docker node promote worker1-g5 worker2-g5'
ssh manager-g5 'docker node ls'            # manager-g5 Leader, y worker1-g5 y worker2-g5 Reachable.

export IP_WORKER1=$(aws ec2 describe-instances --region us-east-1 --instance-ids i-066a1ad3b7a8e0db9 --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)
bash scripts/sondear-web.sh "http://$IP_WORKER1/identidad.txt" > "$REG/E8-sonda.txt" &
SONDEO=$!; export SONDA="$REG/E8-sonda.txt"; sleep 5

# Registro continuo del líder desde otro manager: permite medir cuándo cambia.
( while true; do date -Is; ssh -n -o ProxyJump=none -o HostName="$IP_WORKER1" -o HostKeyAlias=172.31.17.168 worker1-g5 \
    'docker node ls --format "{{.Hostname}} {{.Status}} {{.ManagerStatus}}"'; sleep 2; done ) > "$REG/E8-lideres.txt" 2>&1 &
LISTADO=$!

eval "$CAPTURA --solo '^E8-antes$'"
aws ec2 stop-instances --region us-east-1 --instance-ids i-0e6ebf2af63facc60       # Solo manager-g5.
aws ec2 wait instance-stopped --region us-east-1 --instance-ids i-0e6ebf2af63facc60
eval "$CAPTURA --solo '^E8-durante$'"      # Instancia stopped y nuevo líder, desde worker1-g5.

aws ec2 start-instances --region us-east-1 --instance-ids i-0e6ebf2af63facc60
aws ec2 wait instance-running --region us-east-1 --instance-ids i-0e6ebf2af63facc60
bash scripts/actualizar-ips.sh             # La IP pública de manager-g5 habrá cambiado.
until ssh manager-g5 'docker node ls' | grep -q 'manager-g5.*Ready.*Active.*Reachable'; do sleep 3; done
eval "$CAPTURA --solo '^E8-despues$'"
kill "$LISTADO" "$SONDEO"; grep -c ' FALLO' "$REG/E8-sonda.txt"
```

**Intervención humana:** captura de la consola de EC2 con `manager-g5` detenido.

**Se detiene si:** no hay tres managers antes de empezar, no aparece un nuevo líder, las réplicas no se recuperan o hay tres fallos seguidos en la sonda.

**Mejora sobre la prueba anterior:** se registra el estado durante la parada, se ve `stopped`, se puede calcular el tiempo de elección con `E8-lideres.txt` y no hay huecos en la sonda.

## Bloque 4: volver al estado de C3

```bash
ssh manager-g5 'docker node ls'            # Anotar quién es el líder. Primero se baja el otro.
ssh manager-g5 'docker node demote NODO_NO_LIDER'
ssh manager-g5 'docker node demote NODO_LIDER'
eval "$CAPTURA --solo '^C3-nodos$'"
ssh manager-g5 'docker service update --quiet --detach=false --force reto4_web'    # Una réplica por nodo.
bash scripts/verificar-despliegue.sh config/ssh.local innnx/reto4-f1 1.0
```

**Si el reparto no queda en una réplica por nodo:** se informa y se consulta, sin improvisar otra operación.

## Después

1. Actualizar [diagramas/arquitectura.md](../diagramas/arquitectura.md), la presentación y el guion, que describen tres managers.
2. Rehacer las capturas de solo lectura con las IP finales.
3. Integrar las capturas en `PROYECTO.md`, y actualizar `REVISION.md` y la checklist.
4. **E2, E3, E6 y E7** se pueden repetir en esa misma sesión con el mismo método: el catálogo de `capturas-norma.py` ya incluye sus instantáneas.
5. Ensayar la caída de nodo para la exposición, que además requiere arrancar y reequilibrar el nodo después.
