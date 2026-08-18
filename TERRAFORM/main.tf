provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "bucket_name" {
  type    = string
  default = "nitin-devops-super-unique-bucket-99887887"
}

resource "aws_security_group" "web_ssh_sg" {
  name        = "web_ssh_sg"
  description = "Allow SSH and HTTP traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
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
    Name = "DevOps-SG"
  }
}

resource "aws_instance" "os1" {
  ami                    = "ami-0e38835daf6b8a2b9"
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.web_ssh_sg.id]

  tags = {
    Name        = "OS"
    Environment = "Dev"
    Project     = "DevOps-Learning"
  }
}

resource "aws_s3_bucket" "my_cool_bucket" {
  bucket = var.bucket_name
  
  tags = {
    Name        = "My Terraform Bucket"
    Environment = "Dev"
  }
}

output "ec2_public_ip" {
  value = aws_instance.os1.public_ip
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.my_cool_bucket.arn
}