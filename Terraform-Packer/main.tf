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

data "aws_ami" "packer_image" {
  /* name_regex = "my-server-httpd" */
  filter {
    name   = "name"
    values = ["my-server-apache"]
  }
  owners = ["self"]
}
locals {
  service_name = "EC2-instanceaby"
}

resource "aws_instance" "app_server" {

  count         = 2 #Resorce Meta-Argument
  ami           = data.aws_ami.packer_image.id
  instance_type = "t2.micro"
  tags = {
    Name = "arnab-${local.service_name}"
  }

}

output "public_ip" {
  value = aws_instance.app_server[*].public_ip
  # sensitive = true
}

