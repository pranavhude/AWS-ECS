resource "aws_cloudwatch_log_group" "ecs" {
  name = "/ecs/production"
}

resource "aws_cloudwatch_metric_alarm" "ecs_cpu" {
  alarm_name          = "ecs-high-cpu"
  namespace           = "AWS/ECS"
  metric_name         = "CPUUtilization"
  statistic           = "Average"
  period              = 300
  evaluation_periods  = 1
  threshold           = 70
  comparison_operator = "GreaterThanThreshold"
}
