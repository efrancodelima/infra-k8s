#!/bin/bash

# Constantes
DHCP_OPTIONS_ID="dopt-0c8fc57b079c91172"
EKS_CLUSTER_NAME="lanchonete-eks-cluster"
INTERNET_GATEWAY_ID="igw-0a0f387d0f166b3a6"
POLICY_NAME_1="AmazonEKSClusterPolicy"
POLICY_NAME_2="AmazonRDSFullAccess"
POLICY_NAME_3="CloudWatchFullAccess"
POLICY_NAME_4="AmazonEC2FullAccess"
PRIVATE_SUBNET_ID_0="subnet-0a35b1afb7b19cda1"
PRIVATE_SUBNET_ID_1="subnet-0b03f410da640c4cb"
PUBLIC_SUBNET_ID_0="subnet-04210519054c41980"
PUBLIC_SUBNET_ID_1="subnet-0dcb9a941b96ae94b"
ROLE_NAME="lanchonete-eks-cluster-role"
ROUTE="0.0.0.0/0"
ROUTE_TABLE_ID="rtb-0d2b24549dac7dc8e"
VPC_ID="vpc-0ea4cbbd6e92e3abe"



# Função auxiliar
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

# Importa o DHCP Options
import_resource "aws_vpc_dhcp_options" "tf_dhcp_options" "${DHCP_OPTIONS_ID}"

# Importa o cluster kubernetes
import_resource "aws_eks_cluster" "tf_eks_cluster" "$EKS_CLUSTER_NAME"

# Importa o Internet Gateway
import_resource "aws_internet_gateway" "tf_internet_gateway" "${INTERNET_GATEWAY_ID}"

# Importa os policy attachment da role
import_resource "aws_iam_role_policy_attachment" "eks_policy" \
"lanchonete-eks-cluster-role/arn:aws:iam::aws:policy/${POLICY_NAME_1}"

import_resource "aws_iam_role_policy_attachment" "rds_policy" \
"lanchonete-eks-cluster-role/arn:aws:iam::aws:policy/${POLICY_NAME_2}"

import_resource "aws_iam_role_policy_attachment" "cloudwatch_policy" \
"lanchonete-eks-cluster-role/arn:aws:iam::aws:policy/${POLICY_NAME_3}"

import_resource "aws_iam_role_policy_attachment" "ec2_policy" \
"lanchonete-eks-cluster-role/arn:aws:iam::aws:policy/${POLICY_NAME_4}"

# Importa as subnets
import_resource "aws_subnet" "tf_private_subnet[0]" "$PRIVATE_SUBNET_0_ID"
import_resource "aws_subnet" "tf_private_subnet[1]" "$PRIVATE_SUBNET_1_ID"
import_resource "aws_subnet" "tf_public_subnet[0]" "$PUBLIC_SUBNET_0_ID"
import_resource "aws_subnet" "tf_public_subnet[1]" "$PUBLIC_SUBNET_1_ID"

# Importa a role usada no cluster
import_resource "aws_iam_role" "tf_eks_cluster_role" "$ROLE_NAME"

# Importa a Route
import_resource "aws_route" "tf_route" "${ROUTE_TABLE_ID}_${ROUTE}"

# Importa a Route Table
import_resource "aws_route_table" "tf_route_table" "${ROUTE_TABLE_ID}"

# Importa a VPC
import_resource "aws_vpc" "tf_vpc" "$VPC_ID"
