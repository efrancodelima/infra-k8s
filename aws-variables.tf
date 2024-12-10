variable "aws_account_id" {
  description = "AWS account ID"
  type = string
}

variable "aws_region" {
  description = "AWS region"
  type = string
  default = "us-east-1"
}

variable "aws_zone_1" {
  description = "AWS AZ 1"
  type = string
  default = "us-east-1a"
}

variable "aws_zone_2" {
  description = "AWS AZ 2"
  type = string
  default = "us-east-1b"
}

# VPC e subnets
variable "vpc_id" {
  description = "O id da VPC"
  type = string
  default = "vpc-09d12ffbeaeefd374"
}

variable "subnet_ids" {
  description = "A lista com os ids das subnets privadas"
  type = list(string)
  default = [
    "subnet-0421366e9d4a3fe52",   # private 1
    "subnet-05cf58f58b3f06a4c"    # private 2
  ]
}

# Banco de dados
variable "db_url" {
  description = "URL do banco de dados"
  type = string
}

variable "db_username" {
  description = "Nome de usuário do banco de dados"
  type = string
}

variable "db_password" {
  description = "Senha do banco de dados"
  type = string
}
