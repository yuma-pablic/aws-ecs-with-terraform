
resource "aws_iam_role" "ecs_task_execution" {
  name               = "${var.env}-${var.service}-api-ecs-task-execution"
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

resource "aws_iam_policy" "secrets" {
  name   = "${var.env}-${var.service}-getting-secrets-policy"
  policy = data.aws_iam_policy_document.secrets.json
}

resource "aws_iam_role_policy_attachment" "secrets" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = aws_iam_policy.secrets.arn
}

resource "aws_iam_policy" "firelens" {
  name   = "${var.env}-${var.service}-firelens-policy"
  policy = data.aws_iam_policy_document.firelens.json
}
resource "aws_iam_role_policy_attachment" "firelens" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = aws_iam_policy.firelens.arn
}

resource "aws_iam_policy" "ssm" {
  name        = "${var.env}-${var.service}-ssm-policy"
  description = "Allow ECS tasks to get SSM parameters"
  policy      = data.aws_iam_policy_document.ssm.json
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = aws_iam_policy.ssm.arn
}
