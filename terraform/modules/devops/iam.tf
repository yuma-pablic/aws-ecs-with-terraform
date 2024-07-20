data "aws_region" "current" {}
resource "aws_iam_role" "oidc" {
  name               = "${var.env}-${var.service}-oidc-role"
  assume_role_policy = data.aws_iam_policy_document.oidc_assume_role_policy.json
}

# 任意のポリシーをアタッチする
resource "aws_iam_role_policy_attachment" "s3_readonly_for_oidc" {
  role       = aws_iam_role.oidc.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

# GitHubActionsからECRにPushするための権限を付与
resource "aws_iam_policy" "ecr_push_policy" {
  name = "ci-cd-ecr-push"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ],
        "Resource" : ["arn:aws:ecr:${data.aws_region.current.id}:${data.aws_caller_identity.self.account_id}:repository/${aws_ecr_repository.ECRRepository.name}"]
      }
    ]
  })
}
