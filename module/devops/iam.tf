
data "aws_iam_policy_document" "sbcntr-codebuild-role-document" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}
resource "aws_iam_role" "sbcntr-codebuild-role" {
  name               = "sbcntr-codebuild-role"
  assume_role_policy = data.aws_iam_policy_document.sbcntr-codebuild-role-document.json
}
resource "aws_iam_role_policy_attachment" "sbcntr-codebuild-attachement-role" {
  role       = aws_iam_role.sbcntr-codebuild-role.id
  policy_arn = aws_iam_policy.sbcntr-accessing-codecommit-policy.arn
}

data "aws_iam_policy_document" "name" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:ap-northeast-1:${data.aws_caller_identity.self.account_id}:log-group:/aws/codebuild/sbcntr-codebuild",
      "arn:aws:logs:ap-northeast-1:${data.aws_caller_identity.self.account_id}:log-group:/aws/codebuild/sbcntr-codebuild:*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketAcl",
      "s3:GetBucketLocation"
    ]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.sbcntr-codepipline-bucket.id}*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "codecommit:GitPull"
    ]
    resources = [
      "arn:aws:codecommit:ap-northeast-1:${data.aws_caller_identity.self.account_id}:sbcntr-backend"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "codebuild:CreateReportGroup",
      "codebuild:CreateReport",
      "codebuild:UpdateReport",
      "codebuild:BatchPutTestCases",
      "codebuild:BatchPutCodeCoverages"
    ]
    resources = [
      "arn:aws:codebuild:ap-northeast-1:${data.aws_caller_identity.self.account_id}:report-group/sbcntr-codebuild-*"
    ]
  }
}
resource "aws_iam_policy" "sbcntr-codebuild-policy" {
  name        = "sbcntr-codebuild-policy"
  description = "Policy used in trust relationship with CodeBuild"
  policy      = data.aws_iam_policy_document.name.json
}
data "aws_iam_policy_document" "sbcntr-pipeline-role-policy-document" {
  version = "2012-10-17"
  statement {
    effect  = "Allow"
    actions = "sts:AssumeRole"
    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}
resource "aws_iam_role" "sbcntr-pipeline-role" {
  name               = "sbcntr-pipeline-role"
  assume_role_policy = data.aws_iam_policy_document.sbcntr-pipeline-role-policy-document.json
}
resource "aws_iam_role_policy_attachment" "sbcntr-codebuild-attachement" {
  role       = aws_iam_role.sbcntr-codebuild-role.id
  policy_arn = aws_iam_policy.sbcntr-codebuild-policy.arn
}

data "aws_iam_policy_document" "sbcntr-accessing-codecommit-policy-document" {
  version = "2012-10-17"
  statement {
    sid    = "ListImagesInRepository"
    effect = "Allow"
    actions = [
      "ecr:ListImages"
    ]
    resources = [
      "arn:aws:ecr:ap-northeast-1:${data.aws_caller_identity.self.account_id}:repository/sbcntr-backend",
      "arn:aws:ecr:ap-northeast-1:${data.aws_caller_identity.self.account_id}:repository/sbcntr-frontend",
      "arn:aws:ecr:ap-northeast-1:${data.aws_caller_identity.self.account_id}:repository/sbcntr-base"
    ]
  }
  statement {
    sid    = "GetAuthorizationToken"
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken"
    ]
    resources = [
      "*"
    ]
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
      "arn:aws:ecr:ap-northeast-1:${data.aws_caller_identity.self.account_id}:repository/sbcntr-frontend",
      "arn:aws:ecr:ap-northeast-1:${data.aws_caller_identity.self.account_id}:repository/sbcntr-base"
    ]
  }
}

resource "aws_iam_policy" "sbcntr-accessing-codecommit-policy" {
  name   = "sbcntr-AccessingCodeCommitPolicy"
  policy = data.aws_iam_policy_document.sbcntr-accessing-codecommit-policy-document.json
}
data "aws_iam_policy_document" "ecs-codedeploy-role-policy-document" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }
  }
}
resource "aws_iam_role" "ecs-codedeploy-role" {
  name               = "ecs-codedeploy-role"
  assume_role_policy = data.aws_iam_policy_document.ecs-codedeploy-role-policy-document.json
}


