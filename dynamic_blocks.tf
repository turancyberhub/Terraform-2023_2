resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "sg_vpc"
    }
}

variable "ingress_rules" {
    type = list(object({
        description = string
        from_port = number
        to_port = number
        protocol = string
        cidr_blocks = list(string)
    }))

    default = [
        {
            description = "allow ssh from my home internet"
            from_port = 22
            to_port = 22
            protocol = tcp
            cidr_blocks = ["192.168.32.24/30"]
        },
        {
            description = "allow application from load balancer"
            from_port = 80
            to_port = 80
            protocol = tcp
            cidr_blocks = ["0.0.0.0/0"] 
        },
        {
            description = "allow application 443 from load balancer"
            from_port = 443
            to_port = 443
            protocol = tcp
            cidr_blocks = ["0.0.0.0/0"] 
        }
    ]
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
        description = ingress.value
        from_port   = ingress.value
        to_port     = ingress.value
        protocol    = ingress.value
        cidr_blocks = ingress.value
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}
