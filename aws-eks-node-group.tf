resource "aws_eks_node_group" "tf_eks_node_group" {
  cluster_name    = aws_eks_cluster.tf_eks_cluster.name
  node_group_name = "lanchonete_eks_node_group"

  node_role_arn = aws_iam_role.tf_node_group.arn

  subnet_ids = [
    aws_subnet.tf_node_group1.id,
    aws_subnet.tf_node_group2.id,
  ]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  remote_access {
    ec2_ssh_key               = "my-key"
    source_security_group_ids = [aws_security_group.tf_eks_security_group.id]
  }

  instance_types = ["m5.large"]

  tags = {
    Name = "tf_node_group-node-group"
  }
}
