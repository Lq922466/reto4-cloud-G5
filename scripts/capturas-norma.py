#!/usr/bin/env python3
"""Genera capturas de terminal que cumplen la norma de la Guía, con comandos de solo lectura.

La norma exige ver el prompt con el hostname y la fecha y hora, y un comentario con la prueba, el
resultado y el autor. Para cumplirla, este script:

- Abre una sesión real en un terminal xterm: en el Codespace o por SSH en cada nodo. El prompt es el
  del propio shell, por ejemplo: [2026-11-05 10:53:32 CET] ubuntu@manager-g5:~$
- Calcula el resultado comprobando la salida real. Si no es la esperada, lo indica y se detiene.
- Exige indicar el autor real de la comprobación. Nunca se debe poner a otra persona.
- Rechaza cualquier comando que pueda modificar algo. Las operaciones disruptivas de una prueba las
  ejecuta aparte quien esté autorizado: este script solo toma las instantáneas antes, durante y después.

Uso:
    capturas-norma.py --listar
    capturas-norma.py --autor "Nombre (cuenta)" --grupo local
    capturas-norma.py --autor "Nombre (cuenta)" --solo '^C[234]'

Requiere xterm, ImageMagick y un servidor X. Si DISPLAY no está definido, arranca Xvfb. Las capturas D3
requieren además CHROME con la ruta de un navegador gráfico. Las instantáneas de pruebas requieren SONDA
con la ruta del registro del script que consulta la web.
"""
import argparse
import fcntl
import hashlib
import json
import os
import pty
import re
import select
import shlex
import shutil
import signal
import struct
import subprocess
import sys
import tempfile
import termios
import time
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SALIDA = ROOT / "evidencias/capturas-conformes"
# El prompt lo genera el propio shell, en cada línea: hora, usuario y hostname reales.
PS1 = r"[\D{%F %T %Z}] \u@\h:\w\$ "
PROMPT = re.compile(r"\[\d{4}-\d\d-\d\d \d\d:\d\d:\d\d [^\]]+\] \S+@\S+:\S*[$#] $")
# El prompt demuestra en qué máquina se está, pero el comando escrito no demuestra nada: si se evaluara,
# un patrón como el de «grep 'No changes'» daría por correcta una salida vacía.
ORDEN = re.compile(r"(?m)^(\[\d{4}-\d\d-\d\d \d\d:\d\d:\d\d [^\]]+\] \S+@\S+:\S*[$#] ).*$")
ANSI = re.compile(r"\x1b\[[0-9;?]*[A-Za-z]|\x1b[()][A-Z0-9]|\x1b\][^\x07]*\x07")
COLUMNAS, FILAS_MAX = 150, 54

# Este catálogo nunca debe contener nada que modifique el clúster, AWS o el repositorio.
PROHIBIDO = re.compile(
    r"docker\s+(service\s+(update|scale|rollback|rm|create)|node\s+(update|promote|demote|rm)|stack\s+(deploy|rm)"
    r"|swarm\s+(init|join|leave|update)|network\s+(rm|create|prune)|rm\b|stop\b|kill\b|restart\b|login\b|push\b|pull\b|system\s+prune)"
    r"|terraform\s+.*\b(apply|destroy|import|taint|untaint|state\s+(rm|mv|push))\b"
    r"|aws\s+\S+\s+(?!describe-|get-)\S+"
    r"|\b(stop|start|terminate|reboot)-instances\b|(authorize|revoke)-security-group"
    r"|\bsudo\s+(?!-n\s+true\b|sshd\s+-T\b)|\brm\s+-|\bshutdown\b|\breboot\b|\bpoweroff\b"
    r"|\bgit\s+(push|commit|merge|reset|rebase)\b|\bgh\s+pr\s+(merge|ready|close|edit)\b"
)

# La Guía prohíbe mostrar credenciales. Si la salida contiene algo así, por ejemplo el identificador
# de la cuenta en un error de AWS, la captura se descarta y no se guarda ni la imagen ni el texto.
SENSIBLE = re.compile(
    r"\b\d{12}\b|arn:aws:|assumed-role|voclabs|aws_secret|aws_session_token|AKIA[0-9A-Z]{16}|ASIA[0-9A-Z]{16}"
    r"|BEGIN [A-Z ]*PRIVATE|SWMTKN-1-|dckr_(pat|oat)_|gh[pos]_[A-Za-z0-9]{10}|github_pat_"
)

TF_ESTADO = "/workspaces/reto4-revision.Geeumo/terraform"
AWS_NODOS = "--region us-east-1 --filters 'Name=tag:Name,Values=manager-g5,worker?-g5'"
AWS_TABLA = ("aws ec2 describe-instances " + AWS_NODOS +
             " --query 'Reservations[].Instances[].[Tags[?Key==`Name`]|[0].Value,InstanceType,State.Name,PrivateIpAddress,PublicIpAddress]' --output table")
