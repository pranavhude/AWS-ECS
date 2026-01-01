############################################
# ECS EC2 INSTANCE ROLE
############################################

resource "aws_iam_role" "ecs_instance_role" {
  name = "ecs-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach required ECS policy to EC2
resource "aws_iam_role_policy_attachment" "ecs_instance_policy" {
  role       = aws_iam_role.ecs_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

# FIXED instance profile name (CRITICAL)
resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "ecs-instance-role"
  role = aws_iam_role.ecs_instance_role.name
}

############################################
# ECS TASK EXECUTION ROLE
############################################

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

############################################
# OUTPUTS (USED BY ECS MODULE)
############################################

output "instance_profile" {
  value = aws_iam_instance_profile.ecs_instance_profile.name
}

output "task_execution_role" {
  value = aws_iam_role.ecs_task_execution_role.arn
}
