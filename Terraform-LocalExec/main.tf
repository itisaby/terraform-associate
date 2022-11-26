terraform {
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
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDQ9W674jBsh2tEI10Xt/7YQAvzWbvACxg2lAi1pQB7qmmTlg3xqbS8eHYXlRWYRocUln/2s4aa/etWFBXDSJgmOt1tJ9UTwNJMxT6IaULE3T1/gnavcV3oQYtBmijbDXdP9/MB84i1nP2g+xQnTc4fpUyzSzVrPEw71M+EWfr6WOrQI8bH8k6wTsTX0WKXP0SAtLXTKvbgW6LNx+SY9j7FJ3qagNAxqb6b0XBe5fityO4e2buGOaft8Rh5yUQAhJbPTN/ha6tNmUfNP1GEFmyAWtmdV5+OZYRdoNP8lBM3t9eD6QJGJRI9JtKcbNHw27ZPunjWsqx05EjmjLixYaeY0TlLMl1PkmrDAI7hndw/d7xxK9MqALUbOBaFH8Cwm3i4wd90Ppy10zLRmbPW65kb4FenCUkAiF8L4HozEslJH0M9abrnmP1FVinGh1+YuvD8g5MWCajKwnIJzG8PcWE1VutGTG1LXohjMclOVJSWCHHIV46q8M8b9q/g+xK6Lws= arnab@arnab-HP-Pavilion-x360-Convertible-14-dh1xxx"
}

data "template_file" "user_data" {
  template = file("./user-data.yml")
}

resource "aws_instance" "app_server" {
  ami                    = "ami-090fa75af13c156b4"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sg_server.id]
  #   count         = 2
  key_name  = aws_key_pair.deployer.key_name
  user_data = data.template_file.user_data.rendered
  provisioner "local-exec" {
    command = "echo ${self.private_ip} >> private_ips.txt"
  }
  tags = {
    Name = "arnab"
  }
}


output "public_ip" {
  value = aws_instance.app_server.public_ip
}
