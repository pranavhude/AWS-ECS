variable "private_subnets" {
  type = list(string)
}

variable "ecs_sg" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "ecr_image" {
  type = string
}

variable "secret_arn" {
  type = string
}

variable "task_execution_role" {
  type = string
}

variable "instance_profile" {
  type = string
}
