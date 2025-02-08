data "aws_nat_gateway" "existing_nat_gateway" {
  filter {
    name   = "tag:Name"
    values = ["project636beta-vpc-us-east-2a"] # Replace with the tag name of your existing NAT gateway
  }
}

data "aws_subnet" "project636beta_vpc_private_us_east_2a" {
  filter {
    name   = "tag:Name"
    values = ["project636beta-vpc-private-us-east-2a"] # Replace with the tag name of your existing private subnet
  }
}

data "aws_security_group" "project636beta_sg" {
  filter {
    name   = "tag:Name"
    values = ["project636beta-sg"] # Replace with the tag name of your existing security group
  }
}

resource "aws_instance" "project636beta_instance" {
  ami                         = "ami-00eb69d236edcfaf8" # Replace with the Ubuntu AMI Image
  instance_type               = "t2.micro" # Replace with the desired instance type
  metadata_options {
     http_endpoint = "enabled"
+    http_tokens   = "required"
  }
}
  root_block_device {
    encrypted = true
  }
  disable_api_termination     = true
  key_name                    = "pilot-panel" # Replace with the key name
  associate_public_ip_address = false # Set to false as the instance is in a private subnet
  subnet_id                   = data.aws_subnet.project636beta_vpc_private_us_east_2a.id
  availability_zone           = "us-east-2a"
  private_ip                  = "10.2.8.10"  # Replace with your desired private IP address
  vpc_security_group_ids      = [data.aws_security_group.project636beta_sg.id]
  depends_on                  = [data.aws_nat_gateway.existing_nat_gateway] # Ensure the NAT gateway is created first
}

resource "aws_ebs_volume" "project636beta_volume" {
  availability_zone = "us-east-2a" # Replace with your desired availability zone
  size              = 10           # Replace with the desired size in GB
  type              = "gp2"        # Replace with the desired volume type
  encrypted         = true
}

resource "aws_volume_attachment" "project636beta_attachment" {
  device_name = "/dev/sda2" # Replace with the desired device name
  volume_id   = aws_ebs_volume.project636beta_volume.id
  instance_id = aws_instance.project636beta_instance.id
}
