#Option 1

resource "aws_subnet" "my_subnet" {
    vpc_id = "vpc-0ece6f242e22c5d7d"
    cidr_block = "10.0.9.0/24"
}

#Option

data "aws_vpc" "network_team_vpc" {
    id = "vpc-0ece6f242e22c5d7d"
}

output "vpc_cidr_range" {
    value = data.aws_vpc.network_team_vpc.cidr_block
}

data "aws_ami" "amazon-linux-2" {
 most_recent = true


 filter {
   name   = "owner-alias"
   values = ["amazon"]
 }


 filter {
   name   = "name"
   values = ["amzn2-ami-hvm*"]
 }
}

resource "aws_instance" "my_ec2" {
    ami = data.aws_ami.amazon-linux-2.id
    instance_type = "t2.micro"
}

#data source to get latest rhel 9 AMI from aws
data "aws_ami" "rhel_9" {
    most_recent = true

    owners = ["309956199498"]

    filter {
      name   = "name"
      values = ["RHEL-9.0*"]
    }

    filter {
        name   = "architecture"
        values = ["x86_64"]
    }

    filter {
        name   = "root-device-type"
        values = ["ebs"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
}

resource "aws_instance" "my_rhel_ec2" {
    ami = data.aws_ami.rhel_9.id
    instance_type = "t2.micro"
}
