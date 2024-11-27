resource "aws_eks_cluster" "tf_eks_cluster" {
  name     = "lanchonete-eks-cluster"
  version  = "1.31"
  
  role_arn = aws_iam_role.tf_eks_cluster_role.arn
  bootstrap_self_managed_addons = false
  
  vpc_config {
    subnet_ids = var.subnet_ids
    security_group_ids = [ aws_security_group.tf_eks_security_group.id ]
    endpoint_public_access = true
    endpoint_private_access = true
    public_access_cidrs = ["0.0.0.0/0"]
  }

  kubernetes_network_config {
    service_ipv4_cidr = "10.100.0.0/16"
  }
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.tf_eks_cluster.endpoint
}

output "eks_cluster_certificate_authority_data" {
  value = aws_eks_cluster.tf_eks_cluster.certificate_authority[0].data
}

output "eks_cluster_platform_version" {
  value = aws_eks_cluster.tf_eks_cluster.platform_version
}
