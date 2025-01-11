resource "aws_secretsmanager_secret" "rds_proxy_secret" {
  name = "rds_proxy_secret"
}

resource "aws_secretsmanager_secret_version" "rds_proxy_secret_version" {
  secret_id = aws_secretsmanager_secret.rds_proxy_secret.id
  secret_string = jsonencode({
    username = "postgres"
    password = "spmpdw1(<gX2vPJ[ICS8D<sO#Gx]"  # Replace with your actual password
  })
}

resource "aws_db_proxy" "prod-project636-proxy" {
  name                   = "prod-project636beta-proxy"
  engine_family          = "POSTGRESQL"
  role_arn               = aws_iam_role.rds_proxy_role.arn
  vpc_security_group_ids = [data.aws_security_group.existing_sg.id]
  vpc_subnet_ids         = data.aws_subnets.existing_subnets.ids
  require_tls            = true

  auth {
    description = "IAM Auth for RDS Proxy"
    iam_auth    = "REQUIRED"
    secret_arn  = aws_secretsmanager_secret.rds_proxy_secret.arn
  }
}

resource "aws_db_proxy_target" "prod_project636_target" {
  db_proxy_name          = aws_db_proxy.prod-project636-proxy.name
  target_group_name      = "default"  # You can specify a custom target group name if needed
  db_instance_identifier = "prod-project636"  # Use the identifier directly
}

resource "aws_iam_role" "rds_proxy_role" {
  name = "rds_proxy_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "rds.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "rds_proxy_policy" {
  name = "rds_proxy_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "rds-db:connect"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "rds_proxy_policy_attachment" {
  role       = aws_iam_role.rds_proxy_role.name
  policy_arn = aws_iam_policy.rds_proxy_policy.arn
}

# Data source for VPC
data "aws_vpc" "existing_vpc" {
  filter {
    name   = "tag:Name"  # Correct filter for VPC by Name tag
    values = ["prod-project636-vpc"] # Replace with the actual Name tag value of your VPC
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
    values = ["prod-rds-project636-sg"] # Replace with the actual Name tag value of your SG
  }
}

module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier         = "prod-project636" # Give desired name for the DB
  engine             = "postgres"
  engine_version     = "16.3"                 # Adjusted to a valid version if 16.4 is unsupported
  instance_class     = "db.t3.2xlarge"
  allocated_storage  = 50
  db_name            = "prodproject636"
  username           = "postgres"
  port               = "5432"

  iam_database_authentication_enabled = true

  # Disable Option Group creation
  create_db_option_group = false

  # Security Group
  vpc_security_group_ids = [data.aws_security_group.existing_sg.id]

  tags = {
    Owner       = "p636"
    Environment = "dev"
  }

  # DB Subnet Group
  create_db_subnet_group = true
  subnet_ids             = data.aws_subnets.existing_subnets.ids

  # DB Parameter Group
  family = "postgres16"

  # Database Deletion Protection
  deletion_protection = false

  # Backup Configuration
  backup_retention_period = 7
  backup_window           = "02:00-03:00"

  # Multi-AZ Deployment
  multi_az = true

  # Performance Insights
  performance_insights_enabled          = true
  performance_insights_retention_period = 7   # Optional: Retention period in days (7 is default, up to 731)
 }



