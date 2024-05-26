resource "aws_iam_policy" "log_destionation" {
  name   = "${var.env}-${var.service}-accessing-log-destionation"
  policy = data.aws_iam_policy_document.sbcntr-AccessingLogDestionation.json
}
resource "aws_iam_role_policy_attachment" "task_role" {
  role       = aws_iam_role.ecsTaskRole.id
  policy_arn = aws_iam_policy.log_destionation.arn
}
resource "aws_iam_role" "ecsTaskRole" {
  name               = "${var.env}-${var.service}-ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.sbcntr-ecsTaskRole-policy_document.json
}

resource "aws_iam_role_policy_attachment" "ecs_api_extension" {
  role       = aws_iam_role.ecs_backend_extension_role.id
  policy_arn = data.aws_iam_policy.AmazonECSTaskExecutionRolePolicy.arn
}

resource "aws_iam_role" "ecs_api_extension" {
  name               = "${var.env}-${var.service}-ecs-api-task-execution"
  assume_role_policy = data.aws_iam_policy_document.sbcntr-ecsTaskRole-policy_document.json
}
resource "aws_iam_policy" "secrets" {
  name   = "${var.env}-${var.service}-getting-secrets-policy"
  policy = data.aws_iam_policy_document.sbcntr-getting-secrets-policy_document.json
}
resource "aws_iam_role_policy_attachment" "ecs_backend_extension_role_attachement_secrets" {
  policy_arn = aws_iam_policy.secrets.arn
  role       = aws_iam_role.ecs_api_extension.id
}
resource "aws_iam_policy" "ecr" {
  name   = "${var.env}-${var.service}-accessing-ecr-repository-policy"
  policy = data.aws_iam_policy_document.sbcntr-accessing-ecr-repository-policy.json
}

resource "aws_iam_role_policy_attachment" "codebuild_ecr" {
  role       = module.devops.aws_iam_role.sbcntr-codebuild-role.id
  policy_arn = aws_iam_policy.ecr.arn
}
