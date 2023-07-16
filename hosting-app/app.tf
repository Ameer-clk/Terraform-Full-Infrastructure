provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "myvpc" {
  cidr_block = "192.168.0.0/16"
}

resource "aws_subnet" "publicsubnet" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = "192.168.10.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "privatesubnet" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = "192.168.20.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_route_table" "publicroutetable" {
  vpc_id = aws_vpc.myvpc.id
}

resource "aws_route_table" "privateroutetable" {
  vpc_id = aws_vpc.myvpc.id
}

resource "aws_internet_gateway" "myinternetgateway" {
  vpc_id = aws_vpc.myvpc.id
}

resource "aws_route" "publicroute" {
  route_table_id         = aws_route_table.publicroutetable.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.myinternetgateway.id
}

resource "aws_route" "privateroute" {
  route_table_id         = aws_route_table.privateroutetable.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.myinternetgateway.id
}

resource "aws_route_table_association" "publicsubnetassociation" {
  subnet_id       = aws_subnet.publicsubnet.id
  route_table_id  = aws_route_table.publicroutetable.id
}

resource "aws_route_table_association" "privatesubnetassociation" {
  subnet_id       = aws_subnet.privatesubnet.id
  route_table_id  = aws_route_table.privateroutetable.id
}

resource "aws_security_group" "mysg" {
  name        = "mysg"
  description = "security group for the instance demo"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["192.168.20.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["192.168.20.0/0"]
  }

  ingree {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["192.168.20.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["192.168.20.0/0"]
  }
}

resource "aws_acm_certificate" "cert" {
  domain_name       = "cloudstud.one"
  validation_method = "DNS"
}

resource "aws_route53_zone" "my_hosted_zone" {
  name = "cloudstudy.one"
}

resource "aws_s3_bucket" "mybucket96339" {
  bucket = "mybucket96339"
}

resource "aws_lb_target_group" "tg" {
  name     = "my-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.myvpc.id
}

resource "aws_lb" "mylb" {
  name               = "mylb"
  internal           = true
  drop_invalid_header_fields = true 
  load_balancer_type = "application"
  security_groups    = [aws_security_group.mysg.id]
  subnets            = [aws_subnet.publicsubnet.id,aws_subnet.privatesubnet.id]
}

resource "aws_cloudwatch_metric_alarm" "demoapplication" {
  alarm_name                = "demoapplication"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 120
  statistic                 = "Average"
  threshold                 = 80
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
}

resource "aws_instance" "web" {
  ami                         = "ami-06ca3ca175f37dd66"
  instance_type               = "t2.micro"
  root_block_device {
    encrypted = true
  }
  disable_api_termination     = true
  key_name                    = "minikube"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.privatesubnet.id
  availability_zone           = "us-east-1a"
  private_ip                  = "192.168.20.10"  # Replace with your desired private IP address
  vpc_security_group_ids      = [aws_security_group.mysg.id]

  # Add the RDS instance as a dependency
  depends_on = [aws_db_instance.mydatabase]
}

output "instance_private_ip" {
  value = aws_instance.web.private_ip
}

resource "aws_db_instance" "mydatabase" {
  identifier           = "mydatabase"
  instance_class       = "db.t2.micro"
  engine               = "mysql"
  storage_encrypted    = true 
  name                 = "mydatabase"
  username             = "admin"
  password             = "ameer12"
  db_name              = "mydatabase"
  port                 = 3306
  publicly_accessible = false
  allocated_storage     = 20
  backup_retention_period = 1
}

