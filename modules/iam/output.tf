output "ecs_instance_profile_name" {
  description = "Instance profile name for ECS EC2"
  value       = aws_iam_instance_profile.ecs_instance_profile.name
}

output "ecs_task_execution_role_arn" {
  description = "Execution role ARN for ECS tasks"
  value       = aws_iam_role.ecs_task_execution_role.arn
}

output "ecs_task_role_arn" {
  description = "Task role ARN for ECS tasks"
  value       = aws_iam_role.ecs_task_role.arn
}
