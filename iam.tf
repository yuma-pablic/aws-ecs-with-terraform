data "aws_caller_identity" "self" {}

resource "aws_iam_policy" "sbcntr-AccessingECRRepositoryPolicy" {
  name        = "sbcntr-AccessingECRRepositoryPolicy"
  description = "Policy to access ECR repo from Cloud9 instance"
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

resource "aws_iam_role" "sbcntr-cloud9-role" {
  name               = "sbcntr-cloud9-role"
  description        = ""
  assume_role_policy = aws_iam_policy.sbcntr-AccessingECRRepositoryPolicy.arn
}

resource "aws_iam_role_policy_attachment" "AAAA" {
  role = aws_iam_role.sbcntr-cloud9-role.name
  policy_arn = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : "*",
          "Resource" : "*"
        }
      ]
    }
  )
}
# Blue Green Deploymentを実行する際の権限
resource "aws_iam_role" "ecs-codedeploy-role" {
  name        = "ecsCodeDeployRole"
  description = "Allows CodeDeploy to read S3 objects, invoke Lambda functions, publish to SNS topics, and update ECS services on your behalf."
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "",
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "codedeploy.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
    }
  )
}
