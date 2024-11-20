# Internet Gateway
resource "aws_internet_gateway" "tf_internet_gateway" {
  vpc_id = aws_vpc.tf_vpc.id

  tags = {
    Name = "lanchonete-internet-gateway"
  }
}