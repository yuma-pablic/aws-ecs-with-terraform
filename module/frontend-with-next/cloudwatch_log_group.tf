resource "aws_cloudwatch_log_group" "ecs_frontend_def" {
  name              = "ecs-sbcntr-frontend-def"
  retention_in_days = 30
}
