/* data "template_file" "phone" {
  template = file(user-data.sh)
  vars = {
    git_token = var.git_token
    git_user  = var.git_user
  }
} */
data "aws_vpc" "default" {
  default = true
}

data "template_file" "phonebook" {
  template = file("${path.module}/userdata.sh")
  vars = {
    git-token = var.git-token
    git-name  = var.git-name
    DBURI     = aws_db_instance.phone.address
  }
}

data "aws_ami" "tf_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm*"]
  }
}