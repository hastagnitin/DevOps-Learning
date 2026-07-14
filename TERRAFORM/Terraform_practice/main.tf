terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"

}

resource "aws_instance" "HCL-WEB" {
  ami           = "ami-0098dcd2a2aca5b90"
  instance_type = "t3.micro"

  tags = {
    Name = "Terraform-EC2"
    ENV  = "DEV"
  }

}