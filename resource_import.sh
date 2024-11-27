#!/bin/bash

# Constantes
EKS_CLUSTER_NAME="lanchonete-eks-cluster"
EKS_NODE_GROUP_NAME="lanchonete-eks-node-group"
SECURITY_GROUP_ID="sg-07766e32f9a1be753"

CLUSTER_ROLE_NAME="lanchonete-eks-cluster-role"
CLUSTER_POLICIES=(
    "AmazonEKSClusterPolicy"
    "AmazonRDSFullAccess"
    "CloudWatchFullAccess"
    "AmazonEC2FullAccess"
)

NG_ROLE_NAME="lanchonete-eks-node-group-role"
NG_POLICIES=(
    "AmazonEKSWorkerNodePolicy"
    "AmazonRDSFullAccess"
    "AmazonEKS_CNI_Policy"
    "AmazonEC2ContainerRegistryReadOnly"
)

# Função para importar recursos do Terraform
import_resource() {
    local resource_type=$1
    local resource_name=$2
    local resource_id=$3

    terraform import "${resource_type}.${resource_name}" "${resource_id}" \
    || echo "Erro ao importar ${resource_id}, continuando..."
}

# Importa o cluster EKS
import_resource "aws_eks_cluster" "tf_eks_cluster" "${EKS_CLUSTER_NAME}"

# Importa o node group
import_resource "aws_eks_node_group" "tf_eks_node_group" "${EKS_CLUSTER_NAME}:${EKS_NODE_GROUP_NAME}"

# Importa o security group
import_resource "aws_security_group" "tf_eks_security_group" "${SECURITY_GROUP_ID}"

# Importa a role do cluster
import_resource "aws_iam_role" "tf_eks_cluster_role" "${CLUSTER_ROLE_NAME}"

# Importa os policy attachments da role do cluster
for policy in "${CLUSTER_POLICIES[@]}"; do
    import_resource "aws_iam_role_policy_attachment" "tf_cluster_policy_${policy,,}" \
    "${CLUSTER_ROLE_NAME}/arn:aws:iam::aws:policy/${policy}"
done

# Importa a role do node group
import_resource "aws_iam_role" "tf_eks_node_group_role" "${NG_ROLE_NAME}"

# Importa os policy attachments da role do node group
for policy in "${NG_POLICIES[@]}"; do
    import_resource "aws_iam_role_policy_attachment" "tf_ng_policy_${policy,,}" \
    "${NG_ROLE_NAME}/arn:aws:iam::aws:policy/${policy}"
done
