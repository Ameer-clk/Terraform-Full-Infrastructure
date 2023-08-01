# Output the ID of the VPC
output "vpc_id" {
  value = aws_vpc.example_vpc.id
}

# Output the IDs of the public and private subnets
output "public_subnet_ids" {
  value = [aws_subnet.publicsubnet.id]
}

output "private_subnet_ids" {
  value = [aws_subnet.privatesubnet.id, aws_subnet.privatesubnet1.id]
}

# Output the ID of the Internet Gateway
output "internet_gateway_id" {
  value = aws_internet_gateway.myigw.id
}

# Output the ID of the Security Group
output "security_group_id" {
  value = aws_security_group.example_sg.id
}

# Output the ID of the Load Balancer
output "load_balancer_id" {
  value = aws_lb.newalb.id
}

# Output the DNS name of the Load Balancer
output "load_balancer_dns_name" {
  value = aws_lb.newalb.dns_name
}

# Output the ID of the Target Group
output "target_group_id" {
  value = aws_lb_target_group.newtarget_group.id
}

# Output the ARN of the Auto Scaling Group
output "auto_scaling_group_arn" {
  value = aws_autoscaling_group.myaug.arn
}

