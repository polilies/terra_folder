resource "aws_s3_bucket" "bucket1" {
  bucket = "awscapastonepoliliesblog"
}

resource "aws_s3_bucket_acl" "acl" {
  bucket = aws_s3_bucket.bucket1.id
  acl = "public-read"
}


resource "aws_s3_bucket" "bucket_failover" {
  bucket = "capstone.kayikco.com"
}

resource "aws_s3_bucket_acl" "acl2" {
  bucket = aws_s3_bucket.bucket_failover.id
  acl = "public-read"
}

resource "aws_s3_bucket_accelerate_configuration" "web" {
    bucket = aws_s3_bucket.bucket_failover.id
    
  
}