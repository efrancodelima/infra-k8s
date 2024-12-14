resource "aws_ecs_task_definition" "tf_ecs_task_definition" {
  family                   = "lanchonete-java-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  task_role_arn            = aws_iam_role.tf_ecs_task_role.arn
  execution_role_arn       = aws_iam_role.tf_ecs_task_exec_role.arn

  memory            = 1024   # 1 GB
  cpu               = 512    # 0,5 vCPU

  container_definitions = jsonencode([{
    name            = "lanchonete-app-container"
    image           = "${var.aws_account_id}.dkr.ecr.us-east-1.amazonaws.com/app-lanchonete:latest"
    essential       = true
    memory          = 1024   # 1 GB
    cpu             = 512    # 0,5 vCPU
    
    portMappings = [{
      containerPort = 8080
      hostPort      = 8080
      protocol      = "tcp"
    }]
    
    environment = [
      { 
        name = "SPRING_PROFILES_ACTIVE"
        value = "dev"
      },
      {
        name  = "DATASOURCE_URL"
        value = var.db_url
      },
      {
        name  = "DATASOURCE_USERNAME"
        value = var.db_username
      },
      {
        name  = "DATASOURCE_PASSWORD"
        value = var.db_password
      }
    ]

    logConfiguration = {
      logDriver = "awslogs"
      options   = {
        "awslogs-group"         = "/ecs/lanchonete-app"
        "awslogs-region"        = "us-east-1"
        "awslogs-stream-prefix" = "ecs"
      }
    }
  }])
}
