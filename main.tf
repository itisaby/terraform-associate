terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.27.0"
    }
  }
}

locals {
  service_name = "EC2-instanceaby"
}

