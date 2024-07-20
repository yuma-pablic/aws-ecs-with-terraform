resource "aws_iam_role" "oidc" {
  name               = "${var.env}-${var.service}-oidc-role"
  assume_role_policy = data.aws_iam_policy_document.oidc_assume_role_policy.json
}

# 任意のポリシーをアタッチする
resource "aws_iam_role_policy_attachment" "s3_readonly_for_oidc" {
  role       = aws_iam_role.oidc.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}
