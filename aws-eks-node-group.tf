resource "aws_eks_node_group" "tf_eks_node_group" {
  cluster_name    = aws_eks_cluster.tf_eks_cluster.name
  node_group_name = "lanchonete-eks-node-group"

  node_role_arn = aws_iam_role.tf_eks_node_group_role.arn

  subnet_ids = [
    aws_subnet.tf_public_subnet[0].id,
    aws_subnet.tf_public_subnet[1].id,
    aws_subnet.tf_private_subnet[0].id,
    aws_subnet.tf_private_subnet[1].id
  ]

  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 1
  }

  remote_access {
    ec2_ssh_key               = "my-key"
    source_security_group_ids = [aws_security_group.tf_eks_security_group.id]
  }

  instance_types = ["t3.medium"]
  
}
