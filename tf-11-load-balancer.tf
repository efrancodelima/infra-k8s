resource "aws_lb" "tf_load_balancer" {
  name               = "lanchonete-load-balancer"
  internal           = true
  load_balancer_type = "application"
  
  security_groups    = [aws_security_group.tf_lb_sg.id]
  subnets            = var.private_subnet_ids
  enable_deletion_protection = false

  depends_on = [
    aws_security_group.tf_lb_sg
  ]
}
