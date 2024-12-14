resource "aws_lb_listener" "tf_lb_listener" {
  load_balancer_arn = aws_lb.tf_load_balancer.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type = "forward"

    forward {
      target_group {
        arn    = aws_lb_target_group.tf_lb_tg.arn
        weight = 1
      }

      stickiness {
        enabled = false
      }
    }
  }
}
