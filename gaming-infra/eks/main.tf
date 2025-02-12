# Data source to fetch existing VPC by name
data "aws_vpc" "existing_vpc" {
  filter {
    name   = "tag:Name"
    values = ["prod-project636-vpc"]  # Replace with your existing VPC name
  }
}

# IAM Role for EKS
resource "aws_iam_role" "eks_role_prod" {
  name = "eks-cluster-role-prod"

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

# IAM Role for the EBS CSI Driver
resource "aws_iam_role" "prod_ebs_csi_driver_role" {
  name = "prod-ebs-csi-driver-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# IAM Policy for EBS CSI Driver with Full Access to EC2
resource "aws_iam_role_policy_attachment" "eks_role_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_role_prod.name
}

# IAM Policy for EBS CSI Driver with Full Access to EKS Cluster Resources
resource "aws_iam_role_policy_attachment" "eks_vpc_resource_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"  # Corrected policy ARN
  role       = aws_iam_role.eks_role_prod.name
}

# IAM Policy for EBS CSI Driver with Full Access to EC2 and EKS Cluster Resources
resource "aws_iam_policy" "prod_ebs_csi_driver_policy" {
  name        = "AmazonEBSCSIDriverPolicy"
  description = "Policy for EBS CSI driver for EKS with least privilege"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:CreateSnapshot",
                "ec2:AttachVolume",
                "ec2:DetachVolume",
                "ec2:ModifyVolume",
                "ec2:DescribeAvailabilityZones",
                "ec2:DescribeInstances",
                "ec2:DescribeSnapshots",
                "ec2:DescribeTags",
                "ec2:DescribeVolumes",
                "ec2:DescribeVolumesModifications"
            ],
            "Resource": [
                "arn:aws:ec2:*:*:volume/*",
                "arn:aws:ec2:*:*:snapshot/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:CreateTags"
            ],
            "Resource": [
                "arn:aws:ec2:*:*:volume/*",
                "arn:aws:ec2:*:*:snapshot/*"
            ],
            "Condition": {
                "StringEquals": {
                    "ec2:CreateAction": [
                        "CreateVolume",
                        "CreateSnapshot"
                    ]
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DeleteTags"
            ],
            "Resource": [
                "arn:aws:ec2:*:*:volume/*",
                "arn:aws:ec2:*:*:snapshot/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:CreateVolume"
            ],
            "Resource": [
                "arn:aws:ec2:*:*:volume/*"
            ],
            "Condition": {
                "StringLike": {
                    "aws:RequestTag/ebs.csi.aws.com/cluster": "true"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:CreateVolume"
            ],
            "Resource": [
                "arn:aws:ec2:*:*:volume/*"
            ],
            "Condition": {
                "StringLike": {
                    "aws:RequestTag/CSIVolumeName": "*"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DeleteVolume"
            ],
            "Resource": [
                "arn:aws:ec2:*:*:volume/*"
            ],
            "Condition": {
                "StringLike": {
                    "ec2:ResourceTag/ebs.csi.aws.com/cluster": "true"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DeleteVolume"
            ],
            "Resource": [
                "arn:aws:ec2:*:*:volume/*"
            ],
            "Condition": {
                "StringLike": {
                    "ec2:ResourceTag/CSIVolumeName": "*"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DeleteVolume"
            ],
            "Resource": [
                "arn:aws:ec2:*:*:volume/*"
            ],
            "Condition": {
                "StringLike": {
                    "ec2:ResourceTag/kubernetes.io/created-for/pvc/name": "*"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DeleteSnapshot"
            ],
            "Resource": [
                "arn:aws:ec2:*:*:snapshot/*"
            ],
            "Condition": {
                "StringLike": {
                    "ec2:ResourceTag/CSIVolumeSnapshotName": "*"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DeleteSnapshot"
            ],
            "Resource": [
                "arn:aws:ec2:*:*:snapshot/*"
            ],
            "Condition": {
                "StringLike": {
                    "ec2:ResourceTag/ebs.csi.aws.com/cluster": "true"
                }
            }
        }
    ]
  })
}

# Create the EKS Cluster
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "prod-project636-cluster"
  cluster_version = "1.31"

  cluster_endpoint_public_access  = true

  vpc_id                   = data.aws_vpc.existing_vpc.id
  subnet_ids               = ["subnet-0765a54fc272df21e", "subnet-0e40704d7c6581afd", "subnet-0a45e25ea76b27861"]


  eks_managed_node_groups = {
    prod-project636 = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.large", "t3.large"]
      min_size       = 1
      max_size       = 2
      desired_size   = 2

      #Enable node auto-repair # ensures only one node is updated at a time, which is critical to maintaining cluster availability.
      update_config = {
        max_unavailable = 1
      }
    }
  }
  
  enable_cluster_creator_admin_permissions = true

  tags = {
    Name = "prod-project636-cluster"
  }
}


# Install the VPC CNI add-on
resource "aws_eks_addon" "eks_vpc_cni_addon" {
  cluster_name                = "prod-project636-cluster"
  addon_name                  = "vpc-cni"
  addon_version               = "v1.19.2-eksbuild.1" # Replace with a valid version if needed
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  # Remove unsupported configuration values
  configuration_values = jsonencode({
    # Only include valid configuration options here
  })
}

resource "aws_eks_addon" "eks_coredns_addon" {
  cluster_name                = "prod-project636-cluster"
  addon_name                  = "coredns"
  addon_version               = "v1.11.4-eksbuild.2"  # Replace with the latest supported version
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  # Configuration values if any can be added here
  configuration_values = jsonencode({
    # Only include valid configuration options here if needed
  })
}

resource "aws_eks_addon" "eks_kube_proxy_addon" {
  cluster_name                = "prod-project636-cluster"
  addon_name                  = "kube-proxy"
  addon_version               = "v1.31.3-eksbuild.2"  # Replace with the latest supported version
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  # Configuration values if any can be added here
  configuration_values = jsonencode({
    # Only include valid configuration options here if needed
  })
}

resource "aws_eks_addon" "eks_ebs_csi_driver_addon" {
  cluster_name                = "prod-project636-cluster"
  addon_name                  = "aws-ebs-csi-driver"
  addon_version               = "v1.38.1-eksbuild.1"  # Replace with the latest supported version
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
  service_account_role_arn    = aws_iam_role.prod_ebs_csi_driver_role.arn

  # Configuration values if any can be added here
  configuration_values = jsonencode({
    # Only include valid configuration options here if needed
  })
}

# Addon for Node Monitoring Agent
resource "aws_eks_addon" "eks_Node_monitoring_agent" {
  cluster_name                = "prod-project636-cluster"
  addon_name                  = "node-monitoring-agent"  # Addon name for Node Monitoring Agent
  addon_version               = "v1.0.1-eksbuild.2"       # Replace with the latest supported version
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  # Configuration values specific to Node Monitoring Agent can be added here
  configuration_values = jsonencode({
    # Example configuration options, if required
  })
}
