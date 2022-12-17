provider "aws" {
  profile = "default"
  region  = "us-east-1"
}


data "terraform_remote_state" "vpc" {
  backend = "local"
  config = {
    path = "../Project-1/terraform.tfstate"
  }
}

module "apache" {
  source        = "../../../Terraform-Module/terraform-aws-apache-example"
  vpc_id        = data.terraform_remote_state.vpc.outputs.name
  instance_type = var.instance_type
  public_key    = var.public_key
  server_name   = var.server_name

}

output "name" {
  value = module.apache.public_ip
}

