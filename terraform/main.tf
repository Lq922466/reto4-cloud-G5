
# Imagen Ubuntu 22.04 LTS
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
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
  name        = "reto4-cloud-g5"
  description = "Seguridad del cluster Docker Swarm G5"
  vpc_id      = data.aws_vpc.default.id

  # SSH desde Codespaces
  ingress {
    description = "SSH desde Codespaces"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr]
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
    Name = "reto4-cloud-g5"
  }
}

# Instancia Manager
resource "aws_instance" "manager" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.manager_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.cluster.id]

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "manager-${var.grupo}"
  }
}

# Instancias Workers
resource "aws_instance" "workers" {
  count = var.worker_count

  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.worker_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.cluster.id]

  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }

  tags = {
    Name = "worker${count.index + 1}-${var.grupo}"
  }
}
