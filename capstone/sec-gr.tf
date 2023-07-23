resource "aws_security_group" "aws_capstone_ALB_Sec_Group" {
  name        = "aws_capstone_ALB_Sec_Group"
  description = "ALB Security Group allows traffic HTTP and HTTPS ports from anywhere"
  vpc_id      = aws_vpc.aws_capstone-VPC.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    }

ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
}

resource "aws_security_group" "aws_capstone_EC2_Sec_Group" {
  name        = "aws_capstone_EC2_Sec_Group"
  description = "EC2 Security Groups only allows traffic coming from aws_capstone_ALB_Sec_Group Security Groups for HTTP and HTTPS ports. In addition, ssh port is allowed from anywhere"
  vpc_id      = aws_vpc.aws_capstone-VPC.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    }

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups = [aws_security_group.aws_capstone_ALB_Sec_Group.id]
    }

ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    security_groups  = [aws_security_group.aws_capstone_ALB_Sec_Group.id]
    
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
  
}

resource "aws_security_group" "aws_capstone_RDS_Sec_Group" {
  name        = "aws_capstone_RDS_Sec_Group"
  description = "RDS Security Groups only allows traffic coming from aws_capstone_EC2_Sec_Group Security Groups for MYSQL/Aurora port."
  vpc_id      = aws_vpc.aws_capstone-VPC.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    security_groups = [aws_security_group.aws_capstone_EC2_Sec_Group.id]
    }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
}

resource "aws_security_group" "aws_capstone_NAT_Sec_Group" {
  name        = "aws_capstone_NAT_Sec_Group"
  description = "NAT instance Security Group allows traffic HTTP and HTTPS and SSH ports from anywhere"
  vpc_id      = aws_vpc.aws_capstone-VPC.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    }

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    }

ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
  
}