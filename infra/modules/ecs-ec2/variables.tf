variable "cluster_name" {
  description = "ECS cluster name for EC2 registration"
  type        = string
}

variable "private_subnets" {
  description = "Private subnet IDs for ECS EC2 instances"
  type        = list(string)
}

variable "ecs_sg_id" {
  description = "Security group ID for ECS EC2 instances"
  type        = string
}

variable "instance_profile_name" {
  description = "IAM instance profile name from IAM module"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "desired_capacity" {
  type    = number
  default = 2
}

variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 3
}
