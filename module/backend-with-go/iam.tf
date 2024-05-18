resource "aws_iam_policy" "log_destionation" {
  name   = "${var.env}-${var.service}-accessing-log-destionation"
  policy = data.aws_iam_policy_document.sbcntr-AccessingLogDestionation.json
}
resource "aws_iam_role_policy_attachment" "task_role" {
  role       = aws_iam_role.ecsTaskRole.id
  policy_arn = aws_iam_policy.log_destionation.arn
}
resource "aws_iam_role" "ecsTaskRole" {
  name               = "sbcntr-ecsTaskRole"
  assume_role_policy = data.aws_iam_policy_document.sbcntr-ecsTaskRole-policy_document.json
}

resource "aws_iam_role_policy_attachment" "ecs_backend_extension" {
  role       = aws_iam_role.ecs_backend_extension_role.id
  policy_arn = data.aws_iam_policy.AmazonECSTaskExecutionRolePolicy.arn
}

resource "aws_iam_role" "ecs_backend_extension" {
  name               = "${var.env}-${var.service}-ecs-backend-task-execution"
  assume_role_policy = data.aws_iam_policy_document.sbcntr-ecsTaskRole-policy_document.json
}
resource "aws_iam_policy" "secrets" {
  name   = "sbcntr-GettingSecretsPolicy"
  policy = data.aws_iam_policy_document.sbcntr-getting-secrets-policy_document.json
}
resource "aws_iam_role_policy_attachment" "ecs_backend_extension_role_attachement_secrets" {
  policy_arn = aws_iam_policy.secrets.arn
  role       = aws_iam_role.ecs_backend_extension.id
}
resource "aws_iam_policy" "ecr" {
  name   = "sbcntr-AccessingECRRepositoryPolicy"
  policy = data.aws_iam_policy_document.sbcntr-accessing-ecr-repository-policy.json
}

resource "aws_iam_role_policy_attachment" "codebuild_ecr" {
  role       = module.devops.aws_iam_role.sbcntr-codebuild-role.id
  policy_arn = aws_iam_policy.ecr.arn
}
