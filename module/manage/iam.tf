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

resource "aws_iam_policy" "sbcntr-administrater" {
  name   = "sbcntr-administrater"
  policy = data.aws_iam_policy_document.sbcntr-accessing-ecr-repository-policy-document.json
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
resource "aws_iam_role" "sbcntr-cloud9-role" {
  name               = "sbcntr-cloud9-role"
  description        = "Allow EC2 instances to call AWS service on your behalf ."
  assume_role_policy = data.aws_iam_policy_document.sbcntr-cloud9-role-policy-document.json
}
resource "aws_iam_role_policy_attachment" "iam-atachement-sbcntr-cloud9-role-admin" {
  role       = aws_iam_role.sbcntr-cloud9-role.name
  policy_arn = aws_iam_policy.sbcntr-administrater.arn
}

resource "aws_iam_role_policy_attachment" "iam-atachment-sbcntr-cloud9-role-ecr" {
  role       = aws_iam_role.sbcntr-cloud9-role.name
  policy_arn = aws_iam_policy.sbcntr-accessing-ecr-repository-policy.arn
}
