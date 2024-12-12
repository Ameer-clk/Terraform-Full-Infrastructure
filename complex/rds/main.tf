# Data source for VPC
data "aws_vpc" "existing_vpc" {
  filter {
    name   = "tag:Name"  # Correct filter for VPC by Name tag
    values = ["project636beta-vpc"] # Replace with the actual Name tag value of your VPC
  }
}

# Data source for Subnets
data "aws_subnets" "existing_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.existing_vpc.id] # Dynamically fetch VPC ID
  }
}

# Data source for Security Group
data "aws_security_group" "existing_sg" {
  filter {
    name   = "tag:Name"  # Use "tag:Name" to filter by Name tag
    values = ["project636beta-sg"] # Replace with the actual Name tag value of your SG
  }
}

# RDS Module
module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "project636beta-rds"

  engine            = "PostgreSQL"
  engine_version    = "16.4"
  instance_class    = "db.t3.medium"
  allocated_storage = 200

  db_name  = "postgres" 
  username = "postgres"
  port     = "5432"

  iam_database_authentication_enabled = true

  # Security Group
  vpc_security_group_ids = [data.aws_security_group.existing_sg.id]

  tags = {
    Owner       = "dev"
    Environment = "p636"
  }

  # DB Subnet Group
  create_db_subnet_group = false
  subnet_ids             = data.aws_subnets.existing_subnets.ids

  # DB Parameter Group
  family = "postgres16"

  # DB Option Group
  major_engine_version = "16.4"

  # Database Deletion Protection
  deletion_protection = false

  # Backup Configuration
  backup_retention_period = 7    # Retain backups for 7 days
  backup_window           = "02:00-03:00"  # Daily backup window in GSTter   

  # Multi-AZ Deployment for High Availability
  multi_az = true                    # If we need to store the backup we can use the az

  parameters = [
    {
      name  = "environment"
      value = "dev"
    },
    {
      name  = "owner"
      value = "p636"
    }
  ]
}


