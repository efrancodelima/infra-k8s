resource "aws_iam_role_policy_attachment" "tf_cluster_policy_1" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.tf_eks_cluster_role.name
}

# O Cloud Watch é o coletor de métricas
resource "aws_iam_role_policy_attachment" "tf_cluster_policy_2" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
  role       = aws_iam_role.tf_eks_cluster_role.name
}

# Cada nó dentro do EKS Cluster é uma instância EC2
resource "aws_iam_role_policy_attachment" "tf_cluster_policy_3" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  role       = aws_iam_role.tf_eks_cluster_role.name
}
