variable "tags" {
    type = map
    default = {
        Owner = "Vakhob"
        CreatedBy = "Vakhob"
        Project = "deployment"
        Purpose = "development"
    }
}

variable "instance_type" {
    type = map
    default = {
        "prod" = "t2.large"
        "staging" = "t2.medium"
        "qa" = "t2.small"
        "dev" = "t2.micro"
    }
}

variable "instance_name" {
    type = list
    default = ["first_instance", "second_instance", "third_instance"]
}

resource "aws_key_pair" "my_key" {
    key_name = "ec2_key"
    public_key = file("/home/ec2-user/.ssh/id_rsa.pub")
}

resource "aws_instance" "my_ec2" {
    ami = "ami-05a5f6298acdb05b6"    
    instance_type = lookup(var.instance_type, "production", "t2.micro")

    tags = merge (
        {
            Name = element(var.instance_name, 0)
            Team = "DevOps"
            Env = "dev"
            CreatedTime = "11.21.2023"
    },
    var.tags
    )
}

resource "aws_instance" "my_ec2_2" {
    ami = "ami-05a5f6298acdb05b6"
    instance_type = "t2.micro"

    tags = {
        Name = join("-", ["my", "ec2", "instance"])
        Team = "QA"
        Env = "staging"
        CreatedTime = "11.22.2023"
    }
}
 
variable "vpc_cidr" {
    default = "10.0.0.0/16"
}

resource "aws_vpc" "my_vpc" {
    cidr_block = var.vpc_cidr
}

resource "aws_subnet" "subnet_1" {
    vpc_id = aws_vpc.my_vpc.id_rsa
    #cidrsubnet(prefix, newbits, netnum)
    #         "10.0.0.0/16", 8, 1
    #cidr_block = 10.0.1.0/24
    cidr_block = cidrsubnet(var.vpc_cidr, 8, 1)
}

resource "aws_subnet" "subnet_2" {
    vpc_id = aws_vpc.my_vpc.id_rsa
    #cidrsubnet(prefix, newbits, netnum)
    #         "10.0.0.0/16", 8, 1
    #cidr_block = 10.0.1.0/24
    cidr_block = cidrsubnet(var.vpc_cidr, 8, 2)
}
