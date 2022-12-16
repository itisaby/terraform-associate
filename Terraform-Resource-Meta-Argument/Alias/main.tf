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
provider "aws" {
  # Configuration options
  profile = "default"
  region  = "us-east-1"
  alias = "east"
}
provider "aws" {
  # Configuration options
  profile = "default"
  region  = "us-west-1"
  alias = "west"
}

locals {
  service_name = "EC2-instanceaby"
}

data "aws_ami" "east-amazon-linux-2" {
 most_recent = true

 provider = aws.east
 filter {
   name   = "owner-alias"
   values = ["amazon"]
 }


 filter {
   name   = "name"
   values = ["amzn2-ami-hvm*"]
 }
 owners = [ "amazon" ]
}
data "aws_ami" "west-amazon-linux-2" {
 most_recent = true

 provider = aws.west
 filter {
   name   = "owner-alias"
   values = ["amazon"]
 }


 filter {
   name   = "name"
   values = ["amzn2-ami-hvm*"]
 }
 owners = [ "amazon" ]
}


resource "aws_instance" "east_app_server" {
  ami           = data.aws_ami.east-amazon-linux-2.id
  instance_type = "t2.micro"
  provider = aws.east
  tags = {
    Name = "arnab-${local.service_name}"
  }
}
resource "aws_instance" "west_app_server" {
  ami           = data.aws_ami.west-amazon-linux-2.id
  instance_type = "t2.micro"
  provider = aws.west
  tags = {
    Name = "arnab-${local.service_name}"
  }
}

output "east_public_ip" {
  value = aws_instance.east_app_server.public_ip
  # sensitive = true
}
output "west_public_ip" {
  value = aws_instance.west_app_server.public_ip
  # sensitive = true
}

