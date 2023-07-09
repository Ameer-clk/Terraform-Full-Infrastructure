output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet1_id" {
  value = aws_subnet.subnet1.id
}

output "subnet2_id" {
  value = aws_subnet.subnet2.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.myigw.id
}

output "route_table_id" {
  value = aws_route_table.myroutetable.id
}

output "security_group_id" {
  value = aws_security_group.mysg.id
}

output "launch_template_id" {
  value = aws_launch_template.mytemplate.id
}

output "target_group_id" {
  value = aws_lb_target_group.mytarget.id
}

output "load_balancer_id" {
  value = aws_lb.mylb.id
}

output "autoscaling_group_id" {
  value = aws_autoscaling_group.newaug.id
}

output "s3_bucket_name" {
  value = aws_s3_bucket.myb8ucket96339.bucket
}

output "alarm_name" {
  value = aws_cloudwatch_metric_alarm.myalarm.alarm_name
}

output "sns_topic_name" {
  value = aws_sns_topic.newtopic.name
}
