# reto4-cloud-G5
RETO 4 - CLOUD - 2 ASIR

## Componentes locales del grupo 5

- `terraform/scripts/bootstrap.sh.tftpl` configura el hostname, la zona horaria,
  las claves públicas, SSH y Docker. Integrarlo con `templatefile` en los
  recursos existentes y pasar `hostname` y `public_keys`.
- `scripts/generar-config-ssh.sh` consume una salida Terraform `nodes` con
  entradas por hostname y campos `public_ip`, `private_ip` e `id`.
  Requiere jq. Genera `config/ssh.local`, excluido de Git.
- `scripts/comprobar-ssh.sh` comprueba en paralelo el acceso por claves a los
  cuatro nodos. Verificar antes las huellas SSH de los servidores.
- `scripts/configurar-red-swarm.sh` configura las redes en el manager antes
  de publicar servicios. Primero formar Swarm por las IP privadas.
- `app/construir.sh DIRECTORIO_WEB IMAGEN VERSION` construye cada imagen a
  partir de la versión estática real de la web F1. Publicar las etiquetas 1.0
  y 2.0 en Docker Hub. `app/desplegar.sh IMAGEN:1.0` instala la pila.
- `scripts/sondear-web.sh http://IP_PUBLICA/identidad.txt` registra una
  petición por segundo con la versión y el contenedor que responde.

- `scripts/comprobar-web.py DIRECTORIO` valida referencias y anclas del sitio.
  `scripts/probar-navegador.py URL VERSION` lo recorre en Chromium y requiere
  playwright.
- `scripts/preparar-imagenes.sh` construye y prueba las imágenes 1.0 y 2.0 en un
  nodo. `scripts/comprobar-descarga.sh` las descarga en los workers y las compara.
- `scripts/publicar-imagenes.sh`, `scripts/desplegar-f1.sh`,
  `scripts/probar-actualizacion.sh` y `scripts/probar-orquestacion.sh` publican,
  despliegan y repiten las pruebas. Estos cuatro requieren autorización.
- `scripts/verificar-despliegue.sh` comprueba réplicas y HTTP, sin hacer cambios.
- `scripts/capturar-pantalla.sh` captura un navegador o un terminal gráficos reales.
  `scripts/capturas-terminal.sh` genera las capturas de terminal del informe, solo con
  comandos de lectura.

## Despliegue de la web definitiva

Imágenes publicadas: [`innnx/reto4-f1:1.0` y `innnx/reto4-f1:2.0`](https://hub.docker.com/r/innnx/reto4-f1/tags).
El servicio `reto4_web` usa la red `red-app-g5`, cuatro réplicas y actualización y
rollback progresivos.

```bash
# Despliega 1.0 con sondas y comprueba 4/4 y HTTP en las cuatro IP.
bash scripts/desplegar-f1.sh config/ssh.local innnx/reto4-f1 DIRECTORIO_REGISTROS
# Actualiza a 2.0 y vuelve a 1.0.
bash scripts/probar-actualizacion.sh config/ssh.local innnx/reto4-f1 DIRECTORIO_REGISTROS
# Comprueba el estado sin hacer cambios.
bash scripts/verificar-despliegue.sh config/ssh.local innnx/reto4-f1 1.0
```

`config/ssh.local` se genera con `scripts/generar-config-ssh.sh` y no se versiona. Para
incluir la prueba en Chromium, definir `PYTHON_NAVEGADOR` con un intérprete que tenga
playwright.


En Terraform, copia grupo.example.tfvars a terraform.tfvars y configura el CIDR real y las claves públicas. Valida y revisa el plan en el Learner Lab antes de solicitar autorización para desplegar. El tratamiento de vockey queda pendiente de confirmación docente por la diferencia entre la guía y B1 de la rúbrica.
