resource "aws_cloudwatch_log_group" "ecs-sbcntr-backend-def" {
  name              = "/ecs/sbcntr-backend-def"
  retention_in_days = 30
}
resource "aws_cloudwatch_log_group" "ecs-sbcntr-firelens-log-group" {
  name              = "/aws/ecs/sbcntr-firelens-container"
  retention_in_days = 14
}
