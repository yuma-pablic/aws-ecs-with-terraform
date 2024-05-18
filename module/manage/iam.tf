
resource "aws_iam_policy" "administrater" {
  name   = "sbcntr-administrater"
  policy = data.aws_iam_policy_document.sbcntr-accessing-ecr-repository-policy-document.json
}

resource "aws_iam_role" "cloud9" {
  name               = "${var.env}-${var.service}-cloud9-role"
  description        = "Allow EC2 instances to call AWS service on your behalf ."
  assume_role_policy = data.aws_iam_policy_document.sbcntr-cloud9-role-policy-document.json
}
resource "aws_iam_role_policy_attachment" "cloud9" {
  role       = aws_iam_role.cloud9.name
  policy_arn = aws_iam_policy.administrater.arn
}

resource "aws_iam_role_policy_attachment" "cloud9" {
  role       = aws_iam_role.cloud9.name
  policy_arn = aws_iam_policy.ecr-repository-policy.arn
}
