
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



