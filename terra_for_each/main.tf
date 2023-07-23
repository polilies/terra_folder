provider "aws" {
  region  = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~>4.0"
    }
  }
}

/* resource "aws_instance" "tf-ec2" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  key_name      = "nvirginia"    # write your pem file without .pem extension>
  tags = {
    "Name" = "tf-ec2"
  }
} */

resource "aws_s3_bucket" "tf-s3" {
  #bucket = "${var.s3_bucket_name}-${count.index}"
  #count = var.num_of_buckets
  for_each = toset(var.users)
  bucket   = "example-tf-s3-bucket-${each.value}"
}

resource "aws_iam_user" "new_users" {
  for_each = toset(var.users)
  name = each.value
}

output "uppercase_users" {
  value = [for user in var.users : upper(user) if length(user) > 6]
}