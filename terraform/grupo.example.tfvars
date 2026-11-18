# Copiar a terraform.tfvars y rellenar con valores del grupo.
ssh_cidr        = "192.0.2.10/32"
ssh_public_keys = []
# Accesos adicionales autorizados, si existen. Mantener sus CIDR y descripciones
# al comparar con AWS; las variables reales no se versionan.
ssh_additional_cidrs = {}
