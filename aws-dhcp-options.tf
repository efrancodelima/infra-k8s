# DHCP options
resource "aws_vpc_dhcp_options" "tf_dhcp_options" {
  domain_name          = "ec2.internal"
  domain_name_servers  = ["AmazonProvidedDNS"]

  tags = {
    Name = "lanchonete-dhcp-options"
  }
}