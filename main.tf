provider "aws" {
  version = "~> 5.0"
  region  = "us-east-1"
  profile = "test_account"
}

#resource "<resource_type>" "<resource_name>" {}

resource "aws_instance" "terraform_server" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  #key_name     = "terraform-key"
  key_name = aws_key_pair.terraform_server_key.key_name
}

resource "aws_instance" "terraform_server_2" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  key_name = aws_key_pair.terraform_server_key.key_name
}

resource "aws_instance" "terraform_server_3" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  key_name = aws_key_pair.terraform_server_key.key_name
}
#key_name = <resource_type>.<resource_block_name>.<attribute_name>

resource "aws_key_pair" "terraform_server_key" {
  key_name   = "terraform-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCm/D0vFnJ6VTriV/JcyDYTCH98+GBeiH9at1qZp3MfYSMcY+weLk34T/Qmy/4DnBQfU29/CSc72AX7NdnV67UQPzQW9pV3JnMxeD7M62TvrynYjfFMUdpdG3U1tAMHzBspUHf6F7X+XsBu7W7cgGvzutJddKTfq//AaCtaDTkKIpMI25FFVRFfdc18sdQoafFnyIaNdVZAhktiBuNtD/ZvRBWuScM1pjBhxvqj+8RhZHZJXNkQKQk4FkNwDNnQrFyZZhRQ7ijXVz8Bl2gvISklhur/TU8OQI1LS7S2rn6ILdEgfSrdZ3E3SobD61tII20BLi006oWR/3yHaj/dva1UDJN8JtFiLRi92rUu9QKxIrgnUZ9FQBfcuQjnA22/B/Ox9xy0STQC1v4mCBaqwOCdvlfthsp1gHUUzEh1qv/8aWfqpK3egRXj5LYluZO3Qriawdmr8eKXZ71Cf4XDMcZqiTLzIorPyM1C/ocW4xzf8PwcZeA6JbwAE2TNQRK2yA8= ec2-user@ip-172-31-35-212.ec2.internal"
}

output "terraform_instance_public_ip" {
  description = "this is the public ip of my terraform server instance"
  value       = aws_instance.terraform_server.public_ip
  sensitive   = true
}

variable "ami_id" {
  #default = "ami-05a5f6298acdb05b6"
}
