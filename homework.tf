resource "aws_vpc" "tch_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "tch_vpc"
  }
}

resource "aws_subnet" "tch_subnet" {
  vpc_id     = aws_vpc.tch_vpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "tch_subnet"
  }
}

resource "aws_internet_gateway" "tch_gateway" {
  vpc_id = aws_vpc.tch_vpc.id
  tags = {
    Name = "tch_gateway"
  }
}

resource "aws_route_table" "tch_route_table" {
  vpc_id = aws_vpc.tch_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tch_gateway.id
  }

  tags = {
    Name = "tch_route_table"
  }
}

resource "aws_instance" "tch_instance" {
  ami             = "ami-12345678"  # Replace with a valid AMI ID
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.tch_subnet.id

  tags = {
    Name = "tch_instance"
  }
}

resource "aws_iam_group" "tch_group1" {
  name = "tch_group1"
  path = "/tch/"
}

resource "aws_iam_group" "tch_group2" {
  name = "tch_group2"
  path = "/tch/"
}

resource "aws_iam_user" "tch_user1" {
  name          = "tch_user1"
  path          = "/tch/"
  force_destroy = true
}

resource "aws_iam_user" "tch_user2" {
  name          = "tch_user2"
  path          = "/tch/"
  force_destroy = true
}

resource "aws_iam_user_group_membership" "tch_user1_group_membership" {
  user   = aws_iam_user.tch_user1.name
  groups = [aws_iam_group.tch_group1.name]
}

resource "aws_iam_user_group_membership" "tch_user2_group_membership" {
  user   = aws_iam_user.tch_user2.name
  groups = [aws_iam_group.tch_group2.name]
}

