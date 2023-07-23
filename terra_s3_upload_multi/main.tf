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

resource "aws_s3_bucket" "kitten" {
  bucket            = "s3-terra-bucket-kitten"
  #aws_s3_bucket_acl = "private"
  tags = {

    Name = "My bucket"

    Environment = "Dev"

  }
}
resource "aws_s3_bucket_acl" "acl" {
    bucket = aws_s3_bucket.kitten.id
    acl = "private"
  
}

resource "aws_s3_bucket_object" "objects" {
  for_each = fileset("C:/Users/USER/Envs/learn-terraform/terra_s3_upload_multi/the_files/", "*")
  bucket   = aws_s3_bucket.kitten.id
  key      = each.value
  source   = "C:/Users/USER/Envs/learn-terraform/terra_s3_upload_multi/the_files/${each.value}"
  etag     = filemd5("C:/Users/USER/Envs/learn-terraform/terra_s3_upload_multi/the_files/${each.value}")

}