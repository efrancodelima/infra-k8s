data "aws_vpc" "tf_vpc" {
  filter {
    name   = "tag:Name"
    values = ["lanchonete-vpc"]
  }
}

data "aws_subnet" "tf_sub_priv_1" {
  filter {
    name = "tag:Name"
    values = ["lanchonete-subnet-private1-us-east-1a"]
  }
}

data "aws_subnet" "tf_sub_priv_2" {
  filter {
    name = "tag:Name"
    values = ["lanchonete-subnet-private2-us-east-1b"]
  }
}
