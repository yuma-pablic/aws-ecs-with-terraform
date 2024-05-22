data "aws_iam_policy_document" "ecr" {
  version = "2012-10-17"
  statement {
    sid    = "ListImagesInRepository"
    effect = "Allow"
    actions = [
      "ecr:ListImages"
    ]
    resources = [
      "arn:aws:ecr:ap-northeast-1:${data.aws_caller_identity.self.account_id}:repository/sbcntr-frontend"
    ]
  }
  statement {
    sid    = "GetAuthorizationToken"
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken"
    ]
    resources = ["*"]
  }
  statement {
    sid    = "ManageRepositoryContents"
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage"
    ]
    resources = [
      "arn:aws:ecr:ap-northeast-1:${data.aws_caller_identity.self.account_id}:repository/sbcntr-frontend"
    ]
  }
}
data "aws_iam_policy_document" "assume_ecs_frontend_extension_role" {
  version = "2012-10-17"
  statement {
    sid     = "SbcntrECSFrontendExtensionRoleAssumeRolePolicyID"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy" "ecs_task_execution_role" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


data "aws_iam_policy" "ecs_task_execution_role" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
data "aws_iam_policy_document" "secrets" {
  version = "2012-10-17"
  statement {
    sid       = "GetSecretForECS"
    effect    = "Allow"
    actions   = ["secretsmanager:GetSecretValue"]
    resources = ["*"]
  }
}
