resource "aws_db_instance" "phone" {
  db_name                     = "phonebook"
  engine                      = "mysql"
  engine_version              = "8.0.28"
  username                    = "admin"
  password                    = "awsdevops13"
  instance_class              = "db.t3.micro"
  allocated_storage           = 20 #minimum value is 20 to enable autoscaling mention "max_allocated_storage"
  identifier                  = "phonebook-db"
  skip_final_snapshot         = true
  port                        = 3306
  vpc_security_group_ids      = [aws_security_group.rds-sec-gr.id]
  publicly_accessible         = false
  allow_major_version_upgrade = false
  auto_minor_version_upgrade  = true
  backup_retention_period     = 0
  multi_az                    = false
}

resource "aws_instance" "tf-ec2" {
  ami             = data.aws_ami.tf_ami.id
  instance_type   = var.ec2_type
  key_name        = "nvirginia"
  security_groups = [aws_security_group.server-sec-gr.name]
  tags = {
    Name = "phonebook_ami"
  }
  user_data  = base64encode(data.template_file.phonebook.rendered)
  depends_on = [aws_db_instance.phone]
  associate_public_ip_address = true
}

resource "github_repository_file" "foo" {
  repository          = "phonebook"
  branch              = "main"
  file                = "dbserver_endpoint"
  content             = aws_db_instance.phone.address
  overwrite_on_create = true
}

resource "aws_security_group" "rds-sec-gr" {
  name        = "dbsec"
  description = "Allow TLS inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "db_inbound_from_instance"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    #cidr_blocks      = [data.aws_vpc.default.id]
    security_groups = [aws_security_group.server-sec-gr.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "formysql"
  }
}

resource "aws_security_group" "server-sec-gr" {
  name        = "serversec"
  description = "Allow TLS inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "instance_inbound_from_internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    #security_groups = [aws_security_group.server-sec-gr.id]
  }
  ingress {
    description = "for ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    #security_groups = [aws_security_group.server-sec-gr.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "80-22"
  }
}
