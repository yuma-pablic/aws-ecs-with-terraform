data "aws_iam_policy_document" "sbcntr-accessing-ecr-repository-policy" {
  version = "2012-10-17"
  statement {
    sid    = "ListImagesInRepository"
    effect = "Allow"
    actions = [
      "ecr:ListImages"
    ]
    resources = [
      "arn:aws:ecr:ap-northeast-1:${data.aws_caller_identity.self.account_id}:repository/sbcntr-backend",
      "arn:aws:ecr:ap-northeast-1:${data.aws_caller_identity.self.account_id}:repository/sbcntr-frontend"
    ]
  }
  statement {
    sid    = "GetAuthorizationToken"
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken"
    ]
    resources = ["*"]
  }
  statement {
    sid    = "ManageRepositoryContents"
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage"
    ]
    resources = [
      "arn:aws:ecr:ap-northeast-1:${data.aws_caller_identity.self.account_id}:repository/sbcntr-backend",
      "arn:aws:ecr:ap-northeast-1:${data.aws_caller_identity.self.account_id}:repository/sbcntr-frontend"
    ]
  }
}
resource "aws_iam_policy" "sbcntr-accessing-ecr-repository-policy" {
  name   = "sbcntr-AccessingECRRepositoryPolicy"
  policy = data.aws_iam_policy_document.sbcntr-accessing-ecr-repository-policy.json
}

resource "aws_iam_role_policy_attachment" "sbcntr-codebuild-attachement-ecr" {
  role       = aws_iam_role.sbcntr-codebuild-role.id
  policy_arn = aws_iam_policy.sbcntr-accessing-ecr-repository-policy.arn
}
