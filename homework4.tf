/*
  Review Each Resource: Identify opportunities to add conditional logic to each resource. This could include toggling the creation of the resource, setting environment-specific parameters, or conditional tagging.

Implement Conditional Logic: Use Terraform's count parameter, locals, or inline condition ? true_val : false_val syntax to add the identified conditional logic.

Create Variables: Where appropriate, define variables in variables.tf to control the conditional logic. For instance, create a variable to determine whether a resource should be created or not.
*/
  
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "main"
  }
}

variable "subnet_type" {
  type = string
  default = "public"
}

resource "aws_subnet" "example_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_type == "public" ? "10.0.1.0/24" : "10.0.2.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "example_1"
  }
}

resource "aws_subnet" "example_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = false
  tags = {
    Name = "example_2"
  }
}

resource "aws_internet_gateway" "gw" {
  count = var.subnet_type == "public" ? 1 : 0
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main"
  }
}

resource "aws_route_table" "rtb" {
  count = var.subnet_type == "public" ? 1 : 0
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "rtb"
  }
}

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.example_1.id
  tags = {
    Name = "web"
  }
}

resource "aws_iam_role" "example_role" {
  name = "example_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
      },
    ],
  })
}

resource "aws_s3_bucket" "example_bucket" {
  bucket = "my-example-bucket"
  acl    = "private"
}

resource "aws_security_group" "allow_web" {
  name        = "allow_web"
  description = "Allow web inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "rds_env" {
  type = string
  default = "prod"
}

resource "aws_db_instance" "example_db" {
  allocated_storage    = var.rds_env == "prod" ? 50: 20
  storage_type         = var.rds_env == "prod" ? "gp3" : "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "mydb"
  username             = "user"
  password             = "pass"
  parameter_group_name = "default.mysql5.7"
}