resource "aws_iam_role_policy_attachment" "AWSCodeDeployRoleForECS" {
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
  role       = aws_iam_role.ecs-codedeploy-role.id
}
data "aws_iam_policy_document" "sbcntr-pipeline-policy-document" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "codecommit:GetBranch",
      "codecommit:GetCommit",
      "codecommit:UploadArchive",
      "codecommit:GetUploadArchiveStatus",
      "codecommit:CancelUploadArchive",
      "codecommit:ListRepositories",
      "codecommit:ListBranches",
      "codecommit:GetRepository",
      "codecommit:GitPull",
      "codecommit:GitPush"
    ]
    resources = [
      "arn:aws:codecommit:ap-northeast-1:${data.aws_caller_identity.self.account_id}:sbcntr-backend"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
      "codebuild:BatchGetProjects",
      "codebuild:BatchGetReportGroups",
      "codebuild:BatchGetReports",
      "codebuild:CreateReport",
      "codebuild:UpdateReport",
      "codebuild:BatchPutTestCases",
      "codebuild:BatchPutCodeCoverages"
    ]
    resources = [
      "arn:aws:codebuild:ap-northeast-1:${data.aws_caller_identity.self.account_id}:project/sbcntr-codebuild"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "codepipeline:StartPipelineExecution",
      "codepipeline:GetPipeline",
      "codepipeline:GetPipelineExecution",
      "codepipeline:GetPipelineState",
      "codepipeline:GetPipelineExecution"
    ]
    resources = [
      "arn:aws:codepipeline:ap-northeast-1:${data.aws_caller_identity.self.account_id}:sbcntr-pipeline"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "cloudformation:CreateChangeSet",
      "cloudformation:DescribeChangeSet",
      "cloudformation:ExecuteChangeSet",
      "cloudformation:DeleteChangeSet",
      "cloudformation:DescribeStacks",
      "cloudformation:CreateStack",
      "cloudformation:DeleteStack",
      "cloudformation:UpdateStack",
      "cloudformation:SetStackPolicy",
      "cloudformation:ValidateTemplate"
    ]
    resources = [
      "*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "iam:PassRole"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "sbcntr-pipeline-policy" {
  name = "sbcntr-pipeline-policy"
  policy = jsonencode(
    {
      "Statement" : [
        {
          "Action" : [
            "iam:PassRole"
          ],
          "Resource" : "*",
          "Effect" : "Allow",
          "Condition" : {
            "StringEqualsIfExists" : {
              "iam:PassedToService" : [
                "cloudformation.amazonaws.com",
                "elasticbeanstalk.amazonaws.com",
                "ec2.amazonaws.com",
                "ecs-tasks.amazonaws.com"
              ]
            }
          }
        },
        {
          "Action" : [
            "codecommit:CancelUploadArchive",
            "codecommit:GetBranch",
            "codecommit:GetCommit",
            "codecommit:GetRepository",
            "codecommit:GetUploadArchiveStatus",
            "codecommit:UploadArchive"
          ],
          "Resource" : "*",
          "Effect" : "Allow"
        },
        {
          "Action" : [
            "codedeploy:CreateDeployment",
            "codedeploy:GetApplication",
            "codedeploy:GetApplicationRevision",
            "codedeploy:GetDeployment",
            "codedeploy:GetDeploymentConfig",
            "codedeploy:RegisterApplicationRevision"
          ],
          "Resource" : "*",
          "Effect" : "Allow"
        },
        {
          "Action" : [
            "codestar-connections:UseConnection"
          ],
          "Resource" : "*",
          "Effect" : "Allow"
        },
        {
          "Action" : [
            "elasticbeanstalk:*",
            "ec2:*",
            "elasticloadbalancing:*",
            "autoscaling:*",
            "cloudwatch:*",
            "s3:*",
            "sns:*",
            "cloudformation:*",
            "rds:*",
            "sqs:*",
            "ecs:*"
          ],
          "Resource" : "*",
          "Effect" : "Allow"
        },
        {
          "Action" : [
            "lambda:InvokeFunction",
            "lambda:ListFunctions"
          ],
          "Resource" : "*",
          "Effect" : "Allow"
        },
        {
          "Action" : [
            "opsworks:CreateDeployment",
            "opsworks:DescribeApps",
            "opsworks:DescribeCommands",
            "opsworks:DescribeDeployments",
            "opsworks:DescribeInstances",
            "opsworks:DescribeStacks",
            "opsworks:UpdateApp",
            "opsworks:UpdateStack"
          ],
          "Resource" : "*",
          "Effect" : "Allow"
        },
        {
          "Action" : [
            "cloudformation:CreateStack",
            "cloudformation:DeleteStack",
            "cloudformation:DescribeStacks",
            "cloudformation:UpdateStack",
            "cloudformation:CreateChangeSet",
            "cloudformation:DeleteChangeSet",
            "cloudformation:DescribeChangeSet",
            "cloudformation:ExecuteChangeSet",
            "cloudformation:SetStackPolicy",
            "cloudformation:ValidateTemplate"
          ],
          "Resource" : "*",
          "Effect" : "Allow"
        },
        {
          "Action" : [
            "codebuild:BatchGetBuilds",
            "codebuild:StartBuild",
            "codebuild:BatchGetBuildBatches",
            "codebuild:StartBuildBatch"
          ],
          "Resource" : "*",
          "Effect" : "Allow"
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "devicefarm:ListProjects",
            "devicefarm:ListDevicePools",
            "devicefarm:GetRun",
            "devicefarm:GetUpload",
            "devicefarm:CreateUpload",
            "devicefarm:ScheduleRun"
          ],
          "Resource" : "*"
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "servicecatalog:ListProvisioningArtifacts",
            "servicecatalog:CreateProvisioningArtifact",
            "servicecatalog:DescribeProvisioningArtifact",
            "servicecatalog:DeleteProvisioningArtifact",
            "servicecatalog:UpdateProduct"
          ],
          "Resource" : "*"
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "cloudformation:ValidateTemplate"
          ],
          "Resource" : "*"
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "ecr:DescribeImages"
          ],
          "Resource" : "*"
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "states:DescribeExecution",
            "states:DescribeStateMachine",
            "states:StartExecution"
          ],
          "Resource" : "*"
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "appconfig:StartDeployment",
            "appconfig:StopDeployment",
            "appconfig:GetDeployment"
          ],
          "Resource" : "*"
        }
      ],
      "Version" : "2012-10-17"
    }
  )
}
resource "aws_iam_role_policy_attachment" "sbcntr-piple-policy-attachement" {
  role       = aws_iam_role.sbcntr-pipeline-role.id
  policy_arn = aws_iam_policy.sbcntr-pipeline-policy.arn
}

data "aws_iam_policy_document" "sbcntr-event-bridge-codepipeline-role-policy_document" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }

}
resource "aws_iam_role" "sbcntr-event-bridge-codepipeline-role" {
  name               = "sbcntr-event-bridge-codepipeline-role"
  assume_role_policy = data.aws_iam_policy_document.sbcntr-event-bridge-codepipeline-role-policy_document.json
}

data "aws_iam_policy_document" "sbcntr-event-bridge-codepipeline-policy-document" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "codepipeline:StartPipelineExecution"
    ]
    resources = [
      "arn:aws:codepipeline:ap-northeast-1:${data.aws_caller_identity.self.account_id}:sbcntr-pipeline"
    ]
  }
}
resource "aws_iam_policy" "sbcntr-event-bridge-codepipeline-policy" {
  name   = "sbcntr-event-bridge-codepipeline-policy"
  policy = data.aws_iam_policy_document.sbcntr-event-bridge-codepipeline-policy-document.json
}

resource "aws_iam_role_policy_attachment" "sbcntr-event-bridge-codepipeline-attachement" {
  role       = aws_iam_role.sbcntr-event-bridge-codepipeline-role.id
  policy_arn = aws_iam_policy.sbcntr-pipeline-policy.arn
}