NODOS = ["manager-g5", "worker1-g5", "worker2-g5", "worker3-g5"]
# Claves públicas de los integrantes (B1), en terraform/claves/NOMBRE_reto4.pub. La huella identifica
# cada clave aunque cambie su comentario.
HUELLAS = {
    "enrique": "SHA256:qDmJbNSoN432FHt3g+C6whK0IMM7wxroJOtKo1rZJys",
    "alexandra": "SHA256:FJm/tkGxAxFBJKam0EQ1C5jpXbQ7konNpo8SRFHl1rs",
    "ibai": "SHA256:zYEmGi4uoe3ljIm8NsFkKSXTcRw3hrm57WiWtjqSyp8",
    "cristina": "SHA256:CCR0qvMqSW8DopOop+RzmuWU7lu/USgKep7m+2fN5zA",
}
PRIVADAS = " ".join(f"terraform/claves/{n}_reto4" for n in HUELLAS)
ESTADO_SERVICIO = ["docker node ls", "docker service ls", "docker service ps --filter desired-state=running reto4_web"]
SONDA = ("local", ['tail -n 6 "$SONDA"'])
CUATRO_LISTOS = r"(?s)manager-g5\s+Ready\s+Active.*worker1-g5\s+Ready\s+Active.*worker2-g5\s+Ready\s+Active.*worker3-g5\s+Ready\s+Active"
TRES_WORKERS = [r"manager-g5\s+Ready\s+Active\s+Leader"] + [rf"worker{n}-g5\s+Ready\s+Active\s+\d" for n in (1, 2, 3)]


def entrada(ident, criterio, prueba, pasos, esperado, correcto, grupo="laboratorio", prohibido=(), web=None):
    return {"id": ident, "criterio": criterio, "prueba": prueba, "pasos": pasos, "esperado": esperado,
            "correcto": correcto, "grupo": grupo, "prohibido": list(prohibido), "web": web}


def instantanea(ident, criterio, prueba, esperado, correcto, nodo="manager-g5", extra=(), prohibido=("FALLO",)):
    """Estado de una prueba, con la sonda visible. La operación disruptiva se ejecuta aparte."""
    pasos = [SONDA] + list(extra) + [(nodo, ESTADO_SERVICIO)]
    return entrada(ident, criterio, prueba, pasos, esperado, correcto, grupo="prueba", prohibido=prohibido)


def replicas(n, imagen="innnx/reto4-f1:1.0"):
    return [rf"reto4_web\s+replicated\s+{n}/{n}\s+{re.escape(imagen)}"]


def en_cada_nodo(patron):
    """Exige el patrón en la salida de cada nodo, sin que lo que responde un nodo cuente para otro."""
    partes = []
    for nodo, siguiente in zip(NODOS, NODOS[1:] + [None]):
        limite = f"(?!@{siguiente}:)" if siguiente else ""
        partes.append(f"@{nodo}:(?:{limite}.)*?{patron}")
    return "(?s)" + ".*?".join(partes)


