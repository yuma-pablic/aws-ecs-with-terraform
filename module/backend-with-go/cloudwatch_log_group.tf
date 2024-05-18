resource "aws_cloudwatch_log_group" "ecs_sbcntr_backend_def" {
  name              = "/ecs/sbcntr-backend-def"
  retention_in_days = 30
}
resource "aws_cloudwatch_log_group" "ecs_sbcntr_firelens" {
  name              = "/aws/ecs/sbcntr-firelens-container"
  retention_in_days = 14
}
