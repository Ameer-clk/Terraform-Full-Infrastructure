provider "aws" {
  region = "us-east-1"
  access_key = ""
  secret_key = ""
}

resource "aws_vpc" "example_vpc" {
  cidr_block = "10.1.0.0/16"
  enable_dns_support   = true  # Enable DNS resolution for the VPC
  enable_dns_hostnames = true  # Enable DNS hostnames for the VPC
}

resource "aws_subnet" "example_publicsubnet" {
  vpc_id            = aws_vpc.example_vpc.id
  cidr_block        = "10.1.10.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "example_privatesubnet" {
  vpc_id            = aws_vpc.example_vpc.id
  cidr_block        = "10.1.20.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_route_table" "example_publicroutetable" {
  vpc_id = aws_vpc.example_vpc.id
}

resource "aws_route_table" "example_privateroutetable" {
  vpc_id = aws_vpc.example_vpc.id
}

resource "aws_route" "example_publicroute" {
  route_table_id         = aws_route_table.example_publicroutetable.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.example_igw.id
}

resource "aws_route" "example_privatecroute" {
  route_table_id         = aws_route_table.example_privateroutetable.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.example_igw.id
}

resource "aws_route_table_association" "example_publicassociation" {
  subnet_id        = aws_subnet.example_publicsubnet.id
  route_table_id   = aws_route_table.example_publicroutetable.id
}

resource "aws_route_table_association" "example_privatecassociation" {
  subnet_id        = aws_subnet.example_privatesubnet.id
  route_table_id   = aws_route_table.example_privateroutetable.id
}

resource "aws_internet_gateway" "example_igw" {
  vpc_id = aws_vpc.example_vpc.id
}

resource "aws_security_group" "example_sg" {
  name        = "example-sg"
  description = "SG for the server"
  vpc_id      = aws_vpc.example_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3306 
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami                         = "ami-053b0d53c279acc90"
  instance_type               = "t2.micro"
  root_block_device {
    encrypted = true
  }
  disable_api_termination     = false
  key_name                    = "minikube"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.example_privatesubnet.id
  availability_zone           = "us-east-1b"
  private_ip                  = "10.1.20.10"  # Replace with your desired private IP address
  vpc_security_group_ids      = [aws_security_group.example_sg.id]
}

resource "aws_db_subnet_group" "mydatabase_subnet_group" {
  name       = "mydatabase-subnet-group"
  subnet_ids = [aws_subnet.example_privatesubnet.id,aws_subnet.example_publicsubnet.id]
}

resource "aws_db_instance" "mydatabase" {
  allocated_storage        = 10
  db_name                  = "mydb"
  engine                   = "mysql"
  engine_version           = "5.7"
  instance_class           = "db.t3.micro"
  username                 = "admin"
  password                 = "ameer12345"
  parameter_group_name     = "default.mysql5.7"
  skip_final_snapshot      = false
  identifier               = "mydb-instance"
  backup_retention_period  = 7
  multi_az                 = false
  storage_type             = "gp2"
  storage_encrypted        = true
  publicly_accessible      = true

 # Associate the RDS instance with the subnet group
  db_subnet_group_name     = aws_db_subnet_group.mydatabase_subnet_group.name

  # Associate the RDS instance with the security group
  vpc_security_group_ids   = [aws_security_group.example_sg.id]
}