CATALOGO = [
    # ---------- Sin AWS ni SSH
    entrada("F5-entorno", "F5", "Codespace aprovisionado con AWS CLI y Terraform",
            [("local", ["cat .devcontainer/devcontainer.json", "aws --version", "terraform version | head -n 1", "gh --version | head -n 1"])],
            ["features/aws-cli", "features/terraform", "aws-cli/", "Terraform v"],
            "El devcontainer incluye AWS CLI y Terraform, y ambos funcionan en el Codespace.", "local"),
    entrada("F4-estructura", "F4", "Estructura del repositorio",
            [("local", ["git branch --show-current", "ls -d .devcontainer terraform app config scripts diagramas practica-individual", "ls -p | tr '\\n' ' '; echo"])],
            ["terraform", "app", "config", ".devcontainer"],
            "Existen las carpetas pedidas por la Guía en el repositorio.", "local"),
    entrada("F6-codigo", "F6", "Código Terraform: workers multiplicados con un único recurso",
            [("local", ["sed -n '/Instancias Workers/,/^}/p' terraform/main.tf"])],
            [r"count = var\.worker_count"],
            "Los workers salen de un único recurso multiplicado con count.", "local"),
    entrada("A1-modulo", "A1, F6", "Módulo Terraform con variables y validación",
            [("local", ["ls terraform terraform/scripts", "grep '^variable' terraform/variables.tf | tr '\\n' ' '; echo", "terraform -chdir=terraform validate -no-color"])],
            ["Success! The configuration is valid", "manager_disk_size"],
            "El módulo está organizado, usa variables y terraform validate es correcto.", "local"),
    entrada("A4-script", "A4", "Script de arranque: hostname, zona, claves y Docker",
            [("local", ["grep -nE 'hostnamectl|timedatectl|authorized_keys|PermitRootLogin|PasswordAuthentication|docker.io' terraform/scripts/bootstrap.sh.tftpl | cut -c1-110"])],
            ["hostnamectl", "timedatectl", "authorized_keys", "docker.io"],
            "El script configura hostname, zona horaria, claves públicas, SSH y Docker.", "local"),
    entrada("F7-scripts", "F7", "Scripts comentados",
            [("local", ["ls scripts | tr '\\n' ' '; echo", "sed -n 1,10p scripts/actualizar-ips.sh | cut -c1-120"])],
            ["actualizar-ips.sh", "Qué hace"],
            "Los scripts están en /scripts y explican qué hacen.", "local"),
    entrada("F1-repositorio", "F1", "Repositorio privado y cuentas con acceso",
            [("local", ["gh repo view --json visibility --jq .visibility | cat", "gh api repos/Lq922466/reto4-cloud-G5/collaborators --jq '.[] | [.login, .role_name] | @tsv' | cat"])],
            ["PRIVATE", r"Lq922466\s+admin", "jc-csl", "EnriZx2", "alexguerth", "ibaiaretxabalaasir-collab"],
            "El repositorio es privado y tienen acceso los cuatro integrantes y el profesor (jc-csl). Falta la vista web de Settings.", "local"),
    entrada("F2-historial", "F2", "Historial de commits y PR",
            [("local", ["git log --format='%h %an %ad %s' --date=short -n 8 | cut -c1-110", "git log --all --format='%an' | sort | uniq -c", "gh pr list --state all | cat"])],
            ["Innnx"],
            "Muestra los autores reales: aún faltan commits y PR de los demás integrantes.", "local"),
    entrada("F12-seguridad", "F12", "Sin credenciales, claves ni estado de Terraform",
            [("local", ["git ls-files | grep -Ei 'tfstate|tfplan|[.]pem$|[.]key$|ssh[.]local|[.]tfvars$'", "git check-ignore terraform/terraform.tfvars config/ssh.local", "python3 scripts/revisar-secretos.py 6f3d838 HEAD | tail -n 2"])],
            ["Coincidencias: 0", r"Archivos sensibles: \[\]"],
            "Solo se versiona la plantilla de variables, y la revisión no encuentra secretos.", "local"),
    entrada("D1-dockerhub", "D1", "Etiquetas 1.0 y 2.0 en Docker Hub",
            [("local", ["curl -s 'https://hub.docker.com/v2/repositories/innnx/reto4-f1/tags/?page_size=10' | jq -r '.results|sort_by(.name)[]|[.name,.digest,.tag_status]|@tsv'"])],
            [r"1\.0\s+sha256:622d8343", r"2\.0\s+sha256:1736eda0"],
            "Docker Hub publica las dos etiquetas con los digests construidos.", "local"),
    entrada("B2-plantilla", "B2", "Configuración SSH con nombre corto",
            [("local", ["cat ~/.ssh/config | cut -c1-110", "ls config", "ssh -G manager-g5 2>/dev/null | grep -E '^(user|hostname|hostkeyalias) '", "ssh -G worker1-g5 2>/dev/null | grep -E '^(hostname|proxyjump) '"])],
            ["hostkeyalias manager-g5", "proxyjump manager-g5"],
            "Los alias se resuelven solo con el nombre corto. La conexión real se comprueba en B2-conexion.", "local"),
    # ---------- Con AWS o SSH: solo lectura
    entrada("A2-instancias", "A2", "Instancias, tipos, etiquetas y controles",
            [("local", [AWS_TABLA, "aws ec2 describe-instance-status --region us-east-1 --include-all-instances --instance-ids $(aws ec2 describe-instances " + AWS_NODOS + " --query 'Reservations[].Instances[].InstanceId' --output text) --query 'InstanceStatuses[].[InstanceId,InstanceState.Name,SystemStatus.Status,InstanceStatus.Status]' --output table"])],
            [r"manager-g5\s*\|\s*t3\.medium", r"worker3-g5\s*\|\s*t3\.small", r"running\s*\|\s*ok\s*\|\s*ok"],
            "Un manager t3.medium y tres workers t3.small en ejecución y con los controles correctos."),
    entrada("A3-reglas", "A3", "Reglas de entrada del grupo de seguridad",
            [("local", ["aws ec2 describe-security-groups --region us-east-1 --filters Name=group-name,Values=reto4-cloud-g5 --query 'SecurityGroups[].IpPermissions[].{Desde:FromPort,Hasta:ToPort,Protocolo:IpProtocol,CIDR:join(`,`,IpRanges[].CidrIp),Grupo:join(`,`,UserIdGroupPairs[].GroupId)}' --output table"])],
            [r"/32", r"0\.0\.0\.0/0\s*\|\s*80\b", r"0\.0\.0\.0/0\s*\|\s*8080\b", r"2377", r"4789", r"7946"],
            "Entrada limitada a SSH /32, 80 y 8080 públicos, y puertos internos entre nodos."),
    entrada("A5-salidas", "A5", "Salidas de Terraform con IP pública, IP privada e ID",
            [("local", [f"terraform -chdir=terraform output -no-color -state={TF_ESTADO}/terraform.tfstate nodes"])],
            ["public_ip", "private_ip", '"id"'],
            "La salida nodes muestra IP pública, IP privada e ID de cada nodo. Las IP públicas son las del último apply."),
    entrada("A6-sin-cambios", "A6", "Plan posterior al cambio, sin aplicar nada",
            [("local", [f"terraform -chdir=terraform plan -no-color -compact-warnings -input=false -lock=false -state={TF_ESTADO}/terraform.tfstate -var-file={TF_ESTADO}/reto4-local.auto.tfvars.json -var ssh_cidr=$(curl -s https://checkip.amazonaws.com)/32 | grep -E '^No changes|^Plan:|^Changes to Outputs'"])],
            [r"No changes|Plan: 0 to add, 0 to change, 0 to destroy"],
            "El plan no propone cambios, tampoco con las variables de disco."),
    entrada("A4-arranque", "A4", "Resultado del arranque en los cuatro nodos",
            [(n, ["cloud-init status", "timedatectl show -p Timezone --value", "docker --version"]) for n in NODOS],
            [r"status: done", "Europe/Madrid", "Docker version"],
            "En los cuatro nodos terminó cloud-init, con zona Europe/Madrid y Docker."),
    entrada("B1-claves", "B1", "Claves autorizadas en los cuatro nodos",
            [(n, ["ssh-keygen -lf ~/.ssh/authorized_keys | cut -c1-100"]) for n in NODOS],
            ["reto4-g5-codespace"],
            "Muestra las claves autorizadas realmente en los cuatro nodos."),
    # ---------- Claves de los integrantes (B1). Se ejecutan tras subirlas a GitHub, instalarlas y
    # que cada integrante entre con la suya. Cada B1-registro-* se hace tras la prueba de esa persona.
    entrada("B1-repositorio", "B1", "Claves públicas de los cuatro integrantes en GitHub, con las privadas excluidas de Git",
            [("local", ["git fetch --quiet origin", "git rev-parse --abbrev-ref '@{u}'",
                        "git ls-tree -r --name-only '@{u}' -- terraform/claves",
                        "for n in " + " ".join(HUELLAS) + "; do git show \"@{u}:terraform/claves/${n}_reto4.pub\" | ssh-keygen -lf -; done",
                        "echo \"Archivos de terraform/claves en GitHub que no son .pub: $(git ls-tree -r --name-only '@{u}' -- terraform/claves | grep -cv '[.]pub$')\"",
                        f"git check-ignore {PRIVADAS}"])],
            [r"(?m)^origin/\S+$"]
            + [rf"(?m)^terraform/claves/{n}_reto4\.pub$" for n in HUELLAS]
            + [rf"{re.escape(h)} .*\(ED25519\)" for h in HUELLAS.values()]
            + [r"(?m)^Archivos de terraform/claves en GitHub que no son \.pub: 0$"]
            + [rf"(?m)^terraform/claves/{n}_reto4$" for n in HUELLAS],
            "Las cuatro claves públicas Ed25519 están en la rama de GitHub, en /terraform, y Git excluye las privadas.",
            grupo="claves"),
    entrada("B1-clave-nodos", "B1", "Claves de los cuatro integrantes autorizadas en los cuatro nodos, con vockey de reserva",
            [(n, ["ssh-keygen -lf ~/.ssh/authorized_keys | cut -c1-100", "stat -c '%a %n' ~/.ssh ~/.ssh/authorized_keys"]) for n in NODOS],
            [en_cada_nodo(re.escape(h)) for h in HUELLAS.values()]
            + [en_cada_nodo("vockey"), en_cada_nodo("reto4-g5-codespace"), en_cada_nodo(r"600 /home/ubuntu/\.ssh/authorized_keys")],
            "Las claves de Cristina, Enrique, Alexandra e Ibai están en los cuatro nodos. Se conservan vockey y la clave del Codespace.",
            grupo="claves"),
    *[entrada(f"B1-registro-{n}", "B1", f"Registro de cada nodo: acceso aceptado con la clave de {n.capitalize()}",
              [(nodo, [f"grep -F '{h}' /var/log/auth.log | tail -n 1 | sed -E 's/from [0-9.]+/from [IP oculta]/'"]) for nodo in NODOS],
              [en_cada_nodo(rf"Accepted publickey for ubuntu [^\n]*{re.escape(h)}")],
              f"Cada nodo registra un acceso aceptado con la clave de {n.capitalize()}, que antes hace su propia prueba.",
              grupo="claves")
      for n, h in HUELLAS.items()],
    # Solo manager-g5: acredita las pruebas de los integrantes en el manager, antes de que entren a los workers.
    entrada("B1-registro-manager", "B1", "Registro de manager-g5: acceso aceptado con la clave de cada integrante",
            [("manager-g5", ["grep -F 'Accepted publickey' /var/log/auth.log | grep -F " + " ".join(f"-e '{h}'" for h in HUELLAS.values())
                             + " | sed -E 's/from [0-9.]+ port [0-9]+/from [IP oculta]/'"])],
            [rf"Accepted publickey for ubuntu [^\n]*{re.escape(h)}" for h in HUELLAS.values()],
            "manager-g5 registra un acceso aceptado con la clave de cada integrante: Cristina, Enrique, Alexandra e Ibai.",
            grupo="claves"),
    entrada("B2-conexion", "B2", "Conexión con el nombre corto",
            [("manager-g5", ["hostname"]), ("worker3-g5", ["hostname", "hostname -I"])],
            ["ubuntu@manager-g5", "ubuntu@worker3-g5"],
            "Se entra usando solo el nombre corto, también a un worker por salto."),
    entrada("B3-simultaneo", "B3", "Órdenes simultáneas y control total",
            [("local", ["bash scripts/comprobar-ssh.sh"])] + [(n, ["sudo -n true && echo permisos de sudo: correcto"]) for n in NODOS],
            ["permisos de sudo: correcto", "Docker version"],
            "La misma orden se ejecuta a la vez en los cuatro nodos, y sudo funciona en todos."),
    entrada("B3-copia", "B3", "Copia de archivos con SHA-256 coincidente",
            [("local", ['d=$(mktemp -d); scp -q worker1-g5:/etc/hostname "$d/copia"; sha256sum "$d/copia"']), ("worker1-g5", ["sha256sum /etc/hostname"])],
            [r"[0-9a-f]{64}"],
            "La copia por SCP tiene el mismo SHA-256 que el original. Solo se descarga: no se escribe en el nodo."),
    entrada("B4-endurecimiento", "B4", "Sin root ni contraseña, y permisos",
            [("local", ["stat -c '%a %n' ~/.ssh ~/.ssh/reto4_g5 ~/.ssh/config"])] +
            [(n, ["sudo sshd -T | grep -E '^(permitrootlogin|passwordauthentication) '", "stat -c '%a %n' ~/.ssh ~/.ssh/authorized_keys"]) for n in NODOS],
            ["permitrootlogin no", "passwordauthentication no", r"600 /home/ubuntu/\.ssh/authorized_keys"],
            "Root y contraseña desactivados en los nodos, y permisos 700 y 600."),
    entrada("B5-salto", "B5", "Acceso a los workers por IP privada con salto",
            [("local", ["ssh -G worker1-g5 2>/dev/null | grep -E '^(hostname|proxyjump) '"])] + [(f"worker{n}-g5", ["hostname -I"]) for n in (1, 2, 3)],
            ["proxyjump manager-g5", r"172\.31\.17\.168", r"172\.31\.29\.192", r"172\.31\.31\.183"],
            "Los tres workers se alcanzan por IP privada, a través del manager."),
    entrada("C1-ping", "C1", "Docker y ping por IP privada",
            [("manager-g5", ["docker --version", "for ip in 172.31.17.168 172.31.29.192 172.31.31.183; do ping -c 2 -W 2 $ip | tail -n 3; done"])],
            ["Docker version", r"172\.31\.31\.183 ping statistics", r" 0% packet loss"],
            "Docker funciona, y el ping por IP privada no pierde paquetes."),
    entrada("C2-cluster", "C2", "Clúster por IP privada y MTU 1450",
            [("manager-g5", ['docker info --format "NodeAddr={{.Swarm.NodeAddr}}"', 'docker node inspect --format "{{.Description.Hostname}} {{.Status.Addr}}" manager-g5 worker1-g5 worker2-g5 worker3-g5', 'docker network inspect --format "{{.Name}} driver={{.Driver}} ingress={{.Ingress}} MTU={{index .Options \\"com.docker.network.driver.mtu\\"}}" red-g5'])],
            [r"NodeAddr=172\.31\.", r"red-g5 driver=overlay ingress=true MTU=1450"],
            "El clúster usa IP privadas, y la red ingress red-g5 tiene MTU 1450."),
    entrada("C3-nodos", "C3", "Cuatro nodos activos, manager líder y tres workers",
            [("manager-g5", ["docker node ls"])],
            TRES_WORKERS,
            "Los cuatro nodos están activos, manager-g5 es el líder y los otros tres son workers."),
    entrada("C4-red", "C4", "Red overlay propia para servicios",
            [("manager-g5", ["docker network ls --filter driver=overlay", 'docker network inspect --format "{{.Name}} driver={{.Driver}} ingress={{.Ingress}} MTU={{index .Options \\"com.docker.network.driver.mtu\\"}}" red-app-g5'])],
            [r"red-app-g5 driver=overlay ingress=false MTU=1450"],
            "Existe la red overlay propia red-app-g5, con MTU 1450."),
    entrada("D2-servicio", "D2", "Servicio de cuatro réplicas",
            [("local", ["cat app/stack.yml"]), ("manager-g5", ["docker service ls", "docker service ps --filter desired-state=running reto4_web"])],
            replicas(4) + ["replicas: 4", "restart_policy"],
            "El servicio tiene cuatro réplicas, la red del grupo y política de reinicio."),
    entrada("E1-balanceo", "E1", "Balanceo de carga",
            [("local", ["for ip in $(aws ec2 describe-instances " + AWS_NODOS + " --query 'Reservations[].Instances[].PublicIpAddress' --output text); do for i in 1 2 3 4; do printf '%s ' $ip; curl -s --max-time 5 http://$ip/identidad.txt | tr '\\n' ' '; echo; done; done"])],
            [r"version=1\.0 contenedor="],
            "Las peticiones por las cuatro IP reciben respuesta de contenedores distintos."),
    entrada("E5-estado", "E5", "Nodos y servicio tras el reinicio del laboratorio",
            [("local", [AWS_TABLA]), ("manager-g5", ESTADO_SERVICIO)],
            [CUATRO_LISTOS] + replicas(4),
            "Tras reiniciar el laboratorio, las mismas instancias siguen en el clúster con 4/4."),
    # ---------- Instantáneas de pruebas. La operación disruptiva se ejecuta aparte, con autorización.
    instantanea("E2-replicas-8", "E2", "Escalado a 8 réplicas", replicas(8), "8/8 réplicas, con la sonda respondiendo."),
    instantanea("E2-replicas-12", "E2", "Escalado a 12 réplicas", replicas(12), "12/12 réplicas, con la sonda respondiendo."),
    instantanea("E2-replicas-2", "E2", "Reducción a 2 réplicas", replicas(2), "2/2 réplicas, con la sonda respondiendo."),
    instantanea("E3-antes", "E3", "Autorreparación: antes", replicas(4), "4/4 réplicas antes de eliminar el contenedor."),
    instantanea("E3-despues", "E3", "Autorreparación: después", replicas(4), "Swarm ha sustituido la tarea y vuelve a 4/4."),
    instantanea("E4-antes", "E4", "Caída de un worker: antes", [CUATRO_LISTOS] + replicas(4), "Cuatro nodos activos y 4/4 antes de apagar worker3-g5."),
    instantanea("E4-durante", "E4", "Caída de un worker: durante", [r"\bstopped\b", r"worker3-g5\s+Down"], "worker3-g5 aparece caído, sus tareas se reubican y la web sigue respondiendo.",
                extra=[("local", ["aws ec2 describe-instances --region us-east-1 --instance-ids i-0446409b26cf0a662 --query 'Reservations[].Instances[].State.Name' --output text"])]),
    instantanea("E4-despues", "E4", "Caída de un worker: después", [CUATRO_LISTOS] + replicas(4), "worker3-g5 se ha reincorporado y el servicio está en 4/4."),
    instantanea("E5-reequilibrio", "E5", "Reequilibrio tras la reincorporación", [CUATRO_LISTOS] + replicas(4) + [r"worker3-g5\s+Running"], "worker3-g5 vuelve a tener tareas."),
    instantanea("E6-antes", "E6", "Drain: antes", replicas(4) + [r"worker3-g5\s+Running"], "4/4, con una tarea en worker3-g5."),
    instantanea("E6-durante", "E6", "Drain: durante", replicas(4) + [r"worker3-g5\s+Ready\s+Drain"], "worker3-g5 en Drain y sus tareas en otros nodos."),
    instantanea("E6-despues", "E6", "Drain: después", [CUATRO_LISTOS] + replicas(4), "worker3-g5 vuelve a Active y el servicio está en 4/4."),
    instantanea("E7-version-2", "E7", "Actualización a 2.0", replicas(4, "innnx/reto4-f1:2.0") + [r"version=2\.0"], "La versión 2.0 está en 4/4, sin fallos en la sonda."),
    instantanea("E7-rollback", "E7", "Rollback a 1.0", replicas(4) + [r"version=1\.0"], "Rollback a 1.0 en 4/4, sin fallos en la sonda."),
    instantanea("E8-antes", "E8", "Elección de líder: tres managers antes de apagar el líder", [r"manager-g5\s+Ready\s+Active\s+Leader", r"worker1-g5\s+Ready\s+Active\s+Reachable", r"worker2-g5\s+Ready\s+Active\s+Reachable"], "manager-g5 es el líder y hay otros dos managers.", nodo="worker1-g5"),
    instantanea("E8-durante", "E8", "Elección de líder: durante la parada, visto desde otro manager", [r"\bstopped\b", r"worker[12]-g5\s+Ready\s+Active\s+Leader"], "Con manager-g5 apagado, un nuevo líder aparece desde otro nodo.", nodo="worker1-directo",
                extra=[("local", ["aws ec2 describe-instances --region us-east-1 --instance-ids i-0e6ebf2af63facc60 --query 'Reservations[].Instances[].State.Name' --output text"])]),
    instantanea("E8-despues", "E8", "Elección de líder: después", [r"manager-g5\s+Ready\s+Active\s+Reachable", CUATRO_LISTOS], "manager-g5 vuelve como Reachable, sin ser líder.", nodo="worker1-g5"),
]
# Una captura de navegador por nodo, con la dirección visible y un terminal real debajo.
for nodo in NODOS:
    CATALOGO.append(entrada(f"D3-{nodo}", "D3", f"Web por la IP pública de {nodo}",
                            [("local", ['curl -s -o /dev/null --max-time 5 -w "HTTP %{http_code}\\n" "$URL_WEB"', 'curl -s --max-time 5 "${URL_WEB}identidad.txt"'])],
                            ["HTTP 200", "version="], "La web se sirve por esta IP pública.", web=nodo))


