
resource "aws_iam_role" "ecs_task_execution" {
  name               = "api-ecs-task-execution"
  assume_role_policy = data.aws_iam_policy_document.ecs.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
resource "aws_iam_role" "ecs_code_deploy" {
  name               = "${var.env}-${var.service}-ecs-code-deploy-role"
  assume_role_policy = data.aws_iam_policy_document.assume_code_deploy.json
}
resource "aws_iam_role_policy_attachment" "ecs_code_deploy" {
  role       = aws_iam_role.ecs_code_deploy.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"

}
# resource "aws_iam_policy" "log_destionation" {
#   name   = "${var.env}-${var.service}-accessing-log-destionation"
#   policy = data.aws_iam_policy_document.log_dst.json
# }

# resource "aws_iam_policy" "secrets" {
#   name   = "${var.env}-${var.service}-getting-secrets-policy"
#   policy = data.aws_iam_policy_document.secrets.json
# }
# resource "aws_iam_role_policy_attachment" "ecs_backend_extension_role_attachement_secrets" {
#   policy_arn = aws_iam_policy.secrets.arn
#   role       = aws_iam_role.ecs_api_extension.id
# }
