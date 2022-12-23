provider "aws" {
  region = "us-east-1"
  access_key = "my-access-key"
  secret_key = "my-secret-key"
}

resource "aws_vpc" "main" {
  cidr_block = "10.1.0.0/16"
}

resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.1.10.0/24"
}

resource "aws_subnet" "subnet2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.1.20.0/24"
}

resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "myroutetable" {
  vpc_id = aws_vpc.example.id
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.bar.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.bar.id
}

resource "aws_route_table_association" "c" {
  gateway_id     = aws_internet_gateway.myigw.id
  route_table_id = aws_route_table.myroutetable.id
}

resource "aws_security_group" "mysg" {
  name        = "mysg"
  description = "For the infra"
  vpc_id      = aws_vpc.main.id
}

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.main.cidr_block]
    ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  resource "aws_ebs_volume" "myvolume" {
  availability_zone = "us-east-2a"
  size              = 20 
  }

  resource "aws_ami" "example" {
  name                = "terraform-example"
  virtualization_type = "hvm"
  root_device_name    = "/dev/xvda"
  imds_support        = "v2.0" 
  ebs_block_device {
    device_name = "/dev/xvda"
    snapshot_id = "snap-xxxxxxxx"
    volume_size = 20 
  }
}

resource "aws_launch_template" "mytemplate" {
  name = "mytemplate"
  image_id = "ami-test"
  instance_type = "t2.micro"
      volume_size = 20
        key_name = "test"
}

resource "aws_lb_target_group" "mytarget" {
  name     = "mytarget"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb" "mylb" {
  name               = "mylb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.mysg.id]
  subnets            = [aws_subnet.subnet1.id,aws_subnet2.id]
}

resource "aws_autoscaling_group" "myaug" {
  availability_zones = ["us-east-1a"]
  desired_capacity   = 1
  max_size           = 4
  min_size           = 1

  launch_template {
    id      = aws_launch_template.mytemplate.id
    version = "$Latest"
  }
}
 
 resource "aws_s3_bucket" "myb8ucket96339" {
  bucket = "mybucket96339"
    acl    = "private"
 }

 resource "aws_db_instance" "default" {
  allocated_storage    = 100
  db_name              = "mydatabase"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  username             = "admin"
  password             = "admin12"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
}

resource "aws_route53domains_registered_domain" "example" {
  domain_name = "example.com"
}

resource "aws_cloudwatch_metric_alarm" "myalarm" {
  alarm_name                = "myalarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "60"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
}

resource "aws_sns_topic" "servernot" {
  name = "servernot"
}
   
