resource "aws_iam_role" "sbcntr-codebuild-role" {
  name               = "sbcntr-codebuild-role"
  assume_role_policy = data.aws_iam_policy_document.sbcntr-codebuild-role-document.json
}
resource "aws_iam_role_policy_attachment" "sbcntr-codebuild-attachement-role" {
  role       = aws_iam_role.sbcntr-codebuild-role.id
  policy_arn = aws_iam_policy.sbcntr-accessing-codecommit-policy.arn
}

resource "aws_iam_role" "sbcntr-pipeline-role" {
  name               = "sbcntr-pipeline-role"
  assume_role_policy = data.aws_iam_policy_document.sbcntr-pipeline-role-policy-document.json
}
resource "aws_iam_policy" "sbcntr-codebuild-policy" {
  name        = "sbcntr-codebuild-policy"
  description = "Policy used in trust relationship with CodeBuild"
  policy      = data.aws_iam_policy_document.name.json
}

resource "aws_iam_role_policy_attachment" "sbcntr-codebuild-attachement" {
  role       = aws_iam_role.sbcntr-codebuild-role.id
  policy_arn = aws_iam_policy.sbcntr-codebuild-policy.arn
}

resource "aws_iam_policy" "sbcntr-accessing-codecommit-policy" {
  name   = "sbcntr-AccessingCodeCommitPolicy"
  policy = data.aws_iam_policy_document.sbcntr-accessing-codecommit-policy-document.json
}
resource "aws_iam_role" "ecs-codedeploy-role" {
  name               = "ecs-codedeploy-role"
  assume_role_policy = data.aws_iam_policy_document.ecs-codedeploy-role-policy-document.json
}

resource "aws_iam_role_policy_attachment" "AWSCodeDeployRoleForECS" {
  policy_arn = data.aws_iam_policy.AWSCodeDeployRoleForECS.arn
  role       = aws_iam_role.ecs-codedeploy-role.id
}

resource "aws_iam_policy" "sbcntr-pipeline-policy" {
  name   = "sbcntr-pipeline-policy"
  policy = data.aws_iam_policy_document.sbcntr-pipeline-policy-document.json
}
resource "aws_iam_role_policy_attachment" "sbcntr-piple-policy-attachement" {
  role       = aws_iam_role.sbcntr-pipeline-role.id
  policy_arn = aws_iam_policy.sbcntr-pipeline-policy.arn
}

resource "aws_iam_role" "sbcntr-event-bridge-codepipeline-role" {
  name               = "sbcntr-event-bridge-codepipeline-role"
  assume_role_policy = data.aws_iam_policy_document.sbcntr-event-bridge-codepipeline-role-policy_document.json
}
resource "aws_iam_policy" "sbcntr-event-bridge-codepipeline-policy" {
  name   = "sbcntr-event-bridge-codepipeline-policy"
  policy = data.aws_iam_policy_document.sbcntr-event-bridge-codepipeline-policy-document.json
}

resource "aws_iam_role_policy_attachment" "sbcntr-event-bridge-codepipeline-attachement" {
  role       = aws_iam_role.sbcntr-event-bridge-codepipeline-role.id
  policy_arn = aws_iam_policy.sbcntr-pipeline-policy.arn
}
