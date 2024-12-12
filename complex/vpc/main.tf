module "project636beta-vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "project636beta-vpc"
  cidr = "10.2.0.0/16" 

  azs             = ["us-east-2a", "us-east-2b", "us-east-2c"]
  private_subnets = ["10.2.8.0/22", "10.2.12.0/22", "10.2.16.0/22", "10.2.20.0/22"]
  public_subnets  = ["10.2.0.0/22", "10.2.4.0/22", "10.2.20.0/22", "10.2.24.0/22"]


  enable_nat_gateway = true
  single_nat_gateway = true
  enable_vpn_gateway = false
   
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

# Custom Security Group
resource "aws_security_group" "project636beta-sg" {
  name        = "project636beta-sg"
  description = "Define the custom port to add in the security group"
  vpc_id      = module.project636beta-vpc.vpc_id

  ingress {
    description      = "Allow HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Allow HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Allow SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }


  ingress {
    description      = "Allow SSH"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "project636beta-sg"
    Environment = "dev"
  }
}
