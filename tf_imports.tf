resource "aws_instance" "imported_ec2_1" {
    ami = "ami-0230bd60aa48260c6"
    instance_type = "t2.micro"
    key_name = "test-app"
    tags = {
        Name = "terraform_import"
    }
}


