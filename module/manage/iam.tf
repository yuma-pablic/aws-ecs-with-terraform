
resource "aws_iam_policy" "sbcntr_administrater" {
  name   = "sbcntr-administrater"
  policy = data.aws_iam_policy_document.sbcntr-accessing-ecr-repository-policy-document.json
}

resource "aws_iam_role" "sbcntr_cloud9" {
  name               = "sbcntr-cloud9-role"
  description        = "Allow EC2 instances to call AWS service on your behalf ."
  assume_role_policy = data.aws_iam_policy_document.sbcntr-cloud9-role-policy-document.json
}
resource "aws_iam_role_policy_attachment" "sbcntr_cloud9" {
  role       = aws_iam_role.sbcntr_cloud9.name
  policy_arn = aws_iam_policy.sbcntr_administrater.arn
}

resource "aws_iam_role_policy_attachment" "sbcntr_cloud9" {
  role       = aws_iam_role.sbcntr_cloud9.name
  policy_arn = aws_iam_policy.sbcntr-accessing-ecr-repository-policy.arn
}
