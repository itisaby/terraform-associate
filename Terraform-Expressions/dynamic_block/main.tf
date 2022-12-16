terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.37.0"
    }
  }
}

provider "aws" {
  # Configuration options
  profile = "default"
  region  = "us-east-1"
}
locals {
  ingress = [{
    description = "HTTP"
    port        = 80
    protocol    = "tcp"
    },
    {
      description = "HTTPS"
      port        = 443
      protocol    = "tcp"
  }]
}
locals {
  service_name = "EC2-instanceaby"
}

data "aws_vpc" "main" {
  id = "vpc-0af72937237702351"
}

resource "aws_security_group" "sg_server" {
  name        = "allow_tls"
  description = "Security Groups"
  vpc_id      = data.aws_vpc.main.id
  dynamic "ingress" {
    for_each = local.ingress
    content {
      description      = ingress.value.description
      from_port        = ingress.value.port
      to_port          = ingress.value.port
      protocol         = ingress.value.protocol
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  }
  egress = [{
    description      = "All Outbound"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }]

  tags = {
    Name = "allow_tls"
  }
}
resource "aws_instance" "app_server" {
  ami           = "ami-090fa75af13c156b4"
  security_groups = [aws_security_group.sg_server.id]
  instance_type = "t2.micro"
  tags = {
    Name = "arnab"
  }
}

output "public_ip" {
  value = aws_instance.app_server.public_ip
  # sensitive = true
}

