resource "aws_iam_policy" "log_destionation" {
  name   = "${var.env}-${var.service}-accessing-log-destionation"
  policy = data.aws_iam_policy_document.log_dst.json
}
resource "aws_iam_role_policy_attachment" "task_role" {
  role       = aws_iam_role.ecsTaskRole.id
  policy_arn = aws_iam_policy.log_destionation.arn
}
resource "aws_iam_role" "ecsTaskRole" {
  name               = "${var.env}-${var.service}-ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.assume_ecs_task_role.json
}

resource "aws_iam_role_policy_attachment" "ecs_api_extension" {
  role       = aws_iam_role.ecsTaskRole.id
  policy_arn = data.aws_iam_policy.ecs_task_execution_role.arn
}

resource "aws_iam_role" "ecs_api_extension" {
  name               = "${var.env}-${var.service}-ecs-api-task-execution"
  assume_role_policy = data.aws_iam_policy.ecs_api_extension.json
}
resource "aws_iam_policy" "secrets" {
  name   = "${var.env}-${var.service}-getting-secrets-policy"
  policy = data.aws_iam_policy_document.secrets.json
}
resource "aws_iam_role_policy_attachment" "ecs_backend_extension_role_attachement_secrets" {
  policy_arn = aws_iam_policy.secrets.arn
  role       = aws_iam_role.ecs_api_extension.id
}
resource "aws_iam_policy" "ecr" {
  name   = "${var.env}-${var.service}-accessing-ecr-repository-policy"
  policy = data.aws_iam_policy_document.ecr.json
}

resource "aws_iam_role_policy_attachment" "codebuild_ecr" {
  role       = module.devops.aws_iam_role.codebuild.id
  policy_arn = aws_iam_policy.ecr.arn
}
