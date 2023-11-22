# Define variables
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_blocks" {
  description = "List of CIDR blocks for subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
}

variable "aws_ami" {
  description = "AMI ID for EC2 instances"
  type        = string
  default     = "ami-0123456789abcdef0"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "subnet_availability_zone" {
  description = "Availability Zone for subnets"
  type        = string
  default     = "us-east-1a"
}

variable "key_pair_name" {
  description = "Name of the key pair for EC2 instances"
  type        = string
  default     = "my-key-pair"
}

# AWS provider configuration (replace with your own provider configuration)
provider "aws" {
  region = "us-east-1"
}

# Create a VPC with hardcoded values
resource "aws_vpc" "example_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "my-vpc"
  }
}

# Create multiple subnets with CIDR blocks using lookup and slice functions
resource "aws_subnet" "example_subnet" {
  count = length(var.subnet_cidr_blocks)

  vpc_id                  = aws_vpc.example_vpc.id
  cidr_block              = element(var.subnet_cidr_blocks, count.index)
  availability_zone       = var.subnet_availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = join("-", ["my-subnet", count.index])
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "example_igw" {
  vpc_id = aws_vpc.example_vpc.id
  tags = {
    Name = "my-igw"
  }
}

# Create a Route Table
resource "aws_route_table" "example_route_table" {
  vpc_id = aws_vpc.example_vpc.id
  tags = {
    Name = "my-route-table"
  }
}

# Create a NAT Gateway with hardcoded values
resource "aws_nat_gateway" "example_nat_gateway" {
  allocation_id = "eip-0123456789abcdef0"  # Replace with your EIP allocation ID
  subnet_id     = aws_subnet.example_subnet[0].id  # Replace with the appropriate subnet
  tags = {
    Name = "my-nat-gateway"
  }
}

# Create an IAM User with a hardcoded name
resource "aws_iam_user" "example_iam_user" {
  name = "my-iam-user"
}

# Create an EC2 instance with concatenated tags
resource "aws_instance" "example_instance" {
  ami           = var.aws_ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.example_subnet[0].id  # Replace with the appropriate subnet
  key_name      = var.key_pair_name
  tags = concat(
    map("Name", "my-instance"),
    zipmap(
      ["Environment", "Owner"],
      ["Development", "JohnDoe"]
    )
  )
}
