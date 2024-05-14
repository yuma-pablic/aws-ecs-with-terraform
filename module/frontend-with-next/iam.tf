resource "aws_iam_role" "ecs-frontend-extension-role" {
  name               = "ecsFrontendTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.ecs-frontend-extension-role-assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "ecs-frontend-extension-role-attachement" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecs-frontend-extension-role.id
}

resource "aws_iam_role_policy_attachment" "ecs-frontend-extension-role-attachement-secrets" {
  policy_arn = aws_iam_policy.sbcntr-getting-secrets-policy.arn
  role       = aws_iam_role.ecs-frontend-extension-role.id
}
