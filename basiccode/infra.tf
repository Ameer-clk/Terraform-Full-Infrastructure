provider "aws" {
  region     = "us-east-1"
  access_key = ""
  secret_key = ""
}

resource "aws_vpc" "example_vpc" {
  cidr_block = "192.168.0.0/16"
}

resource "aws_subnet" "example_publicsubnet" {
  vpc_id                = aws_vpc.example_vpc.id
  cidr_block            = "192.168.1.0/24"
  availability_zone     = "us-east-1a"
}

resource "aws_subnet" "example_privatesubnet" {
  vpc_id                = aws_vpc.example_vpc.id
  cidr_block            = "192.168.2.0/24"
  availability_zone     = "us-east-1a"
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

resource "aws_cloudwatch_metric_alarm" "myalarm" {
  alarm_name          = "myalarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This metric monitors EC2 CPU utilization"
}

resource "aws_security_group" "example_sg" {
  name        = "example-sg"
  description = "SG for the server"
  vpc_id      = aws_vpc.example_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
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
  key_name                    = "new"
  associate_public_ip_address = false
  subnet_id                   = aws_subnet.example_privatesubnet.id
  private_ip                  = "192.168.2.10"  # Replace with your desired private IP address
  vpc_security_group_ids      = [aws_security_group.example_sg.id]
}





