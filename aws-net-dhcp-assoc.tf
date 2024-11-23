resource "aws_vpc_dhcp_options_association" "tf_dhcp_options_association" {
  vpc_id          = aws_vpc.tf_vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.tf_dhcp_options.id
}
