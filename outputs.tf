output "terraform_instance_public_ip" {
  description = "this is the public ip of my terraform server instance"
  value       = aws_instance.terraform_server.public_ip
  sensitive   = true
}
