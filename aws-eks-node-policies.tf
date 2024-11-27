resource "aws_iam_role_policy_attachment" "tf_ng_policy_eks" {
  role       = aws_iam_role.tf_eks_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "tf_ng_policy_rds" {
  role       = aws_iam_role.tf_eks_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}

resource "aws_iam_role_policy_attachment" "tf_ng_policy_eks_cni" {
  role       = aws_iam_role.tf_eks_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "tf_ng_policy_ec2" {
  role       = aws_iam_role.tf_eks_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}