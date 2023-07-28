output "instance_public_ip" {

  value = aws_instance.web.public_ip

}



output "database_endpoint" {

  value = aws_db_instance.mydatabase.endpoint

}


