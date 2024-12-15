resource "aws_ecs_service" "tf_ecs_service" {
  name            = "lanchonete-ecs-service"
  cluster         = aws_ecs_cluster.tf_ecs_cluster.id
  task_definition = aws_ecs_task_definition.tf_ecs_task_definition.arn

  desired_count   = 2
  launch_type     = "FARGATE"

  deployment_controller {
    type = "ECS"
  }

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  health_check_grace_period_seconds  = 0

  network_configuration {
    subnets = var.private_subnet_ids
    security_groups = [ aws_security_group.tf_ecs_sg.id ]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.tf_lb_tg.arn
    container_name   = "lanchonete-app-container"
    container_port   = 8080
  }

  depends_on = [
    aws_ecs_cluster.tf_ecs_cluster,
    aws_ecs_task_definition.tf_ecs_task_definition,
    aws_security_group.tf_ecs_sg,
    aws_lb_target_group.tf_lb_tg
  ]
}
