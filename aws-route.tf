# Route
resource "aws_route" "tf_route" {
  route_table_id         = aws_route_table.tf_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.tf_internet_gateway.id
}