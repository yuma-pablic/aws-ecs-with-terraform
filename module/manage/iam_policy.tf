data "aws_iam_policy_document" "sbcntr_accessing_ecr" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "*"
    ]
    resources = ["*"]
  }
}
data "aws_iam_policy_document" "sbcntr_cloud9" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "ec2:*"
    ]
    resources = ["*"]
  }
}
