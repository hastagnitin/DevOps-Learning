provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "os1" {
  ami           = "ami-0e38835daf6b8a2b9"
  instance_type = "t3.micro"

  tags = {
    Name = "OS"
  }
}


resource "aws_s3_bucket" "my_cool_bucket" {
  bucket = "nitin-devops-super-unique-bucket-99887887" 
  tags = {
    Name        = "My Terraform Bucket"
    Environment = "Dev"
  }
}
