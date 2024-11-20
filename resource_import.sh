#!/bin/bash

import_resource() {
  local resource_type=$1
  local resource_name=$2
  local resource_id=$3

  terraform import \
  # -var="aws_region=$AWS_REGION" \
  # -var="aws_zone_1=$AWS_ZONE_1" \
  # -var="aws_zone_2=$AWS_ZONE_2" \
  "$resource_type.$resource_name" "$resource_id" || true
}

check_eks_cluster_exists() {
  local cluster_name=$1
  aws eks list-clusters --query "clusters[?@=='${cluster_name}'] | [0]" --output text
}

check_iam_role_exists() {
  local role_name=$1
  aws iam list-roles --query "Roles[?RoleName=='${role_name}'] | [0].RoleName" --output text
}

get_first_vpc_id() {
  local vpc_name=$1
  aws ec2 describe-vpcs --filters \
  "Name=tag:Name,Values=${vpc_name}" --query "Vpcs[0].VpcId" --output text
}

get_first_subnet_id() {
  local subnet_name=$1
  aws ec2 describe-subnets --filters \
  "Name=tag:Name,Values=${subnet_name}" --query "Subnets[0].SubnetId" --output text
}

# Importa o cluster kubernetes
CLUSTER_NAME="lanchonete-eks-cluster"
CLUSTER_EXISTS=$(check_eks_cluster_exists "$CLUSTER_NAME")
if [ "$CLUSTER_EXISTS" == "None" ]; then
  echo "Recurso aws_eks_cluster.tf_eks_cluster não encontrado."
else
  import_resource "aws_eks_cluster" "tf_eks_cluster" "$CLUSTER_NAME"
fi

# Importa a role usada no cluster
ROLE_NAME="lanchonete-eks-cluster-role"
ROLE_EXISTS=$(check_iam_role_exists "$ROLE_NAME")
if [ "$ROLE_EXISTS" == "None" ]; then
  echo "Recurso aws_iam_role.tf_eks_cluster_role não encontrado."
else
  import_resource "aws_iam_role" "tf_eks_cluster_role" "$ROLE_NAME"
fi

# Importa a VPC
VPC_ID=$(get_first_vpc_id "lanchonete-vpc")
if [ "$VPC_ID" == "None" ]; then
  echo "Recurso aws_vpc.tf_vpc não encontrado."
else
  import_resource "aws_vpc" "tf_vpc" "$VPC_ID"
fi

# Importa as subnets
PUBLIC_SUBNET_0_ID=$(get_first_subnet_id "lanchonete-public-subnet-0")
if [ "$PUBLIC_SUBNET_0_ID" == "None" ]; then
  echo "Recurso aws_subnet.tf_public_subnet[0] não encontrado."
else
  import_resource "aws_subnet" "tf_public_subnet[0]" "$PUBLIC_SUBNET_0_ID"
fi

PUBLIC_SUBNET_1_ID=$(get_first_subnet_id "lanchonete-public-subnet-1")
if [ "$PUBLIC_SUBNET_1_ID" == "None" ]; then
  echo "Recurso aws_subnet.tf_public_subnet[1] não encontrado."
else
  import_resource "aws_subnet" "tf_public_subnet[1]" "$PUBLIC_SUBNET_1_ID"
fi

PRIVATE_SUBNET_0_ID=$(get_first_subnet_id "lanchonete-private-subnet-0")
if [ "$PRIVATE_SUBNET_0_ID" == "None" ]; then
  echo "Recurso aws_subnet.tf_private_subnet[0] não encontrado."
else
  import_resource "aws_subnet" "tf_private_subnet[0]" "$PRIVATE_SUBNET_0_ID"
fi

PRIVATE_SUBNET_1_ID=$(get_first_subnet_id "lanchonete-private-subnet-1")
if [ "$PRIVATE_SUBNET_1_ID" == "None" ]; then
  echo "Recurso aws_subnet.tf_private_subnet[1] não encontrado."
else
  import_resource "aws_subnet" "tf_private_subnet[1]" "$PRIVATE_SUBNET_1_ID"
fi

