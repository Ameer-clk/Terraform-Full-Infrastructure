#!/bin/bash

# Variables
KARPENTER_VERSION="0.16.3"
KARPENTER_IAM_ROLE_ARN="arn:aws:iam::891377279275:role/KarpenterController-20241122064215956900000001"
CLUSTER_NAME=	"prod-project636-cluster"
CLUSTER_ENDPOINT= "https://5F314C28F5D79FC81B8895A85A19CA92.gr7.eu-west-2.eks.amazonaws.com"

# Add Karpenter Helm repository
helm repo add karpenter https://charts.karpenter.sh/
helm repo update

# Install or upgrade Karpenter
helm upgrade --install --namespace karpenter --create-namespace \
  karpenter karpenter/karpenter \
  --version ${KARPENTER_VERSION} \
  --set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"=${KARPENTER_IAM_ROLE_ARN} \
  --set clusterName=${CLUSTER_NAME} \
  --set clusterEndpoint=${CLUSTER_ENDPOINT} \
  --set aws.defaultInstanceProfile=KarpenterNodeInstanceProfile-${CLUSTER_NAME} \
  --wait
