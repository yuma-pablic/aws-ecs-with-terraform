resource "aws_iam_role" "ecs_frontend_extension" {
  name               = "ecsFrontendTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.ecs-frontend-extension-role-assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "ecs_frontend_extension" {
  policy_arn = data.aws_iam_policy.AmazonECSTaskExecutionRolePolicy.arn
  role       = aws_iam_role.ecs_frontend_extension.id
}

resource "aws_iam_role_policy_attachment" "ecs_frontend_extension" {
  policy_arn = aws_iam_policy.sbcntr_getting_secrets_policy.arn
  role       = aws_iam_role.ecs_frontend_extension.id
}
