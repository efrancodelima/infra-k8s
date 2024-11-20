resource "aws_iam_role" "tf_eks_cluster_role" {
  name = "lanchonete-eks-cluster-role"

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
  role       = aws_iam_role.tf_eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "aurora_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
  role       = aws_iam_role.tf_eks_cluster_role.name
}

# O Cloud Watch é o coletor de métricas
resource "aws_iam_role_policy_attachment" "cloudwatch_policy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
  role       = aws_iam_role.tf_eks_cluster_role.name
}

# Cada nó dentro do EKS Cluster é uma instância EC2
resource "aws_iam_role_policy_attachment" "ec2_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  role       = aws_iam_role.tf_eks_cluster_role.name
}