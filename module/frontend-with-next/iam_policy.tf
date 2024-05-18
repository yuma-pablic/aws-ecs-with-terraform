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
