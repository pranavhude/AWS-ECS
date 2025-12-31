resource "aws_ecs_cluster" "this" {
  name = "ecs-prod-cluster"
}

resource "aws_launch_template" "ecs" {
  image_id      = "ami-0a8e758f5e873d1c1"
  instance_type = "t3.micro"

  user_data = base64encode("echo ECS_CLUSTER=ecs-prod-cluster >> /etc/ecs/ecs.config")

  iam_instance_profile {
    name = var.instance_profile
  }

  vpc_security_group_ids = [var.ecs_sg]
}

resource "aws_autoscaling_group" "ecs" {
  min_size         = 1
  max_size         = 3
  desired_capacity = 2

  vpc_zone_identifier = var.private_subnets

  launch_template {
    id      = aws_launch_template.ecs.id
    version = "$Latest"
  }
}

resource "aws_ecs_task_definition" "this" {
  family                   = "nginx-task"
  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"
  execution_role_arn       = var.task_execution_role

  container_definitions = jsonencode([
    {
      name  = "nginx"
      image = var.ecr_image

      cpu    = 128
      memoryReservation = 256   

      portMappings = [
        {
          containerPort = 80
        }
      ]

      secrets = [
        {
          name      = "DB_SECRET"
          valueFrom = var.secret_arn
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "this" {
  name            = "nginx-service"   # ✅ THIS WAS MISSING
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 2

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "nginx"
    container_port   = 80
  }
}
