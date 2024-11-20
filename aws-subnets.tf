# Subnets públicas
resource "aws_subnet" "tf_public_subnet" {
  count             = 2
  vpc_id            = aws_vpc.tf_vpc.id
  cidr_block        = element(["10.0.1.0/24", "10.0.2.0/24"], count.index)
  availability_zone = element([var.aws_zone_1, var.aws_zone_2], count.index)
  map_public_ip_on_launch = true

  tags = { Name = "lanchonete-public-subnet-${count.index}" }
}

# Subnets privadas
resource "aws_subnet" "tf_private_subnet" {
  count             = 2
  vpc_id            = aws_vpc.tf_vpc.id
  cidr_block        = element(["10.0.3.0/24", "10.0.4.0/24"], count.index)
  availability_zone = element([var.aws_zone_1, var.aws_zone_2], count.index)
  map_public_ip_on_launch = false

  tags = { Name = "lanchonete-private-subnet-${count.index}" }
}
