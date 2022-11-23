terraform {
  cloud {
    organization = "itisaby"

    workspaces {
      name = "Provisioners"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.40.0"
    }
  }
}


provider "aws" {
  # Configuration options
  region = "us-east-1"
}

data "aws_vpc" "main" {
    id = "vpc-0af72937237702351"
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC2poTIY1p5bIACiW08z4+UeimhXz9JbUXQAR3LzsuDGendPvrdeTA8fqC/zKqSZAiCxIoO+hciTQbqpWJqA+dnIzZeB7cvIo8TQ3SAUDaRlQoL9FfnxXIUYcm9euFbX0BT1Yuqh10iPoXHbuAMOjq0qtFX3An0EOuFeW01uZAojwFf4qB0amqne0vmqEP1Qy6eoxGzzslIPCVK/FLRg2kh1kNrsTfkgmMSAk4dbDVp4AwuygKGe8tV0Df9YJz2uisrXkhKq7fJWUcOyZptM6dhAv1jfirTbJtmz1fsjybl5hBvmeqFlODo20b4qjQECQcI2y/l39tSwVN26AWTKV1q0j2BbMuk2qZFOtQp5KII3W9Oc7RQPy2dFgZzHpCN5TxrJyPmmQpCCkJGA/aCq9WlnylLbyQOQ75pTp5wN3L4mBMDciYAGsaGncgplZvWoYyq95j9csDKB9vj8mzz7KsPGbjlDXPhEi8n32rDGbhiTu5UzmxNEQNPPMDTQN1NbQc= arnab@arnab-HP-Pavilion-x360-Convertible-14-dh1xxx"
}
resource "aws_security_group" "sg_server" {
  name        = "allow_tls"
  description = "Security Groups"
  vpc_id      = data.aws_vpc.main.id

  ingress = [{
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  },
  {
    description      = "SSH"
    from_port        = 22
    to_port          = 22     
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }
  ]

  egress = [{
    description      = "All Outbound"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }]

  tags = {
    Name = "allow_tls"
  }
}

data "template_file" "user_data" {
  template = file("./user-data.yml")
}

resource "aws_instance" "app_server" {
  ami           = "ami-090fa75af13c156b4"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sg_server.id]
  #   count         = 2
  user_data = data.template_file.user_data.rendered
  key_name = aws_key_pair.deployer.key_name
  tags = {
    Name = "arnab"
  }
}


output "public_ip" {
  value = aws_instance.app_server.public_ip
}
