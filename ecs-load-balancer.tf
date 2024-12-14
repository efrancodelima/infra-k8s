resource "aws_lb" "tf_load_balancer" {
  name               = "lanchonete-load-balancer"
  internal           = true
  load_balancer_type = "application"
  
  security_groups    = [aws_security_group.tf_lb_sg.id]
  subnets            = var.private_subnet_ids
  enable_deletion_protection = false
}

output "load_balancer_arn" {
  value = aws_lb.tf_load_balancer.arn
}

output "load_balancer_dns_name" {
  value = aws_lb.tf_load_balancer.dns_name
}
