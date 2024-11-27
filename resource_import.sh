#!/bin/bash

import_resource() {
  local resource_type=$1
  local resource_name=$2
  local resource_id=$3

  terraform import "$resource_type.$resource_name" "$resource_id" || true
}

# Constantes
EKS_CLUSTER_NAME="lanchonete-eks-cluster"
EKS_NODE_GROUP_NAME="lanchonete-eks-node-group"
SECURITY_GROUP_ID="sg-07766e32f9a1be753"

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
