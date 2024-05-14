data "aws_iam_policy_document" "sbcntr-accessing-ecr-repository-policy-document" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "*"
    ]
    resources = ["*"]
  }
}
data "aws_iam_policy_document" "sbcntr-cloud9-role-policy-document" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "ec2:*"
    ]
    resources = ["*"]
  }
}
