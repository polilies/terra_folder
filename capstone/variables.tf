variable "vpc_cidr_block" {
  default = "90.90.0.0/16"
  description = "this is our vpc cidr block"
}

variable "public_subnet_cidr-1" {
  default = "90.90.10.0/24"
  description = "this is our public subnet cidr block"
}

variable "private_subnet_cidr-1" {
  default = "90.90.11.0/24"
  description = "this is our private subnet cidr block"
}

variable "public_subnet_cidr-2" {
  default = "90.90.20.0/24"
  description = "this is our public subnet cidr block"
}

variable "private_subnet_cidr-2" {
  default = "90.90.21.0/24"
  description = "this is our private subnet cidr block"
}

variable "aws_region" {
  default = "us-east-1"
  description = "for-rt-gateway-s3" 
}