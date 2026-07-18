provider "aws" {
  region = "us-east-1" 
}


resource "aws_instance" "my_web_server" {
  ami           = "ami-0c7217cdde317cfec" 
  instance_type = "t3.micro"

  tags = {
    Name = "Terraform-EC2-Project"
  }
}


resource "aws_s3_bucket" "my_website_bucket" {
 
  bucket = "my-devops-bucket-1872026" 
}


resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.my_website_bucket.id

  index_document {
    suffix = "index.html"
  }
}


resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.my_website_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


resource "aws_s3_bucket_policy" "allow_public_read" {
  bucket = aws_s3_bucket.my_website_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.my_website_bucket.arn}/*"
      },
    ]
  })
  depends_on = [aws_s3_bucket_public_access_block.public_access]
}


resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.my_website_bucket.id
  key          = "index.html"
  source       = "index.html"    #
  content_type = "text/html"
}
