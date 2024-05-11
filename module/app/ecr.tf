resource "aws_iam_policy" "sbcntr-accessing-ecr-repository-policy" {
  name = "sbcntr-AccessingECRRepositoryPolicy"
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
            "arn:aws:ecr:ap-northeast-1:${data.aws_caller_identity.self.account_id}:repository/sbcntr-frontend"
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
            "arn:aws:ecr:ap-northeast-1:${data.aws_caller_identity.self.account_id}:repository/sbcntr-frontend"
          ]
        }
      ]
    }
  )
}
