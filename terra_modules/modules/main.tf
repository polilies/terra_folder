#main.tf

provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "my-new-user" {
  name = "oliver-terraform-${var.environment}"
}