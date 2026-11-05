#!/usr/bin/env bash
set -euo pipefail
export AWS_PAGER=""
# Capturas reales de terminal para el informe, solo con comandos de lectura.
# Cada captura guarda la imagen y el texto de la salida. Requiere DISPLAY, xterm e ImageMagick.
# Uso: capturas-terminal.sh DIRECTORIO_DE_ESTADO_TERRAFORM DIRECTORIO_DE_SALIDA
if [[ $# != 2 ]]; then
    printf 'Uso: %s DIRECTORIO_DE_ESTADO_TERRAFORM DIRECTORIO_DE_SALIDA\n' "$0" >&2
    exit 2
fi
state_dir=$1
output=$(realpath -m -- "$2")
root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
cd "$root"
mkdir -p "$output"
ip=$(curl -s --max-time 5 https://checkip.amazonaws.com)
ssh_='ssh -F config/ssh.local'
tf_state="-state=$state_dir/terraform.tfstate"
region='--region us-east-1'
filter="--filters 'Name=tag:Name,Values=manager-g5,worker?-g5'"
nodes='manager-g5 worker1-g5 worker2-g5 worker3-g5'

c() {
    local name=$1 rows=$2 command=$3
    # SOLO permite repetir únicamente las capturas cuyo nombre coincida.
    [[ -z "${SOLO:-}" || "$name" =~ $SOLO ]] || return 0
    FILAS=$rows bash scripts/capturar-pantalla.sh terminal "$output/$name.png" "$command"
    local lines
    lines=$(fold -w 150 "$output/$name.txt" | wc -l)
    printf '%s: %s líneas en %s filas%s\n' "$name" "$lines" "$rows" \
        "$( ((lines < rows)) || printf ' AVISO: parte de la salida no cabe')"
}

# Fase 0: entorno y repositorio.
c F5-entorno 16 'hostname; date -Is; aws --version; terraform version; gh --version | head -n 1; ssh -V'
c F4-estructura 52 'hostname; date -Is; git branch --show-current; ls -A; ls terraform terraform/scripts app config .devcontainer'
c F7-scripts 32 'hostname; date -Is; ls -l scripts'
c F2-historial 24 "hostname; date -Is; git log --format='%h %an %ad %s' --date=short -n 12 | cut -c1-140; gh pr list --state all"
c F1-colaboradores 12 "hostname; date -Is; gh api repos/Lq922466/reto4-cloud-G5/collaborators --jq '.[] | [.login, .role_name] | @tsv'; gh repo view Lq922466/reto4-cloud-G5 --json visibility --jq .visibility"
c F12-archivos-sensibles 14 "hostname; date -Is; git ls-files | grep -Ei 'tfstate|tfplan|[.]pem\$|[.]key\$|ssh[.]local|tfvars\$'; git check-ignore terraform/terraform.tfvars config/ssh.local"

# Fase 1: Terraform e instancias.
c A1-modulo-terraform 22 "hostname; date -Is; find terraform -maxdepth 2 -not -path '*/.terraform*' -type f | sort; terraform -chdir=terraform validate -no-color"
c F6-codigo-instancias 54 "hostname; date -Is; sed -n '/Instancia Manager/,\$p' terraform/main.tf"
c A2-instancias 28 "hostname; date -Is; aws ec2 describe-instances $region $filter --query 'Reservations[].Instances[].[Tags[?Key==\`Name\`]|[0].Value,InstanceId,InstanceType,State.Name]' --output table; aws ec2 describe-instance-status $region --include-all-instances --instance-ids \$(aws ec2 describe-instances $region $filter --query 'Reservations[].Instances[].InstanceId' --output text) --query 'InstanceStatuses[].[InstanceId,InstanceState.Name,SystemStatus.Status,InstanceStatus.Status]' --output table"
c A3-grupo-seguridad 24 "hostname; date -Is; aws ec2 describe-security-groups $region --filters Name=group-name,Values=reto4-cloud-g5 --query 'SecurityGroups[].IpPermissions[].{Desde:FromPort,Hasta:ToPort,Protocolo:IpProtocol,CIDR:join(\`,\`,IpRanges[].CidrIp),Grupo:join(\`,\`,UserIdGroupPairs[].GroupId)}' --output table"
c A4-arranque 26 "for h in $nodes; do $ssh_ \$h 'hostname; date -Is; cloud-init status; timedatectl show -p Timezone --value; docker --version'; done"
c A5-salida-nodes 40 "hostname; date -Is; terraform -chdir=terraform output -no-color $tf_state nodes; aws ec2 describe-instances $region $filter --query 'Reservations[].Instances[].[Tags[?Key==\`Name\`]|[0].Value,PrivateIpAddress,PublicIpAddress]' --output table"
c A6-sin-cambios 28 "hostname; date -Is; terraform -chdir=terraform plan -no-color -compact-warnings -input=false $tf_state -var-file=$state_dir/reto4-local.auto.tfvars.json -var ssh_cidr=$ip/32 | grep -vE '^\$|Refreshing|Reading|Read complete'; aws ec2 describe-instances $region --filters Name=tag:PruebaA6,Values=reto4-g5 --query 'Reservations[].Instances[].[Tags[?Key==\`Name\`]|[0].Value,InstanceId]' --output table"

# Fase 2: SSH.
c B1-claves-autorizadas 22 "for h in $nodes; do $ssh_ \$h 'hostname; date -Is; ssh-keygen -lf ~/.ssh/authorized_keys'; done"
c B2-alias 28 "hostname; date -Is; cat config/ssh.local; $ssh_ manager-g5 'hostname; date -Is'"
c B3-simultaneo-sudo 24 "hostname; date -Is; bash scripts/comprobar-ssh.sh; for h in $nodes; do $ssh_ \$h 'printf \"%s sudo: \" \$(hostname); sudo -n true && echo correcto'; done"
c B3-copia-scp 14 "hostname; date -Is; d=\$(mktemp -d); scp -F config/ssh.local worker1-g5:/etc/hostname \"\$d/hostname-worker1\"; sha256sum \"\$d/hostname-worker1\"; $ssh_ worker1-g5 'hostname; sha256sum /etc/hostname'; rm -rf -- \"\$d\""
c B4-endurecimiento 34 "hostname; date -Is; stat -c '%a %n' ~/.ssh ~/.ssh/reto4_g5; for h in $nodes; do $ssh_ \$h 'hostname; sudo sshd -T | grep -E \"^(permitrootlogin|passwordauthentication|pubkeyauthentication) \"; stat -c \"%a %n\" ~/.ssh ~/.ssh/authorized_keys'; done"
c B5-salto 22 "hostname; date -Is; ssh -F config/ssh.local -G worker1-g5 | grep -E '^(hostname|proxyjump|user) '; for h in worker1-g5 worker2-g5 worker3-g5; do $ssh_ \$h 'hostname; hostname -I'; done"

# Fase 3: Docker y Swarm.
c C1-docker-ping 26 "$ssh_ manager-g5 'hostname; date -Is; docker --version; for ip in 172.31.17.168 172.31.29.192 172.31.31.183; do ping -c 2 -W 2 \$ip | tail -n 3; done'"
c C2-red-ingress 14 "$ssh_ manager-g5 'hostname; date -Is; docker info --format \"NodeAddr={{.Swarm.NodeAddr}}\"; docker node inspect --format \"{{.Description.Hostname}} estado={{.Status.Addr}} manager={{if .ManagerStatus}}{{.ManagerStatus.Addr}}{{else}}no{{end}}\" manager-g5 worker1-g5 worker2-g5 worker3-g5; docker network inspect --format \"{{.Name}} driver={{.Driver}} ingress={{.Ingress}} MTU={{index .Options \\\"com.docker.network.driver.mtu\\\"}}\" red-g5'"
c C3-nodos 12 "$ssh_ manager-g5 'hostname; date -Is; docker node ls'"
c C4-red-aplicacion 14 "$ssh_ manager-g5 'hostname; date -Is; docker network ls --filter driver=overlay; docker network inspect --format \"{{.Name}} driver={{.Driver}} ingress={{.Ingress}} MTU={{index .Options \\\"com.docker.network.driver.mtu\\\"}}\" red-app-g5'"

# Fases 4 y 5: imágenes, servicio y web.
c D1-imagenes 20 "$ssh_ manager-g5 'hostname; date -Is; docker image ls --format \"{{.Repository}}:{{.Tag}} {{.ID}}\" | grep -E \"innnx|reto4-g5\" | sort'; curl -s 'https://hub.docker.com/v2/repositories/innnx/reto4-f1/tags/?page_size=10' | jq -r '.results|sort_by(.name)[]|[.name,.digest]|@tsv'"
c D2-pila-servicio 44 "hostname; date -Is; cat app/stack.yml; $ssh_ manager-g5 'hostname; date -Is; docker service ls; docker service ps --filter desired-state=running reto4_web; docker service inspect --format \"Actualización: {{.Spec.UpdateConfig.Order}}, Rollback: {{.Spec.RollbackConfig.Order}}\" reto4_web'"
c E1-reparto-peticiones 26 "hostname; date -Is; for ip in \$(aws ec2 describe-instances $region $filter --query 'Reservations[].Instances[].PublicIpAddress' --output text); do for i in 1 2 3 4; do printf '%s ' \$ip; curl -s --max-time 5 http://\$ip/identidad.txt | tr '\n' ' '; echo; done; done"
c E7-historial-versiones 30 "$ssh_ manager-g5 'hostname; date -Is; docker service ps --format \"{{.Name}} {{.Image}} {{.Node}} {{.DesiredState}} {{.CurrentState}}\" reto4_web'"
c estado-final 26 "hostname; date -Is; $ssh_ manager-g5 'hostname; date -Is; docker node ls; docker service ls; docker service ps --filter desired-state=running reto4_web'; for ip in \$(aws ec2 describe-instances $region $filter --query 'Reservations[].Instances[].PublicIpAddress' --output text); do curl -s -o /dev/null --max-time 5 -w \"\$ip HTTP %{http_code}\n\" http://\$ip/; done"
