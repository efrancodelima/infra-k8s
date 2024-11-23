resource "aws_eks_cluster" "tf_eks_cluster" {
  name     = "lanchonete-eks-cluster"
  role_arn = aws_iam_role.tf_eks_cluster_role.arn
  bootstrap_self_managed_addons = false

  vpc_config {
    subnet_ids = [
      aws_subnet.tf_public_subnet[0].id,
      aws_subnet.tf_public_subnet[1].id,
      aws_subnet.tf_private_subnet[0].id,
      aws_subnet.tf_private_subnet[1].id
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.tf_cluster_policy_eks
  ]
}
