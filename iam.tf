data "aws_iam_policy_document" "ecs-codedeploy-role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs-codedeploy-role" {
  assume_role_policy = jsonencode({

  })
  name = "ecsCodeDeployRole"
}
