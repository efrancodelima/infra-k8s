resource "aws_route_table_association" "tf_rt_assoc_1" {
  subnet_id      = aws_subnet.tf_public_subnet[0].id
  route_table_id = aws_route_table.tf_route_table.id
}

resource "aws_route_table_association" "tf_rt_assoc_2" {
  subnet_id      = aws_subnet.tf_public_subnet[1].id
  route_table_id = aws_route_table.tf_route_table.id
}
