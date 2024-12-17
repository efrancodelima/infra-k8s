resource "aws_lb_target_group" "tf_lb_tg" {
  name        = "lanchonete-target-group"
  protocol    = "HTTP"
  port        = 8080
  vpc_id      = data.aws_vpc.tf_vpc.id
  target_type = "ip"

  health_check {
    protocol             = "HTTP"
    port                 = "8080"
    path                 = "/"
    interval             = 30
    timeout              = 5
    healthy_threshold    = 5
    unhealthy_threshold  = 5
    matcher              = "200"
  }

  load_balancing_algorithm_type = "round_robin"

  depends_on = [
    aws_lb.tf_load_balancer
  ]
}