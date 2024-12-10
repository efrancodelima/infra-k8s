resource "aws_ecs_service" "tf_ecs_service" {
  name            = "lanchonete-ecs-service"
  cluster         = aws_ecs_cluster.tf_ecs_cluster.id
  task_definition = aws_ecs_task_definition.tf_ecs_task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets = var.subnet_ids
    security_groups = [ aws_security_group.tf_ecs_service_sg.id ]
    assign_public_ip = false
  }
}
