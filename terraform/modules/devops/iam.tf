resource "aws_iam_role" "oidc" {
  name               = "${var.env}-${var.service}-oidc-role"
  assume_role_policy = data.aws_iam_policy_document.oidc_assume_role_policy.json
}

# 任意のポリシーをアタッチする
resource "aws_iam_role_policy_attachment" "s3_readonly_for_oidc" {
  role       = aws_iam_role.oidc.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}
resource "aws_iam_policy" "api" {
  name        = "${var.env}-${var.service}-ecr-push-policy"
  description = "Allow ECR push for OIDC"
  policy      = data.aws_iam_policy_document.ecr_push_policy.json
}
resource "aws_iam_role_policy_attachment" "ecr_push_for_oidc" {
  role       = aws_iam_role.oidc.name
  policy_arn = aws_iam_policy.api.arn
}
