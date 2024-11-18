#!/bin/bash

import_resource() {
  local resource_type=$1
  local resource_name=$2
  local resource_id=$3

  terraform import \
  -var="aws_region=$AWS_REGION" \
  -var="aws_zone_1=$AWS_ZONE_1" \
  -var="aws_zone_2=$AWS_ZONE_2" \
  "$resource_type.$resource_name" "$resource_id" || true
}

get_first_vpc_id() {
  local vpc_name=$1
  aws ec2 describe-vpcs --filters \
  "Name=tag:Name,Values=${vpc_name}" --query "Vpcs[0].VpcId" --output text \
}

get_first_subnet_id() {
  local subnet_name=$1
  aws ec2 describe-subnets --filters \
  "Name=tag:Name,Values=${subnet_name}" --query "Subnets[0].SubnetId" --output text
}

# Importa a VPC
VPC_ID=$(get_first_vpc_id "lanchonete-vpc")
import_resource "aws_vpc" "tf_vpc" "$VPC_ID"

# Importa as subnets
PUBLIC_SUBNET_0_ID=$(get_first_subnet_id "lanchonete-public-subnet-0")
PUBLIC_SUBNET_1_ID=$(get_first_subnet_id "lanchonete-public-subnet-1")
PRIVATE_SUBNET_0_ID=$(get_first_subnet_id "lanchonete-private-subnet-0")
PRIVATE_SUBNET_1_ID=$(get_first_subnet_id "lanchonete-private-subnet-1")

import_resource "aws_subnet" "tf_public_subnet[0]" "$PUBLIC_SUBNET_0_ID"
import_resource "aws_subnet" "tf_public_subnet[1]" "$PUBLIC_SUBNET_1_ID"
import_resource "aws_subnet" "tf_private_subnet[0]" "$PRIVATE_SUBNET_0_ID"
import_resource "aws_subnet" "tf_private_subnet[1]" "$PRIVATE_SUBNET_1_ID"

# Importa o cluster kubernetes
import_resource "aws_eks_cluster" "tf_eks_cluster" "lanchonete-eks-cluster"

# Importa a role usada no cluster
import_resource "aws_iam_role" "tf_eks_cluster_role" "lanchonete-eks-cluster-role"
