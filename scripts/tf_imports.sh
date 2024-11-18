#!/bin/bash

# Importa a VPC
VPC_ID=$(./scripts/get_first_vpc_id.sh "lanchonete-vpc") 
terraform import -var="aws_region=$AWS_REGION" -var="aws_zone_1=$AWS_ZONE_1" -var="aws_zone_2=$AWS_ZONE_2" aws_vpc.tf_vpc $VPC_ID || true

# Importa as subnets
PUBLIC_SUBNET_0_ID=$(./scripts/get_first_subnet_id.sh "lanchonete-public-subnet-0") 
PUBLIC_SUBNET_1_ID=$(./scripts/get_first_subnet_id.sh "lanchonete-public-subnet-1") 
PRIVATE_SUBNET_0_ID=$(./scripts/get_first_subnet_id.sh "lanchonete-private-subnet-0") 
PRIVATE_SUBNET_1_ID=$(./scripts/get_first_subnet_id.sh "lanchonete-private-subnet-1")

terraform import -var="aws_region=$AWS_REGION" -var="aws_zone_1=$AWS_ZONE_1" -var="aws_zone_2=$AWS_ZONE_2" aws_subnet.tf_public_subnet[0] $PUBLIC_SUBNET_0_ID
terraform import -var="aws_region=$AWS_REGION" -var="aws_zone_1=$AWS_ZONE_1" -var="aws_zone_2=$AWS_ZONE_2" aws_subnet.tf_public_subnet[1] $PUBLIC_SUBNET_1_ID
terraform import -var="aws_region=$AWS_REGION" -var="aws_zone_1=$AWS_ZONE_1" -var="aws_zone_2=$AWS_ZONE_2" aws_subnet.tf_private_subnet[0] $PRIVATE_SUBNET_0_ID
terraform import -var="aws_region=$AWS_REGION" -var="aws_zone_1=$AWS_ZONE_1" -var="aws_zone_2=$AWS_ZONE_2" aws_subnet.tf_private_subnet[1] $PRIVATE_SUBNET_1_ID

# Importa o cluster
terraform import -var="aws_region=$AWS_REGION" -var="aws_zone_1=$AWS_ZONE_1" -var="aws_zone_2=$AWS_ZONE_2" aws_eks_cluster.tf_eks_cluster lanchonete-eks-cluster || true

# Importa a role usada no cluster
terraform import -var="aws_region=$AWS_REGION" -var="aws_zone_1=$AWS_ZONE_1" -var="aws_zone_2=$AWS_ZONE_2" aws_iam_role.tf_eks_cluster_role lanchonete-eks-cluster-role || true
