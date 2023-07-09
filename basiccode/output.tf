output "vpc_id" {
  value = aws_vpc.example_vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.example_publicsubnet.id
}

output "private_subnet_id" {
  value = aws_subnet.example_privatesubnet.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.example_igw.id
}

output "security_group_id" {
  value = aws_security_group.example_sg.id
}

output "instance_id" {
  value = aws_instance.web.id
}

output "instance_private_ip" {
  value = aws_instance.web.private_ip
}