def comprobar_catalogo():
    errores = []
    identificadores = set()
    for e in CATALOGO:
        if e["id"] in identificadores:
            errores.append(f"{e['id']}: repetido")
        identificadores.add(e["id"])
        # El identificador forma el título de la ventana: con acentos, import no la encuentra y se queda esperando.
        if not e["id"].isascii():
            errores.append(f"{e['id']}: el identificador debe ser ASCII")
        for _, comandos in e["pasos"]:
            errores += [f"{e['id']}: comando no permitido: {c}" for c in comandos if PROHIBIDO.search(c)]
    return errores


# ---------- Sesión dentro del terminal


def argv_sesion(host):
    shell = ["bash", "--noprofile", "--norc", "--noediting", "-i"]
    if host == "local":
        return shell
    opciones = ["-q", "-tt", "-o", "BatchMode=yes", "-o", "ConnectTimeout=12", "-o", "StrictHostKeyChecking=yes"]
    alias = host
    if host == "worker1-directo":
        # Con manager-g5 apagado no hay salto: se entra por la IP pública, conservando la clave conocida.
        ip = os.environ["IP_WORKER1"]
        opciones += ["-o", "ProxyJump=none", "-o", f"HostName={ip}", "-o", "HostKeyAlias=172.31.17.168"]
        alias = "worker1-g5"
    return ["ssh", *opciones, alias, f"PS1={shlex.quote(PS1)} exec {' '.join(shell)}"]


