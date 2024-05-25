resource "aws_cloudwatch_log_group" "ecs_web_def" {
  name              = "${var.env}-${var.service}-ecs-web-def"
  retention_in_days = 30
}
