resource "aws_lb_target_group" "tf_lb_tg" {
  name        = "lanchonete-target-group"
  protocol    = "HTTP"
  port        = 8080     # porta da aplicação
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    protocol             = "HTTP"
    port                 = "traffic-port"
    path                 = "/"
    interval             = 30
    timeout              = 5
    healthy_threshold    = 5
    unhealthy_threshold  = 2
    matcher              = "200"
  }

  load_balancing_algorithm_type = "round_robin"
}