data "aws_caller_identity" "self" {}
data "aws_iam_policy_document" "ecs" {
  statement {
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
data "aws_iam_policy_document" "assume_code_deploy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }
  }
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

data "aws_iam_policy_document" "session_manager" {
  version = "2012-10-17"

  statement {
    effect    = "Allow"
    actions   = ["iam:PassRole"]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values   = ["ssm.amazonaws.com"]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "ssm:DeleteActivation",
      "ssm:RemoveTagsFromResource",
      "ssm:AddTagsToResource",
      "ssm:CreateActivation"
    ]
    resources = ["*"]
  }
}



data "aws_iam_policy_document" "session_manager_core" {
  policy_id = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
