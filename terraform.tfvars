redhat_ami_id       = "ami-05a5f6298acdb05b6"
amazon_linux_ami_id = "ami-05c13eab67c5d8861"
ubuntu_ami_id       = "ami-0fc5d935ebf8bc3bc"
ami_id              = ["ami-05a5f6298acdb05b6", "ami-05c13eab67c5d8861", "ami-0fc5d935ebf8bc3bc"]
vpc_cidr            = "10.0.0.0/16"
subnet_cidrs        = {
    "public_subnet_1" = "10.0.0.0/24"
    "public_subnet_2" = "10.0.1.0/24"
    "private_subnet_1" = "10.0.2.0/24"
    "private_subnet_2" = "10.0.3.0/24"
  }
bucket_name         = "devops-bucket-12345-98765"
