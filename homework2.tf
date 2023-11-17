/*
Instructions for Students
Replace Static Values with Variables: Identify all the hardcoded values and replace them with Terraform variables. This includes values like the region, VPC CIDR block, subnet CIDR blocks, ALB name, instance types, and AMI IDs.

Use count and count.index: Understand how count and count.index are used to create multiple instances and target groups. Try modifying the count number to see how it affects resource creation.

Create List Variables: For values that require multiple inputs (like subnets), use list variables and access them with count.index.

Initialize and Apply Configuration: Run terraform init to initialize the working directory and terraform apply to create the resources.

Observe the Results: Check the AWS Console to see the resources that have been created. Notice how each EC2 instance is attached to a different target group.
*/

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "example" {
  count = 2

  vpc_id     = aws_vpc.main.id
  cidr_block = count.index == 0 ? "10.0.1.0/24" : "10.0.2.0/24"
  availability_zone = count.index == 0 ? "us-west-2a" : "us-west-2b"
}

resource "aws_alb" "example" {
  name               = "example-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = aws_subnet.example[*].id
}

resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "example" {
  count = 3

  name     = "example-tg-${count.index}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_alb.example.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.example[0].arn
  }
}

resource "aws_security_group" "instance_sg" {
  name        = "instance-sg"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "example" {
  count = 3

  ami           = "ami-0c55b159cbfafe1f0" # Replace with a valid AMI ID for your region
  instance_type = "t2.micro"
  security_groups = [aws_security_group.instance_sg.name]

  tags = {
    Name = "example-instance-${count.index}"
  }
}

resource "aws_lb_target_group_attachment" "example" {
  count = 3

  target_group_arn = aws_lb_target_group.example[count.index].arn
  target_id        = aws_instance.example[count.index].id
  port             = 80
}

