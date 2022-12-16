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
  service_name = "EC2-instanceaby"
}

resource "aws_instance" "app_server" {

  for_each = {
    nano = "t2.nano",
    micro = "t2.micro",
    small = "t2.small",
    medium = "t2.medium"
  }
  ami           = "ami-090fa75af13c156b4"
  instance_type = each.value
  tags = {
    Name = "arnab-${each.key}"
  }
}

output "public_ip" {
  value = values(aws_instance.app_server)[*].public_ip
  # sensitive = true
}

