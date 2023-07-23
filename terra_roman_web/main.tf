#it might return failure due to non-existance fo the ami in the myami

provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.58.0"
    }
  }
}

locals {
  mytag = "clarusway-local-name"
}

data "aws_ami" "tf_ami" {
  most_recent = true
  owners      = ["amazon"]


  /* filter {
    name   = "virtualization-type"
    values = ["hvm"]
  } */

  /*  filter {
    name   = "platform"
    values = ["Linux/UNIX"]
  } */
   filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm*"]
  }
}

resource "aws_security_group" "roman" {
  name        = "allow_http"
  description = "Allow TLS inbound traffic"
  #vpc_id      = aws_vpc.main.id

  ingress {
    description = "Http from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    #cidr_blocks      = [aws_vpc.main.cidr_block]
    #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }
  ingress {
    description = "ssh from vpc"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    #cidr_blocks      = [aws_vpc.main.cidr_block]
    #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_http"
  }
}

locals {
  keyname = "nvirginia"
}

resource "aws_instance" "tf-ec2" {
  ami             = data.aws_ami.tf_ami.id
  instance_type   = var.ec2_type
  key_name        = local.keyname
  security_groups = ["${aws_security_group.roman.name}"]
  tags = {
    Name = "${local.mytag}-this is from my-ami"
  }
  user_data = file("user.sh")
}

output "public_ip" {
  value = aws_instance.tf-ec2.public_ip
}