module "prod-project636-vpc" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git?ref=26c38a66f12e7c6c93b6a2ba127ad68981a48671"  # commit hash of version 5.0.0


  name = "prod-project636-vpc"
  cidr = "10.2.0.0/16"

  azs             = ["eu-west-2a", "eu-west-2b", "eu-west-2c",]
  private_subnets = ["10.2.8.0/22", "10.2.12.0/22", "10.2.16.0/22", "10.2.20.0/22", "10.2.28.0/22" ,  "10.2.32.0/22"]
  public_subnets  = ["10.2.0.0/22", "10.2.4.0/22", "10.2.24.0/22"]


  enable_nat_gateway = true
  single_nat_gateway = true
  enable_vpn_gateway = false
  
  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }

  tags = {
    Terraform                                = "true"
    Environment                              = "prod"
    "kubernetes.io/cluster/prod-project636-cluster" = "shared"
    "karpenter.sh/discovery"                 = "prod-project636-cluster"
  }
}

# Custom Security Group
resource "aws_security_group" "prod-project636-sg" {
  name        = "prod-project636-sg"
  description = "Define the custom port to add in the security group"
  vpc_id      = module.prod-project636-vpc.vpc_id

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

  egress {
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "prod-project636-sg"
    Environment = "dev"
  }
}

# Custom Security Group
resource "aws_security_group" "prod-rds-project636-sg" {
  name        = "prod-rds-project636-sg"
  description = "Define the custom port to add in the security group"
  vpc_id      = module.prod-project636-vpc.vpc_id


  ingress {
    description      = "Allow SSH"
    from_port        = 5432
    to_port          = 5432
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
    Name        = "prod-rds-project636-sg"
    Environment = "dev"
  }
}

# Custom Security Group
resource "aws_security_group" "prod-elasticache-project636-sg" {
  name        = "prod-elasticache-project636-sg"
  description = "Define the custom port to add in the security group"
  vpc_id      = module.prod-project636-vpc.vpc_id


  ingress {
    description      = "Allow SSH"
    from_port        = 6379
    to_port          = 6379
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
    Name        = "prod-elasticache-project636-sg"
    Environment = "dev"
  }
}
