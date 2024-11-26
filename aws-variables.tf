variable "aws_region" {
  description = "AWS region"
  type = string
}

variable "aws_zone_1" {
  description = "AWS AZ 1"
  type = string
}

variable "aws_zone_2" {
  description = "AWS AZ 2"
  type = string
}

variable "vpc_id" {
  description = "O id da VPC"
  type = string
  default = "vpc-0011200375d4dffa2"
}

variable "subnet_ids" {
  description = "A lista com os ids das subnets públicas e privadas"
  type = list(string)
  default = [
    "subnet-074acabffa0581567",   # private 1
    "subnet-0bba13eebef880c40",   # private 2
    "subnet-06cf9016ff145c687",   # public 1
    "subnet-02e71053afdf13d52"    # public 2
  ]
}
