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

variable "instance_type" {
  type = string
  description = "value of instance type"
#   sensitive = true
  validation {
    condition = can(regex("t2.micro", var.instance_type))
    error_message = "The instance type must be t2.micro"
  }
  #   value = "t2.micro"
}
locals {
  service_name = "EC2-instanceaby"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "app_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  tags = {
    Name = "arnab-${local.service_name}"
  }
}
output "public_ip" {
  value = aws_instance.app_server.public_ip
  # sensitive = true
}

