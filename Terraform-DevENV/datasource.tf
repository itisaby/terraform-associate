data "aws_ami" "ec2"{
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]   
    }
}