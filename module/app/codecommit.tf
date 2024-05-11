resource "aws_codecommit_repository" "sbcntr-backend" {
  repository_name = "sbcntr-backend"
  description     = "Repository for sbcntr backend application"
}

resource "aws_iam_policy" "sbcntr-accessing-codecommit-policy" {
  name = "sbcntr-AccessingCodeCommitPolicy"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "ListImagesInRepository",
          "Effect" : "Allow",
          "Action" : [
            "ecr:ListImages"
          ],
          "Resource" : [
            "arn:aws:ecr:ap-northeast-1:${data.aws_caller_identity.self.account_id}:repository/sbcntr-backend",
            "arn:aws:ecr:ap-northeast-1:${data.aws_caller_identity.self.account_id}:repository/sbcntr-frontend",
            "arn:aws:ecr:ap-northeast-1:${data.aws_caller_identity.self.account_id}:repository/sbcntr-base"
          ]
        },
        {
          "Sid" : "GetAuthorizationToken",
          "Effect" : "Allow",
          "Action" : [
            "ecr:GetAuthorizationToken"
          ],
          "Resource" : "*"
        },
        {
          "Sid" : "ManageRepositoryContents",
          "Effect" : "Allow",
          "Action" : [
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
          ],
          "Resource" : [
            "arn:aws:ecr:ap-northeast-1:${data.aws_caller_identity.self.account_id}:repository/sbcntr-backend",
            "arn:aws:ecr:ap-northeast-1:${data.aws_caller_identity.self.account_id}:repository/sbcntr-frontend",
            "arn:aws:ecr:ap-northeast-1:${data.aws_caller_identity.self.account_id}:repository/sbcntr-base"
          ]
        }
      ]
    }
  )
}