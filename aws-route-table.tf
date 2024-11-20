# Route table
resource "aws_route_table" "tf_route_table" {
  vpc_id = aws_vpc.tf_vpc.id

  tags = {
    Name = "lanchonete-route-table"
  }
}