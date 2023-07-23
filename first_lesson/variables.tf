variable "region" {
  default = "us-east-1"
}

output "ip" {
  value = aws_instance.example.public_ip
}