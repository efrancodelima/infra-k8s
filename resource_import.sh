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

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Elastic Kubernetes Service - EKS
# Constantes

EKS_CLUSTER_NAME="lanchonete-eks-cluster"
EKS_NODE_GROUP_NAME="lanchonete-eks-node-group"
SECURITY_GROUP_ID="sg-092ee8ed45119bdd6"

CLUSTER_ROLE_NAME="lanchonete-eks-cluster-role"
CLUSTER_POLICY_NAME_1="AmazonEKSClusterPolicy"
CLUSTER_POLICY_NAME_2="AmazonRDSFullAccess"
CLUSTER_POLICY_NAME_3="CloudWatchFullAccess"
CLUSTER_POLICY_NAME_4="AmazonEC2FullAccess"

NG_ROLE_NAME="lanchonete-eks-node-group-role"
NG_POLICY_NAME_1="AmazonEKSWorkerNodePolicy"
NG_POLICY_NAME_2="AmazonRDSFullAccess"
NG_POLICY_NAME_3="AmazonEKS_CNI_Policy"
NG_POLICY_NAME_4="AmazonEC2ContainerRegistryReadOnly"

# Importa o cluster EKS
import_resource "aws_eks_cluster" "tf_eks_cluster" "${EKS_CLUSTER_NAME}"

# Importa o node group
import_resource "aws_eks_node_group" "tf_eks_node_group" "${EKS_CLUSTER_NAME}:${EKS_NODE_GROUP_NAME}"

# Importa o security group
import_resource "aws_security_group" "tf_eks_security_group" "${SECURITY_GROUP_ID}"

# Importa a role do cluster
import_resource "aws_iam_role" "tf_eks_cluster_role" "$CLUSTER_ROLE_NAME"

# Importa os policy attachment da role do cluster
import_resource "aws_iam_role_policy_attachment" "tf_cluster_policy_eks" \
"lanchonete-eks-cluster-role/arn:aws:iam::aws:policy/${CLUSTER_POLICY_NAME_1}"

import_resource "aws_iam_role_policy_attachment" "tf_cluster_policy_rds" \
"lanchonete-eks-cluster-role/arn:aws:iam::aws:policy/${CLUSTER_POLICY_NAME_2}"

import_resource "aws_iam_role_policy_attachment" "tf_cluster_policy_cloud_watch" \
"lanchonete-eks-cluster-role/arn:aws:iam::aws:policy/${CLUSTER_POLICY_NAME_3}"

import_resource "aws_iam_role_policy_attachment" "tf_cluster_policy_ec2" \
"lanchonete-eks-cluster-role/arn:aws:iam::aws:policy/${CLUSTER_POLICY_NAME_4}"

# Importa a role do node group
import_resource "aws_iam_role" "tf_eks_node_group_role" "$NG_ROLE_NAME"

# Importa os policy attachment da role do node group
import_resource "aws_iam_role_policy_attachment" "tf_ng_policy_eks" \
"lanchonete-eks-cluster-role/arn:aws:iam::aws:policy/${NG_POLICY_NAME_1}"

import_resource "aws_iam_role_policy_attachment" "tf_ng_policy_rds" \
"lanchonete-eks-cluster-role/arn:aws:iam::aws:policy/${NG_POLICY_NAME_2}"

import_resource "aws_iam_role_policy_attachment" "tf_ng_policy_eks_cni" \
"lanchonete-eks-cluster-role/arn:aws:iam::aws:policy/${NG_POLICY_NAME_3}"

import_resource "aws_iam_role_policy_attachment" "tf_ng_policy_ec2" \
"lanchonete-eks-cluster-role/arn:aws:iam::aws:policy/${NG_POLICY_NAME_4}"


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# REDE
# Constantes
VPC_ID="vpc-0ea4cbbd6e92e3abe"
PUBLIC_SUBNET_ID_0="subnet-04210519054c41980"
PUBLIC_SUBNET_ID_1="subnet-0dcb9a941b96ae94b"
PRIVATE_SUBNET_ID_0="subnet-0a35b1afb7b19cda1"
PRIVATE_SUBNET_ID_1="subnet-0b03f410da640c4cb"
ROUTE_TABLE_ID="rtb-0d2b24549dac7dc8e"
DHCP_OPTIONS_ID="dopt-0c8fc57b079c91172"
INTERNET_GATEWAY_ID="igw-0a0f387d0f166b3a6"

# Importa a VPC
import_resource "aws_vpc" "tf_vpc" "${VPC_ID}"

# Importa as subnets
import_resource "aws_subnet" "tf_public_subnet[0]" "${PUBLIC_SUBNET_ID_0}"
import_resource "aws_subnet" "tf_public_subnet[1]" "${PUBLIC_SUBNET_ID_1}"
import_resource "aws_subnet" "tf_private_subnet[0]" "${PRIVATE_SUBNET_ID_0}"
import_resource "aws_subnet" "tf_private_subnet[1]" "${PRIVATE_SUBNET_ID_1}"

# Importa a route table
import_resource "aws_route_table" "tf_route_table" "${ROUTE_TABLE_ID}"

# Importa as associações entre a route table e as subnets
import_resource "aws_route_table_association" "tf_rt_assoc_1" "${PUBLIC_SUBNET_ID_0}/${ROUTE_TABLE_ID}"
import_resource "aws_route_table_association" "tf_rt_assoc_2" "${PUBLIC_SUBNET_ID_1}/${ROUTE_TABLE_ID}"

# Importa o DHCP options
import_resource "aws_vpc_dhcp_options" "tf_dhcp_options" "${DHCP_OPTIONS_ID}"

# Importa o DHCP options associations
import_resource "aws_vpc_dhcp_options_association" "tf_dhcp_options_association" "${VPC_ID}"

# Importa o internet gateway
import_resource "aws_internet_gateway" "tf_internet_gateway" "${INTERNET_GATEWAY_ID}"
