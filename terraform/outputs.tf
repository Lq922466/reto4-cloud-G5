output "nodes" {
  description = "IP pública, IP privada e ID EC2 por hostname"
  value = {
    for node in concat([aws_instance.manager], aws_instance.workers) :
    node.tags.Name => {
      public_ip  = node.public_ip
      private_ip = node.private_ip
      id         = node.id
    }
  }
}
