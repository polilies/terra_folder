variable "git-token" {
  type        = string
  description = "git token"
  default     = "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"
}

variable "git-name" {
  type        = string
  description = "git user"
  default     = "polilies"
}

variable "ec2_type" {
  type        = string
  description = "instance type"
  default     = "t2.micro"
}