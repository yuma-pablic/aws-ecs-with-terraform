resource "aws_cloudwatch_log_group" "ecs_frontend_def" {
  name              = "${var.env}-${var.service}-ecs-frontend-def"
  retention_in_days = 30
}
