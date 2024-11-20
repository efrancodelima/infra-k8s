# Security Group do cluster EKS
resource "aws_security_group" "tf_eks_security_group" {
  vpc_id = aws_vpc.tf_vpc.id
  name   = "eks-security-group"
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "http"
    cidr_blocks = ["0.0.0.0/0"]
  }
}