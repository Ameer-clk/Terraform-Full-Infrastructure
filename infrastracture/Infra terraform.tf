  provider "aws" {
  region = "us-east-1"
  access_key = "sndsdwdhdhsdsdskdsd"
  secret_key = "sdakdjsdsjdkasdskdj"
}
  resource "aws_vpc" "main" {
  cidr_block = "10.1.0.0/16"
}

resource "aws_subnet" "mysubnet1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.1.10.0/24"
}

resource "aws_subnet" "mysubnet2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.1.20.0/24"
}

resource "aws_internet_gateway" "inetrnetgateway" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "myroutetable" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table_association" "myroutetable" {
  subnet_id      = aws_subnet.mysubnet1.id
  route_table_id = aws_route_table.myroutetable.id
}

resource "aws_security_group" "serversg" {
  name        = "serversg"
  description = "For new infra"
  vpc_id      = aws_vpc.main.id
}

resource "aws_ami" "example" {
  name                = "terraform-example"
  virtualization_type = "hvm"
  root_device_name    = "/dev/xvda"
  imds_support        = "v2.0"
  ebs_block_device {
    device_name = "/dev/xvda"
    snapshot_id = "snap-09c3bd9a539a0c1fb"
     volume_size = 100
  }
}

resource "aws_launch_template" "mytemplate" {
  name = "mytemplate"
  image_id = "ami-09d3b3274b6c5d4aa"
   instance_type = "t2.micro"
   key_name = "kubernetes"
}

resource "aws_lb_target_group" "newtargetgp" {
  name     = "newtargetgp"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb" "test" {
  name               = "test"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.serversg.id]
  subnets            = [aws_subnet.mysubnet1.id,aws_subnet.mysubnet2.id]
}

resource "aws_autoscaling_group" "myautoscalinggp" {
  availability_zones = ["us-east-1a"]
  desired_capacity   = 1
  max_size           = 2
  min_size           = 1

 launch_template {
    id      = aws_launch_template.mytemplate.id
    version = "$Latest"
  }
}
resource "aws_sns_topic" "newtopic" {
  name = "newtopic"
  kms_master_key_id = "alias/aws/sns"
}
