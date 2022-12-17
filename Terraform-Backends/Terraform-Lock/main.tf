terraform {
  cloud {
    organization = "terraform-basics"

    workspaces {
      name = "Locking"
    }
  }
}

provider "aws" {
#   profile = "default"
  region  = "us-east-1"
}

module "apache" {
  source        = "itisaby/apache/aws"
  version       = "1.1.0"
  vpc_id        = var.vpc_id
  instance_type = var.instance_type
  public_key    = var.public_key
  server_name   = var.server_name

}

output "name" {
  value = module.apache.public_ip
}

