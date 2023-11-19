#condition ? true : false

variable "color" {
    type = string
    default = "black"
}

#var.color == green ? true : false
# green   == green ? true : false = true
# black   == green ? false

variable "create_ec2" {
    type = bool
    default = false
}

variable "env" {
    type = string
    default = "prod" #env = prod, dev, test, pre-prod, qa .......
}

variable "for_release" {
    type = bool
    default = true
}

resource "aws_instance" "my_ec2" {
    count = !var.create_ec2 ? 4 : 2
    #         false         == true ? 2

    ami = var.env == "prod" || var.env = "pre-prod" ? "ami-05a5f6298acdb05b6" : "ami-05c13eab67c5d8861"
    #                true   ||  false = true
    #                false  ||  true  = true
    #                true   ||  true  = true
    #                false  ||  false = false
    #python                 or
    instance_type = var.env == "prod" && var.for_release == true ? "t2.small" : "t2.micro"
    #                            true && false = false
    #                            false&& true  = false
    #                            false && false= false
    #                            true  && true = true
    key_name = var.env == "prod" ? "prod_key" : "non_prod_key"
}

