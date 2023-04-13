provider "aws" {
  region = "us-east-1"
  access_key = "AKIARN2CQI32K2PS4N5P"
  secret_key =  "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"
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
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.myroutetable.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.myroutetable.id
}

resource "aws_security_group" "mysg" {
  name        = "mysg"
  description = "For the infra"
  vpc_id      = aws_vpc.main.id
}

 resource "aws_ami_copy" "myami" {
  name              = "myami"
  description       = "creating new infra"
  source_ami_id     = "ami-06e46074ae430fba6"
  source_ami_region = "us-east-1"
  }

resource "aws_launch_template" "mytemplate" {
  name = "mytemplate"
  instance_type = "t2.micro"
  image_id = "ami-06e46074ae430fba6"
  key_name = "server"
   
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
  subnets            = [aws_subnet.subnet1.id,aws_subnet.subnet2.id]
}

resource "aws_autoscaling_group" "newaug" {
  availability_zones = ["us-east-1b"]
  desired_capacity   = 1
  max_size           = 2
  min_size           = 1

  launch_template {
    id      = aws_launch_template.mytemplate.id
    version = "$Latest"
  }
}
 
 resource "aws_s3_bucket" "myb8ucket96339" {
  bucket = "mybucket96339"
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

resource "aws_sns_topic" "newtopic" {
  name = "newtopic"
}
