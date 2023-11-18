# Convert below code to dynamic blocks:
resource "aws_route53_zone" "example" {
  name = "example.com"
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.example.zone_id
  name    = "www.example.com"
  type    = "A"
  ttl     = "300"
  records = ["192.0.2.1"]
}

resource "aws_route53_record" "api" {
  zone_id = aws_route53_zone.example.zone_id
  name    = "api.example.com"
  type    = "A"
  ttl     = "300"
  records = ["192.0.2.2"]
}


##############################################################################
# Convert below code to dynamic block, instead of creating 4 resource blocks for subnets, create one dynamic block to create all subnets
  
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.example.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_subnet" "subnet2" {
  vpc_id     = aws_vpc.example.id
  cidr_block = "10.0.2.0/24"
}

resource "aws_subnet" "subnet3" {
  vpc_id     = aws_vpc.example.id
  cidr_block = "10.0.3.0/24"
}

resource "aws_subnet" "subnet4" {
  vpc_id     = aws_vpc.example.id
  cidr_block = "10.0.4.0/24"
}
