variable "redhat_ami_id" {
  description = "(Optional) AMI to use for the instance. Required unless launch_template is specified and the Launch Template specifes an AMI. If an AMI is specified in the Launch Template, setting ami will override the AMI specified in the Launch Template."
  type        = string
  default     = "ami-05a5f6298acdb05b6" #redhat9
}

variable "amazon_linux_ami_id" {
  description = "(Optional) AMI to use for the instance. Required unless launch_template is specified and the Launch Template specifes an AMI. If an AMI is specified in the Launch Template, setting ami will override the AMI specified in the Launch Template."
  type        = string
  default     = "ami-05c13eab67c5d8861" #amazon linux
}

variable "ubuntu_ami_id" {
  description = "(Optional) AMI to use for the instance. Required unless launch_template is specified and the Launch Template specifes an AMI. If an AMI is specified in the Launch Template, setting ami will override the AMI specified in the Launch Template."
  type        = string
  default     = "ami-0fc5d935ebf8bc3bc" #ubuntu
}

variable "ami_id" {
  type    = list(any)
  default = ["ami-05a5f6298acdb05b6", "ami-05c13eab67c5d8861", "ami-0fc5d935ebf8bc3bc"]
  # indices           [0]                        [1]                            [2]         
}

variable "ec2_type" {
  type = map(any)
  default = {
    #"identifier" = "key" or "value"
    "redhat"       = "t2.small"
    "amazon_linux" = "t2.micro"
    "ubuntu"       = "t2.nano"
  }
}

#############################################################
###################### NETWORK VARIABLES ####################
#############################################################

variable "vpc_cidr" {
  type = string
  default = ""              # "" means empty value
} 

variable "subnet_cidrs" {
  type = map
  default = {
    "public_subnet_1" = "10.0.0.0/24"
    "public_subnet_2" = "10.0.1.0/24"
    "private_subnet_1" = "10.0.2.0/24"
    "private_subnet_2" = "10.0.3.0/24"
  }
}


#############################################################
########################## S3 BUCKET ########################
#############################################################

variable "bucket_name" {
  type = string
  default = ""
}
