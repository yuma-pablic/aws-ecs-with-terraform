resource "aws_cloudwatch_log_group" "ecs-sbcntr-frontend-def" {
  name              = "ecs-sbcntr-frontend-def"
  retention_in_days = 30
}
