#This file will consist of AWS networking resources like aws vpc, subnet, ig and rt

resource "aws_vpc" "devops_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name  = "devops_vpc"
    Owner = "Vakhob"
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id     = aws_vpc.devops_vpc.id
  cidr_block = var.subnet_cidrs["public_subnet_1"]
  tags = {
    Name  = "devops_public_1"
    Owner = "Vakhob"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id     = aws_vpc.devops_vpc.id
  cidr_block = var.subnet_cidrs["public_subnet_2"]
  tags = {
    Name  = "devops_public_2"
    Owner = "Vakhob"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id     = aws_vpc.devops_vpc.id
  cidr_block = var.subnet_cidrs["private_subnet_1"]
  tags = {
    Name  = "devops_private_1"
    Owner = "Vakhob"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id     = aws_vpc.devops_vpc.id
  cidr_block = var.subnet_cidrs["private_subnet_2"]
  tags = {
    Name  = "devops_private_2"
    Owner = "Vakhob"
  }
}

resource "aws_internet_gateway" "devops_ig" {
  vpc_id = aws_vpc.devops_vpc.id
  tags = {
    Name  = "devops_internet_gateway"
    Owner = "Vakhob"
  }
}

# resource "aws_internet_gateway_attachment" "devops_ig_attachment" {
#   internet_gateway_id = aws_internet_gateway.devops_ig.id
#   vpc_id              = aws_vpc.devops_vpc.id
# }

resource "aws_route_table" "devops_public_rt" {
  vpc_id = aws_vpc.devops_vpc.id
  route {
    cidr_block = var.vpc_cidr #vpc cidr range
    gateway_id = "local"
  }

  route {
    cidr_block = "0.0.0.0/0"  #internet
    gateway_id = aws_internet_gateway.devops_ig.id
  }

  tags = {
    Name  = "devops_route_table"
    Owner = "Vakhob"
  }
}

resource "aws_route_table_association" "devops_public_rt_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.devops_public_rt.id
}

resource "aws_route_table_association" "devops_public_rt_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.devops_public_rt.id
}
