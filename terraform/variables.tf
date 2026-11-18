
variable "aws_region" {
  description = "Region de AWS"
  type        = string
  default     = "us-east-1"
}

variable "grupo" {
  description = "Identificador del grupo"
  type        = string
  default     = "g5"
}

variable "manager_type" {
  description = "Tipo de instancia del manager"
  type        = string
  default     = "t3.medium"
}

variable "worker_type" {
  description = "Tipo de instancia de los workers"
  type        = string
  default     = "t3.small"
}

variable "manager_disk_size" {
  description = "Tamaño en GB del disco del manager"
  type        = number
  default     = 20
}

variable "worker_disk_size" {
  description = "Tamaño en GB del disco de cada worker"
  type        = number
  default     = 10
}

variable "disk_type" {
  description = "Tipo de los discos"
  type        = string
  default     = "gp3"
}

variable "worker_count" {
  description = "Numero de workers"
  type        = number
  default     = 3
}

variable "ssh_cidr" {
  description = "IP publica autorizada para SSH"
  type        = string

}

variable "key_name" {
  description = "Nombre del par de claves SSH"
  type        = string
  default     = "vockey"
}




variable "ubuntu_ami_name" {
  description = "Patrón de AMI oficial Ubuntu 22.04"
  type        = string
  default     = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
}

variable "ssh_public_keys" {
  description = "Claves públicas SSH de los miembros del grupo"
  type        = set(string)

  validation {
    condition = length(var.ssh_public_keys) > 0 && alltrue([
      for key in var.ssh_public_keys :
      can(regex("^(ssh-ed25519|ssh-rsa|ecdsa-sha2-nistp(256|384|521)) [A-Za-z0-9+/=]+( [^\\r\\n]*)?$", key))
    ])
    error_message = "Indica al menos una clave pública OpenSSH válida en una sola línea."
  }
}
