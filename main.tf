terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Datasource to obtain the latest Ubuntu AMI from AWS

provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Start of AWS Instance block

resource "aws_instance" "web" {
  count = 2
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"

  tags = {
    Name = "Server ${count.index}"
  }
}

# Output blocks: 

output "instance_name" {
  description = "Show the randomly generated name"
  value       = aws_instance.web[*].tags
}