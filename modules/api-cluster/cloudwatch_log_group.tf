resource "aws_cloudwatch_log_group" "ecs_backend_def" {
  name              = "/ecs/${var.env}-${var.service}-api-def"
  retention_in_days = 30
}
resource "aws_cloudwatch_log_group" "ecs_firelens" {
  name              = "/aws/ecs/${var.env}-${var.service}-firelens-def"
  retention_in_days = 14
}
