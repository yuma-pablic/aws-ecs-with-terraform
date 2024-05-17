resource "aws_iam_policy" "sbcntr-AccessingLogDestionation" {
  name   = "sbcntr-AccessingLogDestionation"
  policy = data.aws_iam_policy_document.sbcntr-AccessingLogDestionation.json
}
resource "aws_iam_role_policy_attachment" "sbcntr-task-role-attachement" {
  role       = aws_iam_role.sbcntr-ecsTaskRole.id
  policy_arn = aws_iam_policy.sbcntr-AccessingLogDestionation.arn
}
resource "aws_iam_role" "sbcntr-ecsTaskRole" {
  name               = "sbcntr-ecsTaskRole"
  assume_role_policy = data.aws_iam_policy_document.sbcntr-ecsTaskRole-policy_document.json
}

resource "aws_iam_role_policy_attachment" "ecs-backend-extension-role-attachement" {
  role       = aws_iam_role.ecs-backend-extension-role.id
  policy_arn = data.aws_iam_policy.AmazonECSTaskExecutionRolePolicy.arn
}

resource "aws_iam_role" "ecs-backend-extension-role" {
  name               = "ecsBackendTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.sbcntr-ecsTaskRole-policy_document.json
}
resource "aws_iam_policy" "sbcntr-getting-secrets-policy" {
  name   = "sbcntr-GettingSecretsPolicy"
  policy = data.aws_iam_policy_document.sbcntr-getting-secrets-policy_document.json
}
resource "aws_iam_role_policy_attachment" "ecs-backend-extension-role-attachement-secrets" {
  policy_arn = aws_iam_policy.sbcntr-getting-secrets-policy.arn
  role       = aws_iam_role.ecs-backend-extension-role.id
}
resource "aws_iam_policy" "sbcntr-accessing-ecr-repository-policy" {
  name   = "sbcntr-AccessingECRRepositoryPolicy"
  policy = data.aws_iam_policy_document.sbcntr-accessing-ecr-repository-policy.json
}

resource "aws_iam_role_policy_attachment" "sbcntr-codebuild-attachement-ecr" {
  role       = module.devops.aws_iam_role.sbcntr-codebuild-role.id
  policy_arn = aws_iam_policy.sbcntr-accessing-ecr-repository-policy.arn
}
