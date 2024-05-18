resource "aws_iam_role" "codebuild" {
  name               = "sbcntr-codebuild-role"
  assume_role_policy = data.aws_iam_policy_document.sbcntr-codebuild-role-document.json
}
resource "aws_iam_role_policy_attachment" "codebuild" {
  role       = aws_iam_role.codebuild.id
  policy_arn = aws_iam_policy.codecommit.arn
}

resource "aws_iam_role" "pipeline" {
  name               = "sbcntr-pipeline-role"
  assume_role_policy = data.aws_iam_policy_document.sbcntr-pipeline-role-policy-document.json
}
resource "aws_iam_policy" "sbcntr-codebuild-policy" {
  name        = "sbcntr-codebuild-policy"
  description = "Policy used in trust relationship with CodeBuild"
  policy      = data.aws_iam_policy_document.name.json
}

resource "aws_iam_role_policy_attachment" "sbcntr-codebuild-attachement" {
  role       = aws_iam_role.codebuild.id
  policy_arn = aws_iam_policy.sbcntr-codebuild-policy.arn
}

resource "aws_iam_policy" "codecommit" {
  name   = "sbcntr-AccessingCodeCommitPolicy"
  policy = data.aws_iam_policy_document.codecommit.json
}
resource "aws_iam_role" "ecs_codedeploy" {
  name               = "ecs-codedeploy-role"
  assume_role_policy = data.aws_iam_policy_document.ecs-codedeploy-role-policy-document.json
}

resource "aws_iam_role_policy_attachment" "AWSCodeDeployRoleForECS" {
  policy_arn = data.aws_iam_policy.AWSCodeDeployRoleForECS.arn
  role       = aws_iam_role.ecs-codedeploy-role.id
}

resource "aws_iam_policy" "pipeline" {
  name   = "sbcntr-pipeline-policy"
  policy = data.aws_iam_policy_document.sbcntr-pipeline-policy-document.json
}
resource "aws_iam_role_policy_attachment" "pipleline" {
  role       = aws_iam_role.sbcntr-pipeline-role.id
  policy_arn = aws_iam_policy.sbcntr-pipeline-policy.arn
}

resource "aws_iam_role" "event_bridge_codepipeline" {
  name               = "sbcntr-event-bridge-codepipeline-role"
  assume_role_policy = data.aws_iam_policy_document.sbcntr-event-bridge-codepipeline-role-policy_document.json
}
resource "aws_iam_policy" "event_bridge_codepipeline" {
  name   = "sbcntr-event-bridge-codepipeline-policy"
  policy = data.aws_iam_policy_document.sbcntr-event-bridge-codepipeline-policy-document.json
}

resource "aws_iam_role_policy_attachment" "event_bridge_codepipeline" {
  role       = aws_iam_role.sbcntr-event-bridge-codepipeline-role.id
  policy_arn = aws_iam_policy.sbcntr-pipeline-policy.arn
}
