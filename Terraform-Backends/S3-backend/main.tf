terraform {
  backend "s3" {
    bucket = "aws-terraformtt"
    key    = "terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "force-unlock-table"
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}
resource "aws_s3_bucket" "name" {
  bucket = "arnab-terraform21323"
}

module "apache" {
  source        = "itisaby/apache/aws"
  vpc_id        = var.vpc_id
  instance_type = var.instance_type
  public_key    = var.public_key
  server_name   = var.server_name

}

output "name" {
  value = module.apache.public_ip
}