def ejecutar_paso(host, comandos, salida, espera=120):
    pid, fd = pty.fork()
    if pid == 0:
        os.environ.update({"PS1": PS1, "TERM": "xterm"})
        os.chdir(ROOT)
        argv = argv_sesion(host)
        os.execvp(argv[0], argv)
    fcntl.ioctl(fd, termios.TIOCSWINSZ, struct.pack("HHHH", FILAS_MAX, COLUMNAS, 0, 0))
    texto = ""

    def leer_hasta_prompt(limite):
        nonlocal texto
        inicio, pendiente = time.time(), ""
        while time.time() - inicio < limite:
            listos, _, _ = select.select([fd], [], [], 0.2)
            if listos:
                try:
                    datos = os.read(fd, 65536)
                except OSError:
                    return False
                if not datos:
                    return False
                salida.buffer.write(datos)
                salida.flush()
                limpio = ANSI.sub("", datos.decode("utf8", "replace")).replace("\r", "")
                texto += limpio
                pendiente += limpio
                if PROMPT.search(pendiente):
                    return True
        return False

    correcto = leer_hasta_prompt(45)
    for comando in comandos if correcto else []:
        os.write(fd, comando.encode() + b"\n")
        if not leer_hasta_prompt(espera):
            correcto = False
            break
    if correcto:
        os.write(fd, b"exit\n")
    try:
        while select.select([fd], [], [], 3)[0]:
            datos = os.read(fd, 65536)
            if not datos:
                break
            salida.buffer.write(datos)
            texto += ANSI.sub("", datos.decode("utf8", "replace")).replace("\r", "")
    except OSError:
        pass
    salida.flush()
    try:
        os.kill(pid, signal.SIGTERM)
    except ProcessLookupError:
        pass
    os.waitpid(pid, 0)
    return texto, correcto


