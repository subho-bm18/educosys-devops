provider "aws" {
  region = "us-east-1"
}

module "ec2_instances" {
  source = "../modules/ec2_instances"

  key_name           = var.key_name
  //private_key_path   = var.private_key_path
  instance_type      = var.instance_type
  ami_id             = var.ami_id
  subnet_id          = var.subnet_id // Add this line
  security_group_id  = aws_security_group.allow_ssh.id
}

resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "test-vpc"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.example_vpc.id # Reference the created VPC or an existing VPC ID

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}
