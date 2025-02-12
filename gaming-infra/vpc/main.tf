# Backend Configuration to Store State in Existing S3 and Use Existing DynamoDB for Locking
terraform {
  backend "s3" {
    bucket         = "terraformtfstate123"         # Existing S3 bucket name
    key            = "eks/terraform.tfstate"      # State file path
    region         = "us-east-1"                  # AWS region
    dynamodb_table = "terraform-lock"             # Existing DynamoDB table for state locking
    encrypt        = true                         # Enable encryption
  }
}

module "prod-project636-vpc" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git?ref=26c38a66f12e7c6c93b6a2ba127ad68981a48671"  # commit hash of version 5.0.0


  name = "prod-project636-vpc"
  cidr = "10.2.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c",]
  private_subnets = ["10.2.8.0/22", "10.2.12.0/22", "10.2.16.0/22"]
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

resource "aws_security_group" "prod_project636_sg" {
  name        = "prod-project636-sg"
  description = "Security Group with restricted access"
  vpc_id      = module.prod-project636-vpc.vpc_id

  # Restrict inbound traffic to HTTPS (443) only from a trusted CIDR range
  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.2.8.0/22"]  # Ensure this range is correct and secure
  }

  # Restrict outbound traffic to only necessary destinations
  egress {
    description = "Allow outbound HTTPS to specific services"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [
      "10.2.8.0/22",  # Internal VPC range
      "10.1.0.0/24"   # Example trusted destination (modify as needed)
    ]
  }

  tags = {
    Name        = "prod-project636-sg"
    Environment = "prod"  # Changed from 'dev' to match 'prod' in the resource name
  }
}
