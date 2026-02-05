output "alb_dns" {
  value = aws_lb.this.dns_name
}

output "target_group_arn" {
  value = aws_lb_target_group.this.arn
}

output "listener_arn" {
  description = "ALB listener ARN"
  value       = aws_lb_listener.this.arn
}
