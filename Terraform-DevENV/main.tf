# Resource to create a VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.123.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main"
  }
}
# Resource to create AWS SUBNET
resource "aws_subnet" "sub" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.123.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "dev-public"
  }
}
#Resource to create Internet Gateway 
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "DevPublic IG"
  }
}
# Resource to create Route Table
resource "aws_route_table" "example" {
  vpc_id = aws_vpc.main.id

  route = []

  tags = {
    Name = "DevPublic RT"
  }
}
# Resource to create Route Table
resource "aws_route" "r" {
  route_table_id         = aws_route_table.example.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.sub.id
  route_table_id = aws_route_table.example.id
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "egress"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }
  egress {
    description      = "egress"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }


  tags = {
    Name = "allow_tls"
  }
}

resource "aws_key_pair" "deploy" {
  key_name   = "deployhub"
  public_key = file("/home/arnab/.ssh/devenv.pub")

}

resource "aws_instance" "dev" {
  instance_type          = var.instance_type
  ami                    = data.aws_ami.ec2.id
  key_name               = aws_key_pair.deploy.key_name
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  subnet_id              = aws_subnet.sub.id
  user_data              = file("userdata.tpl")
  # associate_public_ip_address = true
  root_block_device {
    volume_size           = 10
    volume_type           = "gp2"
    delete_on_termination = true
  }
  tags = {
    Name = "dev-node"
  }
  provisioner "local-exec" {
    command = templatefile("${var.host_os}-ssh-config.tpl",
      {
        hostname     = self.public_ip,
        user         = "ubuntu",
        identityfile = "~/.ssh/devenv"

      }
    )
    interpreter = var.host_os == "linux" ? [
      "bash", "-c"
      ] : [
      "powershell", "-Command"
    ]
  }
}
