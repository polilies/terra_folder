terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.59.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  # Configuration options
}


resource "aws_vpc_endpoint" "ec2" {
  vpc_id            = aws_vpc.aws_capstone-VPC.id
  service_name      = "com.amazonaws.us-east-1.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids = [aws_route_table.aws_capstone-private-RT.id]
}

resource "aws_route_table" "aws_capstone-public-RT" {
  vpc_id = aws_vpc.aws_capstone-VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aws_capstone-IGW.id
  }

  tags = {
    Name = "aws_capstone-public-RT"
  }
}

resource "aws_route_table" "aws_capstone-private-RT" {
  vpc_id = aws_vpc.aws_capstone-VPC.id

  tags = {
    Name = "aws_capstone-private-RT"
  }
}

resource "aws_subnet" "aws_capstone-public-subnet-1A" {
  vpc_id     = aws_vpc.aws_capstone-VPC.id
  cidr_block = var.public_subnet_cidr-1
  map_public_ip_on_launch = true

  tags = {
    Name = "aws_capstone-public-subnet-1A"
  }
}

resource "aws_subnet" "aws_capstone-public-subnet-1B" {
  vpc_id     = aws_vpc.aws_capstone-VPC.id
  cidr_block = var.public_subnet_cidr-2
  map_public_ip_on_launch = true

  tags = {
    Name = "aws_capstone-public-subnet-1B"
  }
}

resource "aws_subnet" "aws_capstone-private-subnet-1A" {
  vpc_id     = aws_vpc.aws_capstone-VPC.id
  cidr_block = var.private_subnet_cidr-1

  tags = {
    Name = "aws_capstone-private-subnet-1A"
  }
}

resource "aws_subnet" "aws_capstone-private-subnet-1B" {
  vpc_id     = aws_vpc.aws_capstone-VPC.id
  cidr_block = var.private_subnet_cidr-2

  tags = {
    Name = "aws_capstone-private-subnet-1B"
  }
}

resource "aws_route_table_association" "aws_capstone-public-subnet-1A" {
  subnet_id      = aws_subnet.aws_capstone-public-subnet-1A.id
  route_table_id = aws_route_table.aws_capstone-public-RT.id
  availablity_zone = "us-east-1a"
}

resource "aws_route_table_association" "aws_capstone-public-subnet-1B" {
  subnet_id      = aws_subnet.aws_capstone-public-subnet-1B.id
  route_table_id = aws_route_table.aws_capstone-public-RT.id
  availablity_zone = "us-east-1b"
}

resource "aws_route_table_association" "aws_capstone-private-subnet-1A" {
  subnet_id      = aws_subnet.aws_capstone-private-subnet-1A.id
  route_table_id = aws_route_table.aws_capstone-private-RT.id
  availablity_zone = "us-east-1a"
}

resource "aws_route_table_association" "aws_capstone-private-subnet-1B" {
  subnet_id      = aws_subnet.aws_capstone-private-subnet-1B.id
  route_table_id = aws_route_table.aws_capstone-private-RT.id
  availablity_zone = "us-east-1b"
}

resource "aws_db_subnet_group" "aws_capstone_RDS_Subnet_Group-1A" {
  name       = "main"
  subnet_ids = [aws_subnet.aws_capstone-private-subnet-1A.id]

  tags = {
    Name = "My DB Private subnet group 1A"
  }
}

resource "aws_db_subnet_group" "aws_capstone_RDS_Subnet_Group-1B" {
  name       = "main"
  subnet_ids = [aws_subnet.aws_capstone-private-subnet-1B.id]

  tags = {
    Name = "My DB Private subnet group 1B"
  }
}


resource "aws_vpc" "aws_capstone-VPC" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "aws_capstone-VPC"
  }
}

resource "aws_internet_gateway" "aws_capstone-IGW" {
  vpc_id = aws_vpc.aws_capstone-VPC.id

  tags = {
    Name = "aws_capstone-IGW"
  }
}

resource "aws_db_subnet_group" "aws_capstone_RDS_Subnet_Group" {
  name       = "aws_capstone_rds_subnet_group"
  subnet_ids = [aws_subnet.aws_capstone-private-subnet-1A.id, aws_subnet.aws_capstone-private-subnet-1B.id]
}

resource "aws_db_instance" "db-server" {
  instance_class = "db.t2.micro"
  allocated_storage = 20
  vpc_security_group_ids = [aws_security_group.aws_capstone_RDS_Sec_Group.id]
  allow_major_version_upgrade = false
  auto_minor_version_upgrade = true
  backup_retention_period = 7
  identifier = "aws-capstone-rds"
  db_name = "database1"
  engine = "mysql"
  engine_version = "8.0.28"
  username = "admin"
  password = "Clarusway1234"
  monitoring_interval = 0
  multi_az = false
  port = 3306
  publicly_accessible = false
  skip_final_snapshot = true
  db_subnet_group_name = aws_db_subnet_group.aws_capstone_RDS_Subnet_Group.name
  backup_window = "04:00-05:00"
  maintenance_window = "Mon:00:00-Mon:03:00"

}

resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "ec2-role"
  }
}

resource "aws_iam_role_policy" "s3fullaccess" {
  name = "s3fullaccess"
  role = aws_iam_role.ec2_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}