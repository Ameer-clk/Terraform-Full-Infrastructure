output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = aws_subnet.publicsubnet.id
}

output "private_subnet_id" {
  value = aws_subnet.privatesubnet.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.igw.id
}

output "security_group_id" {
  value = aws_security_group.newsg.id
}

output "launch_template_id" {
  value = aws_launch_template.newtemplate.id
}

output "target_group_id" {
  value = aws_lb_target_group.mytg.id
}

output "load_balancer_id" {
  value = aws_lb.my-lb.id
}

output "autoscaling_group_id" {
  value = aws_autoscaling_group.myAUG.id
}

output "alarm_name" {
  value = aws_cloudwatch_metric_alarm.newalarm.alarm_name
}

output "sns_topic_name" {
  value = aws_sns_topic.mytopic.name
}
