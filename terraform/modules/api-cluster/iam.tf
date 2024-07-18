
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

resource "aws_iam_policy" "session_manager" {
  name   = "${var.env}-${var.service}-session-manager"
  policy = data.aws_iam_policy_document.session_manager.json
}

resource "aws_iam_role_policy_attachment" "secrets" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = aws_iam_policy.session_manager.arn
}

resource "aws_iam_role" "session_manager_core" {
  name               = "${var.env}-${var.service}-session-manager-core"
  assume_role_policy = data.aws_iam_policy_document.ecs.json
}

resource "aws_iam_role_policy_attachment" "session_manager_core" {
  role       = aws_iam_role.session_manager_core.name
  policy_arn = aws_iam_policy.session_manager.arn
}
