#!/bin/bash

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
terraform import aws_eks_cluster.tf_eks_cluster "${EKS_CLUSTER_NAME}" | true

# Importa o node group
terraform import aws_eks_node_group.tf_eks_node_group "${EKS_CLUSTER_NAME}:${EKS_NODE_GROUP_NAME}" | true

# Importa o security group
terraform import aws_security_group.tf_eks_security_group "${SECURITY_GROUP_ID}" | true

# Importa a role do cluster
terraform import aws_iam_role.tf_eks_cluster_role "$CLUSTER_ROLE_NAME" | true

# Importa os policy attachment da role do cluster
terraform import aws_iam_role_policy_attachment.tf_cluster_policy_eks \
"lanchonete-eks-cluster-role/arn:aws:iam::aws:policy/${CLUSTER_POLICY_NAME_1}" | true

terraform import aws_iam_role_policy_attachment.tf_cluster_policy_rds \
"lanchonete-eks-cluster-role/arn:aws:iam::aws:policy/${CLUSTER_POLICY_NAME_2}" | true

terraform import aws_iam_role_policy_attachment.tf_cluster_policy_cloud_watch \
"lanchonete-eks-cluster-role/arn:aws:iam::aws:policy/${CLUSTER_POLICY_NAME_3}" | true

terraform import aws_iam_role_policy_attachment.tf_cluster_policy_ec2 \
"lanchonete-eks-cluster-role/arn:aws:iam::aws:policy/${CLUSTER_POLICY_NAME_4}" | true

# Importa a role do node group
terraform import aws_iam_role.tf_eks_node_group_role "$NG_ROLE_NAME" | true

# Importa os policy attachment da role do node group
terraform import aws_iam_role_policy_attachment.tf_ng_policy_eks \
"lanchonete-eks-cluster-role/arn:aws:iam::aws:policy/${NG_POLICY_NAME_1}" | true

terraform import aws_iam_role_policy_attachment.tf_ng_policy_rds \
"lanchonete-eks-cluster-role/arn:aws:iam::aws:policy/${NG_POLICY_NAME_2}" | true

terraform import aws_iam_role_policy_attachment.tf_ng_policy_eks_cni \
"lanchonete-eks-cluster-role/arn:aws:iam::aws:policy/${NG_POLICY_NAME_3}" | true

terraform import aws_iam_role_policy_attachment.tf_ng_policy_ec2 \
"lanchonete-eks-cluster-role/arn:aws:iam::aws:policy/${NG_POLICY_NAME_4}" | true
