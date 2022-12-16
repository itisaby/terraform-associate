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

resource "aws_instance" "our_server" {

  
  ami           = "ami-090fa75af13c156b4"
  instance_type = "t2.micro"
  tags = {
    Name = "arnab-${local.service_name}"
  }

}

output "public_ip" {
  value = aws_instance.our_server.public_ip
  # sensitive = true
}

