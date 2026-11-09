
# Imagen Ubuntu 22.04 LTS
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = [var.ubuntu_ami_name]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

# VPC por defecto
data "aws_vpc" "default" {
  default = true
}

# Security Group del cluster G5
resource "aws_security_group" "cluster" {
  name        = "reto4-cloud-${var.grupo}"
  description = "Seguridad del cluster Docker Swarm G5"
  vpc_id      = data.aws_vpc.default.id

  # SSH desde Codespaces. La regla activa en AWS no tiene descripción.
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr]
  }

  # Mantener también los accesos autorizados del aula o integrantes, sin que un
  # plan sustituya sus reglas por la única dirección del Codespace.
  dynamic "ingress" {
    for_each = var.ssh_additional_cidrs
    content {
      description = ingress.value
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [ingress.key]
    }
  }

  # El salto SSH usa la IP privada del manager dentro del mismo grupo.
  ingress {
    description = "SSH entre nodos para ProxyJump"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    self        = true
  }

  # HTTP
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Web puerto 8080
  ingress {
    description = "Web 8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Docker Swarm: gestion del cluster
  ingress {
    description = "Swarm 2377 TCP"
    from_port   = 2377
    to_port     = 2377
    protocol    = "tcp"
    self        = true
  }

  # Docker Swarm: comunicacion TCP
  ingress {
    description = "Swarm 7946 TCP"
    from_port   = 7946
    to_port     = 7946
    protocol    = "tcp"
    self        = true
  }

  # Docker Swarm: comunicacion UDP
  ingress {
    description = "Swarm 7946 UDP"
    from_port   = 7946
    to_port     = 7946
    protocol    = "udp"
    self        = true
  }

  # Docker Swarm: red overlay
  ingress {
    description = "Swarm 4789 UDP"
    from_port   = 4789
    to_port     = 4789
    protocol    = "udp"
    self        = true
  }

  # ICMP entre nodos
  ingress {
    description = "ICMP entre nodos"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    self        = true
  }

  # Salida hacia Internet
  egress {
    description = "Salida general"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "reto4-cloud-${var.grupo}"
  }
}

# Instancia Manager
resource "aws_instance" "manager" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.manager_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.cluster.id]

  associate_public_ip_address = true
  user_data = templatefile("${path.module}/scripts/bootstrap.sh.tftpl", {
    hostname    = "manager-${var.grupo}"
    public_keys = var.ssh_public_keys
  })

  root_block_device {
    volume_size = var.manager_disk_size
    volume_type = var.disk_type
  }

  tags = {
    Name     = "manager-${var.grupo}"
    PruebaA6 = "reto4-${var.grupo}"
  }
}

# Instancias Workers
resource "aws_instance" "workers" {
  count = var.worker_count

  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.worker_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.cluster.id]

  associate_public_ip_address = true
  user_data = templatefile("${path.module}/scripts/bootstrap.sh.tftpl", {
    hostname    = "worker${count.index + 1}-${var.grupo}"
    public_keys = var.ssh_public_keys
  })

  root_block_device {
    volume_size = var.worker_disk_size
    volume_type = var.disk_type
  }

  tags = {
    Name = "worker${count.index + 1}-${var.grupo}"
  }
}
