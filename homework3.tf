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



#Solution 1:


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
  ttl     = 300
  records = ["192.0.2.2"]
}

resource "aws_route53_record" "example_records" {
    dynamic "record" {
        for_each = var.dns_records
        content {
            zone_id = aws_route53_zone.example.zone_id
            name = record.value.name
            type = record.value.type
            ttl = record.value.ttl
            records = record.value.records
        }
    }
}

variable "dns_records" {
    type = list(object({
        name = string
        type = string
        ttl  = number
        records = list(sting)
    }))
    default = [
        {
          name = "www.example.com"
          type    = "A"
          ttl     = 300
          records = ["192.0.2.1"]
        },
        {
          name    = "api.example.com"
          type    = "A"
          ttl     = 300
          records = ["192.0.2.2", "192.168.2.3"]
        }
    ]
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
