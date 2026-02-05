variable "cluster_id" {
  description = "ECS cluster ID"
  type        = string
}

variable "ecr_image" {
  description = "Full ECR image URI with tag"
  type        = string
}

variable "target_group_arn" {
  description = "ALB target group ARN"
  type        = string
}

variable "secret_arn" {
  description = "Secrets Manager secret ARN"
  type        = string
}

variable "ecs_task_execution_role_arn" {
  description = "ECS task execution role ARN"
  type        = string
}

variable "ecs_task_role_arn" {
  description = "ECS task role ARN"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "service_name" {
  description = "ECS service name"
  type        = string
  default     = "ecs-app-service"
}

variable "container_name" {
  description = "Container name"
  type        = string
  default     = "app"
}

variable "container_port" {
  description = "Application container port"
  type        = number
  default     = 80
}

variable "desired_count" {
  description = "Number of running tasks"
  type        = number
  default     = 2
}

variable "alb_listener_arn" {
  description = "ALB listener ARN"
  type        = string
}
