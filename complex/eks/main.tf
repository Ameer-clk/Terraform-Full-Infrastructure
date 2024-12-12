# Data source to fetch existing VPC by name
data "aws_vpc" "existing_vpc" {
  filter {
    name   = "tag:Name"
    values = ["project636beta-vpc"]  # Replace with your existing VPC name
  }
}

# IAM Role for EKS
resource "aws_iam_role" "eks_role" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Effect    = "Allow"
        Sid       = ""
      }
    ]
  })
}

# Attach necessary policies to the IAM role
resource "aws_iam_role_policy_attachment" "eks_role_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_role.name
}

resource "aws_iam_role_policy_attachment" "eks_vpc_resource_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_VPC_Resource_Controller"
  role       = aws_iam_role.eks_role.name
}

# Create the EKS Cluster
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "project636beta-cluster"
  cluster_version = "1.31"

  cluster_endpoint_public_access  = true

  vpc_id                   = data.aws_vpc.existing_vpc.id
  subnet_ids               = ["subnet-065d6543f0041a40d", "subnet-079231faa0933269d", "subnet-06d3415e0b6fef022"] #Replace with actuall subnet ids
  cluster_security_group_id = "project636beta-sg"  #Replace with security group


  eks_managed_node_groups = {
    project636beta = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.large", "t3a.large"] 
      min_size       = 1
      max_size       = 2
      desired_size   = 2
    }
  }

  enable_cluster_creator_admin_permissions = true

  tags = {
    Name = "project636beta-cluster"
  }
}