def sesion(args):
    """Se ejecuta dentro del xterm: escribe el comentario, abre las sesiones y evalúa el resultado."""
    e = next(x for x in CATALOGO if x["id"] == args.sesion)
    inicio = datetime.now(timezone.utc)
    ejecutor = f"{os.environ.get('USER', 'vscode')}@{os.uname().nodename}"
    cabecera = (f"# Evidencia {e['id']} · Criterio {e['criterio']} · RETO 4 CLOUD, Grupo 5\n"
                f"# Prueba: {e['prueba']}\n"
                f"# Autor: {args.autor} · Ejecutado desde: {ejecutor}\n")
    sys.stdout.write(cabecera)
    sys.stdout.flush()
    transcripcion, todo_correcto = cabecera, True
    for host, comandos in e["pasos"]:
        texto, correcto = ejecutar_paso(host, comandos, sys.stdout)
        transcripcion += texto
        todo_correcto = todo_correcto and correcto
    salida_real = ORDEN.sub(r"\1", transcripcion[len(cabecera):])
    faltan = [r for r in e["esperado"] if not re.search(r, salida_real)]
    sobran = [r for r in e["prohibido"] if re.search(r, salida_real)]
    if todo_correcto and not faltan and not sobran:
        estado, detalle = "CORRECTO", e["correcto"]
    else:
        partes = [] if todo_correcto else ["una sesión no terminó bien"]
        partes += [f"falta: {r}" for r in faltan] + [f"aparece: {r}" for r in sobran]
        estado, detalle = "NO CORRECTO", "; ".join(partes)
    pie = f"# Resultado: {estado}. {detalle}\n"
    sys.stdout.write("\n" + pie)
    sys.stdout.flush()
    transcripcion += "\n" + pie
    sensible = bool(SENSIBLE.search(transcripcion))
    if not sensible:
        Path(args.salida, e["id"] + ".txt").write_text(transcripcion)
    Path(args.marca).write_text(json.dumps({
        "sensible": sensible,
        "id": e["id"], "criterio": e["criterio"], "prueba": e["prueba"], "resultado": estado, "detalle": detalle,
        "autor": args.autor, "ejecutado_desde": ejecutor, "inicio_utc": inicio.isoformat(timespec="seconds"),
        "comandos": [{"maquina": h, "comandos": c} for h, c in e["pasos"]],
    }, ensure_ascii=False))
    # Ajusta el alto de la ventana al contenido, salvo en las capturas con navegador.
    if not e["web"]:
        lineas = sum(max(1, (len(l) - 1) // COLUMNAS + 1) for l in transcripcion.splitlines())
        filas = min(FILAS_MAX, max(12, lineas + 1))
        sys.stdout.write(f"\x1b[8;{filas};{COLUMNAS}t")
        sys.stdout.flush()
    time.sleep(600)


# ---------- Orquestación


def ip_publica(nodo):
    variable = "IP_" + nodo.split("-")[0].upper()
    if os.environ.get(variable):
        return os.environ[variable]
    return subprocess.run(
        ["aws", "ec2", "describe-instances", "--region", "us-east-1", "--filters", f"Name=tag:Name,Values={nodo}",
         "Name=instance-state-name,Values=running", "--query", "Reservations[0].Instances[0].PublicIpAddress", "--output", "text"],
        capture_output=True, text=True, check=True).stdout.strip()


def capturar(e, args, salida):
    titulo = f"evidencia-{e['id']}-{os.getpid()}"
    with tempfile.TemporaryDirectory() as temporal:
        marca = Path(temporal, "marca.json")
        env = dict(os.environ)
        navegador, perfil = None, None
        geometria = f"{COLUMNAS}x{FILAS_MAX}+0+0"
        if e["web"]:
            if not os.environ.get("CHROME"):
                sys.exit("Las capturas D3 requieren CHROME con la ruta de un navegador gráfico.")
            url = f"http://{ip_publica(e['web'])}/"
            env["URL_WEB"] = url
            perfil = Path(temporal, "perfil")
            navegador = subprocess.Popen(
                [os.environ["CHROME"], "--no-sandbox", "--test-type", "--lang=es", "--accept-lang=es", "--no-first-run", "--no-default-browser-check",
                 "--disable-sync", "--password-store=basic", f"--user-data-dir={perfil}",
                 "--disable-features=Translate,HttpsUpgrades,HttpsFirstBalancedModeAutoEnable,HttpsFirstModeV2",
                 "--window-position=0,0", "--window-size=1400,740", url],
                env={**env, "LANGUAGE": "es"}, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            geometria = f"{COLUMNAS}x16+0+745"
        terminal = subprocess.Popen(
            ["xterm", "-fa", "DejaVu Sans Mono", "-fs", "11", "-bg", "black", "-fg", "white", "-T", titulo, "-geometry", geometria,
             "-xrm", "XTerm*allowWindowOps: true", "-e", sys.executable, "-I", str(Path(__file__).resolve()),
             "--sesion", e["id"], "--autor", args.autor, "--salida", str(salida), "--marca", str(marca)], env=env)
        try:
            limite = time.time() + 600
            while not marca.exists() or not marca.read_text():
                if time.time() > limite or terminal.poll() is not None:
                    sys.exit(f"{e['id']}: la sesión no terminó.")
                time.sleep(0.3)
            registro = json.loads(marca.read_text())
            if registro.pop("sensible"):
                return {**registro, "resultado": "DESCARTADA", "detalle": "la salida contenía datos sensibles y no se ha guardado"}
            time.sleep(8 if e["web"] else 0.8)
            imagen = salida / f"{e['id']}.png"
            objetivo = ["root"] if e["web"] else [titulo]
            subprocess.run(["import", "-window", *objetivo, str(imagen)], check=True, env=env, timeout=60)
            registro["captura"] = imagen.name
            registro["sha256"] = hashlib.sha256(imagen.read_bytes()).hexdigest()
            if e["web"]:
                registro["url"] = env["URL_WEB"]
            return registro
        finally:
            terminal.kill()
            terminal.wait()
            if navegador:
                navegador.kill()
                navegador.wait()


def escribir_indice(salida):
    manifiesto = salida / "manifiesto.json"
    registros = json.loads(manifiesto.read_text()) if manifiesto.exists() else {}
    lineas = ["# Capturas conformes a la norma de la Guía", "",
              "Generadas con `scripts/capturas-norma.py`. Cada captura muestra el prompt real con el hostname y la fecha y hora, y un comentario con la prueba, el resultado y el autor.",
              "El resultado se calcula comprobando la salida real. Junto a cada imagen hay un `.txt` con la misma salida.", "",
              "| Evidencia | Criterio | Prueba | Resultado | Autor | Hora (UTC) |", "| --- | --- | --- | --- | --- | --- |"]
    for r in sorted(registros.values(), key=lambda x: x["id"]):
        lineas.append(f"| [{r['id']}]({r['captura']}) | {r['criterio']} | {r['prueba']} | {r['resultado']}: {r['detalle'].replace('|', chr(92) + '|')} | {r['autor']} | {r['inicio_utc'][:19].replace('T', ' ')} |")
    (salida / "INDICE.md").write_text("\n".join(lineas) + "\n")


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--autor", help="Autor real de la comprobación: nunca otra persona")
    parser.add_argument("--grupo", choices=["local", "laboratorio", "prueba", "claves"])
    parser.add_argument("--solo", help="Expresión regular con los identificadores que se quieren capturar")
    parser.add_argument("--salida", default=str(SALIDA))
    parser.add_argument("--continuar", action="store_true", help="No detenerse si una comprobación no es correcta")
    parser.add_argument("--listar", action="store_true")
    parser.add_argument("--comprobar", action="store_true", help="Revisar que el catálogo solo tenga comandos de lectura")
    parser.add_argument("--sesion", help=argparse.SUPPRESS)
    parser.add_argument("--marca", help=argparse.SUPPRESS)
    args = parser.parse_args()

    errores = comprobar_catalogo()
    if errores:
        sys.exit("\n".join(errores))
    if args.sesion:
        return sesion(args)
    if args.comprobar:
        print(f"Catálogo correcto: {len(CATALOGO)} capturas, solo con comandos de lectura.")
        return 0
    elegidas = [e for e in CATALOGO if (not args.grupo or e["grupo"] == args.grupo) and (not args.solo or re.search(args.solo, e["id"]))]
    if args.listar:
        for e in elegidas:
            print(f"{e['id']:<20} {e['grupo']:<12} {e['criterio']:<8} {e['prueba']}")
        return 0
    if not args.autor or len(args.autor.strip()) < 3:
        sys.exit("Indica con --autor quién hace realmente la comprobación. No se debe atribuir a otra persona.")
    if not elegidas or not (args.grupo or args.solo):
        sys.exit("Indica qué capturar con --grupo o --solo. Usa --listar para ver el catálogo.")
    for e in elegidas:
        if e["grupo"] == "prueba" and not os.path.isfile(os.environ.get("SONDA", "")):
            sys.exit(f"{e['id']}: define SONDA con la ruta del registro del script que consulta la web.")
    for programa in ("xterm", "import"):
        if not shutil.which(programa):
            sys.exit(f"Falta {programa}. Instalar xterm e imagemagick.")

    salida = Path(args.salida).resolve()
    salida.mkdir(parents=True, exist_ok=True)
    xvfb = None
    if not os.environ.get("DISPLAY"):
        os.environ["DISPLAY"] = ":98"
        xvfb = subprocess.Popen(["Xvfb", ":98", "-screen", "0", "1400x1050x24", "-nolisten", "tcp"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        time.sleep(2)
    manifiesto = salida / "manifiesto.json"
    registros = json.loads(manifiesto.read_text()) if manifiesto.exists() else {}
    fallos = 0
    try:
        for e in elegidas:
            registro = capturar(e, args, salida)
            if registro["resultado"] != "DESCARTADA":
                registros[e["id"]] = registro
                manifiesto.write_text(json.dumps(registros, indent=1, ensure_ascii=False) + "\n")
            print(f"{e['id']:<20} {registro['resultado']}: {registro['detalle']}")
            if registro["resultado"] != "CORRECTO":
                fallos += 1
                if not args.continuar:
                    print("Detenido: revisar la captura antes de seguir.")
                    break
    finally:
        escribir_indice(salida)
        if xvfb:
            xvfb.terminate()
    return 1 if fallos else 0


if __name__ == "__main__":
    sys.exit(main())
