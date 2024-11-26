resource "aws_eks_node_group" "tf_eks_node_group" {
  cluster_name    = aws_eks_cluster.tf_eks_cluster.name
  node_group_name = "lanchonete-eks-node-group"
  node_role_arn = aws_iam_role.tf_eks_node_group_role.arn
  version         = "1.31"
  
  subnet_ids = var.subnet_ids
  
  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  instance_types = ["t3.medium"]
  
  disk_size  = 20
  ami_type   = "AL2_x86_64"
  capacity_type = "ON_DEMAND"
  
  update_config {
    max_unavailable = 1
  }

  tags = {}
}
