# Configuración del grupo 5

La Guía pide en esta carpeta la plantilla de configuración SSH y las configuraciones aplicadas.

| Archivo | Contenido | Versionado |
| --- | --- | --- |
| [`ssh_config.example`](ssh_config.example) | Plantilla de la configuración SSH, comentada | Sí |
| [`ssh_config.usuario.example`](ssh_config.usuario.example) | Plantilla de `~/.ssh/config`, que permite usar solo el nombre corto | Sí |
| [`ssh_config.aplicado`](ssh_config.aplicado) | Última configuración SSH aplicada, con sus IP | Sí |
| `ssh.local` | Configuración en uso. La genera `scripts/actualizar-ips.sh` | No |
| [`sshd_00-reto4.conf`](sshd_00-reto4.conf) | Configuración de `sshd` aplicada en los nodos: sin root ni contraseña | Sí |

## Uso

```bash
bash scripts/actualizar-ips.sh                # Lee EC2 y genera ssh.local y ssh_config.aplicado.
install -m 600 config/ssh_config.usuario.example ~/.ssh/config
ssh manager-g5                                # Solo con el nombre corto.
ssh worker1-g5                                # Por IP privada, con salto por el manager.
```

Solo contienen IP y nombres, nunca claves privadas. `ssh_config.aplicado` conserva las IP de la última actualización, que cambian al reiniciar el laboratorio.

## Otras configuraciones aplicadas

| Qué | Dónde |
| --- | --- |
| Redes de Swarm: `red-g5` (ingress) y `red-app-g5`, overlay con MTU 1450 | [`scripts/configurar-red-swarm.sh`](../scripts/configurar-red-swarm.sh) |
| Servicio web: cuatro réplicas, red, reinicio y actualización | [`app/stack.yml`](../app/stack.yml) |
| Arranque de cada nodo | [`terraform/scripts/bootstrap.sh.tftpl`](../terraform/scripts/bootstrap.sh.tftpl) |
