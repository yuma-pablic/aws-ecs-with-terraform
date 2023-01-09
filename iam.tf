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

resource "aws_iam_policy" "sbcntr-administrater" {
  name = "sbcntr-administrater"
  policy = jsonencode(
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

resource "aws_iam_role" "sbcntr-cloud9-role" {
  name        = "sbcntr-cloud9-role"
  description = "Allow EC2 instances to call AWS service on your behalf ."
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}


resource "aws_iam_role_policy_attachment" "iam-atachement-sbcntr-cloud9-role-admin" {
  role       = aws_iam_role.sbcntr-cloud9-role.name
  policy_arn = aws_iam_policy.sbcntr-administrater.arn
}

resource "aws_iam_role_policy_attachment" "iam-atachment-sbcntr-cloud9-role-ecr" {
  role       = aws_iam_role.sbcntr-cloud9-role.name
  policy_arn = aws_iam_policy.sbcntr-accessing-ecr-repository-policy.arn
}
# Blue Green Deploymentを実行する際の権限

resource "aws_iam_policy" "sbcntr-accessing-codedeploy-policy" {
  name = "sbcntr-accessing-codedeploy-policy"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : [
            "ecs:DescribeServices",
            "ecs:CreateTaskSet",
            "ecs:UpdateServicePrimaryTaskSet",
            "ecs:DeleteTaskSet",
            "elasticloadbalancing:DescribeTargetGroups",
            "elasticloadbalancing:DescribeListeners",
            "elasticloadbalancing:ModifyListener",
            "elasticloadbalancing:DescribeRules",
            "elasticloadbalancing:ModifyRule",
            "lambda:InvokeFunction",
            "cloudwatch:DescribeAlarms",
            "sns:Publish",
            "s3:GetObject",
            "s3:GetObjectVersion"
          ],
          "Resource" : "*",
          "Effect" : "Allow"
        },
        {
          "Action" : [
            "iam:PassRole"
          ],
          "Effect" : "Allow",
          "Resource" : "*",
          "Condition" : {
            "StringLike" : {
              "iam:PassedToService" : [
                "ecs-tasks.amazonaws.com"
              ]
            }
          }
        }
      ]
    }
  )
}
resource "aws_iam_role" "ecs-codedeploy-role" {
  name               = "ecs-codedeploy-role"
  assume_role_policy = <<EOT
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
EOT
}

resource "aws_iam_role_policy_attachment" "AWSCodeDeployRoleForECS" {
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
  role       = aws_iam_role.ecs-codedeploy-role.id
}

#cloudwatch logsにデータを送信をするための権限
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs_task_execution_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "ecs-tasks.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }
    ]
  })
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
    "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
  ]
}

resource "aws_iam_role_policy_attachment" "sbcntr-accessing-codedeploy-attachement" {
  role       = aws_iam_role.ecs-codedeploy-role.name
  policy_arn = aws_iam_policy.sbcntr-accessing-codedeploy-policy.arn
}
