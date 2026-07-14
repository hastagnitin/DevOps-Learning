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

resource "aws_s3_bucket" "HCL-Bucket" {
  bucket = "aws-create-bucket-1996"

  tags = {
    Name = "Terraform-S3"
    ENV  = "DEV"
  }

}