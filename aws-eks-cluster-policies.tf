resource "aws_iam_role_policy_attachment" "tf_cluster_policy_eks" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.tf_eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "tf_cluster_policy_rds" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
  role       = aws_iam_role.tf_eks_cluster_role.name
}

# O Cloud Watch é o coletor de métricas
resource "aws_iam_role_policy_attachment" "tf_cluster_policy_cloud_watch" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
  role       = aws_iam_role.tf_eks_cluster_role.name
}

# Cada nó dentro do EKS Cluster é uma instância EC2
resource "aws_iam_role_policy_attachment" "tf_cluster_policy_ec2" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  role       = aws_iam_role.tf_eks_cluster_role.name
}
