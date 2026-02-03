resource "aws_ecs_task_definition" "this" {
  family                   = var.service_name
  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"

  execution_role_arn = var.ecs_task_execution_role_arn
  task_role_arn      = var.ecs_task_role_arn

  container_definitions = jsonencode([
    {
      name  = var.container_name
      image = var.ecr_image

      cpu    = 128
      memory = 256

      portMappings = [
        {
          containerPort = var.container_port
        }
      ]

      secrets = [
        {
          name      = "DB_SECRET"
          valueFrom = var.secret_arn
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.service_name}"
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}
