provider "aws" {
  access_key = "AKIAQF3UUDVPNNOWGTCN"
  secret_key = "ig0aRibB/Zbkqe5Q+NBo6xGh4xr08tKpPl/mltuo"
  profile    = "default"
  region     = var.region
}

resource "aws_instance" "example" {
  ami           = "ami-006dcf34c09e50022"
  instance_type = "t2.micro"
  key_name      = "nvirginia"

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("C:/Users/USER/.ssh/nvirginia.pem")
    host        = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras enable nginx1.12",
      "sudo yum -y install nginx",
      "sudo systemctl start nginx"
    ]
  }
}

