terraform {
  cloud {
    organization = "itisaby"

    workspaces {
      name = "terraform-cloud"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.37.0"
    }
  }
}

locals {
  service_name = "EC2-instanceaby"
}

variable "instance_type" {
  type = string
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "app_server" {
  ami           = "ami-090fa75af13c156b4"
  instance_type = var.instance_type
  count         = 2
  tags = {
    Name = "arnab-${local.service_name}"
  }
}
