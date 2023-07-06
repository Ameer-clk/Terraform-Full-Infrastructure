provider "aws" {
  region     = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block = "172.20.0.0/16"
}

resource "aws_subnet" "publicsubnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "172.20.10.0/24"
}

resource "aws_subnet" "privatesubnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "172.20.30.0/24"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "myroutetable" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.publicsubnet.id
  route_table_id = aws_route_table.myroutetable.id
}

resource "aws_security_group" "newsg" {
  name        = "newsg"
  description = "For the ifra"
  vpc_id      = aws_vpc.main.id
}

resource "aws_ami" "example" {
  name                = "terraform-example"
  virtualization_type = "hvm"
  root_device_name    = "/dev/xvda"
  imds_support        = "v2.0" 
  ebs_block_device {
    device_name = "/dev/xvda"
    snapshot_id = "snap-0e9b82395b5fc5fb5"
    volume_size = 100
  }
}

resource "aws_launch_template" "newtemplate" {
  name = "newtemplate"
  image_id = "ami-06e46074ae430fba6"
  instance_type = "t2.micro"
  key_name = "minikube"
}

resource "aws_lb_target_group" "mytg" {
  name     = "mytg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb" "my-lb" {
  name               = "my-lb"
  internal           = true
  drop_invalid_header_fields = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.newsg.id]
  subnets            = [aws_subnet.publicsubnet.id,aws_subnet.privatesubnet.id]
}

resource "aws_autoscaling_group" "myAUG" {
  availability_zones = ["us-east-1a", "us-east-1b"]
  desired_capacity   = 1
  max_size           = 2
  min_size           = 1

  launch_template {
    id      = aws_launch_template.newtemplate.id
    version = "$Latest"
  }
}

resource "aws_cloudwatch_metric_alarm" "newalarm" {
  alarm_name                = "newalarm"
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

resource "aws_sns_topic" "mytopic" {
  name = "mytopic"
  kms_master_key_id = "bfe2b7d4-cca1-4240-82f7-81ae2b9a55a0"
}
