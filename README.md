# RETO 4 CLOUD · Grupo 5

Web del Gran Premio de Euskadi desplegada en AWS con Terraform y Docker Swarm. Reto de 2º de ASIR.

| Para ver | Documento |
| --- | --- |
| El informe técnico de las Fases 0–5 | [PROYECTO.md](PROYECTO.md) |
| El estado de los 42 criterios | [REVISION.md](REVISION.md) |
| Qué está completado y qué falta | [Checklist final](entrega/CHECKLIST-FINAL.md) |
| El contraste con la Guía y la Rúbrica | [CONTRASTE-GUIA-RUBRICA.md](entrega/CONTRASTE-GUIA-RUBRICA.md) |
| Las evidencias de cada criterio | [Índice de evidencias](evidencias/INDICE.md) |
| La defensa: guion, demostraciones y preguntas | [DEFENSA.md](entrega/DEFENSA.md) y [presentación](entrega/presentacion-cloud-g5.pptx) |
| La organización del grupo | [GESTION.md](GESTION.md) |
| Las tareas pendientes | [PENDIENTES.md](entrega/PENDIENTES.md) |

**Imágenes publicadas:** [`innnx/reto4-f1:1.0` y `innnx/reto4-f1:2.0`](https://hub.docker.com/r/innnx/reto4-f1/tags).

**Estado:** rama `cloud-g5-implementacion`, con la PR #1 en borrador. Último estado técnico comprobado: 5 de noviembre de 2026, 09:56 UTC,
con cuatro nodos Ready/Active, `reto4_web` en 4/4 y HTTP 200 en las cuatro IP. Las IP públicas cambian al reiniciar Learner Lab.

## Arquitectura

![Arquitectura](diagramas/arquitectura.png)

Cuatro instancias EC2 en `us-east-1`, un grupo de seguridad, Docker Swarm por IP privada y dos redes overlay con MTU 1450. Detalle en
[diagramas/arquitectura.md](diagramas/arquitectura.md).

## Estructura

| Carpeta | Contenido |
| --- | --- |
| [`.devcontainer/`](.devcontainer/devcontainer.json) | Codespaces con AWS CLI y Terraform |
| [`terraform/`](terraform/) | Infraestructura: grupo de seguridad, instancias, arranque y salidas |
| [`config/`](config/ssh_config.example) | Plantilla de configuración SSH. `ssh.local` se genera y no se versiona |
| [`scripts/`](scripts/) | SSH, Swarm, publicación, despliegue, pruebas, capturas y revisión de secretos |
| [`app/`](app/) | `f1`: web definitiva. `f1-release`: extra de la 2.0. `sitio`: portal provisional. Dockerfile y pila |
| [`diagramas/`](diagramas/) | Mapa de arquitectura |
| [`evidencias/`](evidencias/INDICE.md) | Registros y capturas reales, por criterio |
| [`entrega/`](entrega/) | Checklist, defensa, estructura del Word y tareas pendientes |
| [`practica-individual/`](practica-individual/README.md) | Instrucciones y plantilla. **Sin contenido todavía** |

## Reproducir el despliegue

Requiere una sesión activa de Learner Lab y las credenciales de AWS en el Codespace. Estos comandos crean o cambian recursos reales.

### 1. Infraestructura

```bash
cp terraform/grupo.example.tfvars terraform/terraform.tfvars   # Indicar la IP propia /32 y las claves públicas.
terraform -chdir=terraform init
terraform -chdir=terraform validate
terraform -chdir=terraform plan -out=reto4.tfplan              # Revisar antes de aplicar.
terraform -chdir=terraform apply reto4.tfplan
```

El estado de Terraform no se versiona. Debe conservarse para poder gestionar y destruir los recursos.

### 2. SSH y Swarm

```bash
bash scripts/generar-config-ssh.sh    # Lee el estado de Terraform y genera config/ssh.local.
bash scripts/comprobar-ssh.sh         # Verificar antes las huellas SSH de los servidores.
bash scripts/formar-swarm.sh          # Forma Swarm por IP privada y crea las redes con MTU 1450.
```

### 3. Imágenes y servicio

Docker no puede ejecutarse en este Codespace, así que las imágenes se construyen en un nodo.

```bash
bash scripts/preparar-imagenes.sh config/ssh.local manager-g5 reto4-g5/f1-definitiva
ssh -t -F config/ssh.local manager-g5 docker login -u CUENTA
bash scripts/publicar-imagenes.sh config/ssh.local CUENTA/REPOSITORIO     # Cierra la sesión al terminar.
bash scripts/comprobar-descarga.sh config/ssh.local CUENTA/REPOSITORIO
bash scripts/desplegar-f1.sh config/ssh.local CUENTA/REPOSITORIO DIRECTORIO_REGISTROS
```

### 4. Comprobaciones

```bash
# Solo lectura: réplicas, imagen y HTTP en las cuatro IP.
bash scripts/verificar-despliegue.sh config/ssh.local CUENTA/REPOSITORIO 1.0

# Modifican el servicio: actualización y rollback; E2, E3 o E6.
bash scripts/probar-actualizacion.sh config/ssh.local CUENTA/REPOSITORIO DIRECTORIO_REGISTROS
bash scripts/probar-orquestacion.sh config/ssh.local CUENTA/REPOSITORIO DIRECTORIO_REGISTROS e2
```

## Seguridad

- No se versionan claves privadas, credenciales, estado ni planes de Terraform: [`.gitignore`](.gitignore).
- Antes de integrar cambios, ejecutar `python3 scripts/revisar-secretos.py COMMIT_BASE HEAD`.
- `python3 scripts/validar-entrega.py` comprueba enlaces, evidencias y estados de los documentos de entrega.
- Las capturas de AWS no deben mostrar el identificador de la cuenta.
