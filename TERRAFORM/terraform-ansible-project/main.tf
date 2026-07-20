terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


provider "aws" {
  region = "ap-south-1" 
}


resource "aws_instance" "automation_server" {
  ami           = "ami-00adafae70b8029d8" 
  instance_type = "t3.micro"             
  key_name      = "ansible-key"    

  
  
  tags = {
    Name = "DevOps-IaC-Server"
  }
}