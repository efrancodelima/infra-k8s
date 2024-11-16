# Define o provedor e a região
provider "aws" {
  region = "us-east-1"
}

# Define a VPC
# Para um cluster AWS simples, 1 VPC é suficiente
resource "aws_vpc" "tf_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = { Name = "aws_vpc" }
}

# Define as subnets dentro da VPC
# Para um cluster AWS simples, 2 subnets públicas e 2 privadas é suficiente
# Coloquei somente 1 availability_zone em cada subnete
# para não duplicar recursos e não encarecer os custos (caso haja algum)

# Subnet pública
resource "aws_subnet" "tf_public_subnet" {
  count             = 1
  vpc_id            = aws_vpc.tf_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = { Name = "aws-public-subnet" }
}

# Subnet privada
resource "aws_subnet" "tf_private_subnet" {
  count             = 1
  vpc_id            = aws_vpc.tf_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = false

  tags = { Name = "aws-private-subnet" }
}

# Define o cluster
resource "aws_eks_cluster" "tf_eks_cluster" {
  name     = "aws-eks-cluster"
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.tf_public_subnet[0].id,
      aws_subnet.tf_private_subnet[0].id
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_policy
  ]
}

# Define a role para usada no cluster
resource "aws_iam_role" "eks_cluster" {
  name = "eks-cluster-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "eks_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "dynamodb_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
  role       = aws_iam_role.eks_cluster.name
}

# O Cloud Watch é o coletor de métricas
resource "aws_iam_role_policy_attachment" "cloudwatch_policy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
  role       = aws_iam_role.eks_cluster.name
}

# Cada nó dentro do EKS Cluster é uma instância EC2
resource "aws_iam_role_policy_attachment" "ebs_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  role       = aws_iam_role.eks_cluster.name
}
