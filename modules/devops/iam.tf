resource "aws_iam_role" "pipeline" {
  name               = "${var.env}-${var.service}-pipeline-role"
  assume_role_policy = data.aws_iam_policy_document.pipeline.json
}
resource "aws_iam_policy" "pipeline" {
  name   = "${var.env}-${var.service}-pipeline-policy"
  policy = data.aws_iam_policy_document.assume_pipeline.json
}
resource "aws_iam_role_policy_attachment" "pipleline" {
  role       = aws_iam_role.pipeline.id
  policy_arn = aws_iam_policy.pipeline.arn
}
resource "aws_iam_role" "event_bridge_codepipeline" {
  name               = "${var.env}-${var.service}-event-bridge-codepipeline-role"
  assume_role_policy = data.aws_iam_policy_document.event_bridge_codepipeline.json
}

resource "aws_iam_policy" "event_bridge_codepipeline" {
  name   = "${var.env}-${var.service}-event-bridge-codepipeline-policy"
  policy = data.aws_iam_policy_document.asssume_event_bridge_codepipeline.json
}

resource "aws_iam_role_policy_attachment" "event_bridge_codepipeline" {
  role       = aws_iam_role.event_bridge_codepipeline.id
  policy_arn = aws_iam_policy.pipeline.arn
}
resource "aws_iam_policy" "codecommit" {
  name   = "${var.env}-${var.service}-codecommit-policy"
  policy = data.aws_iam_policy_document.codecommit.json
}
resource "aws_iam_role" "codebuild" {
  name               = "${var.env}-${var.service}-codebuild-role"
  assume_role_policy = data.aws_iam_policy_document.codebuild.json
}
resource "aws_iam_role_policy_attachment" "codebuild" {
  role       = aws_iam_role.codebuild.id
  policy_arn = aws_iam_policy.codecommit.arn
}
resource "aws_iam_policy" "codebuild" {
  name        = "${var.env}-${var.service}-codebuild-policy"
  description = "Policy used in trust relationship with CodeBuild"
  policy      = data.aws_iam_policy_document.codebuild.json
}
resource "aws_iam_role" "ecs_codedeploy" {
  name               = "${var.env}-${var.service}-ecs-codedeploy-role"
  assume_role_policy = data.aws_iam_policy_document.asssume_event_bridge_codepipeline.json
}

resource "aws_iam_role_policy_attachment" "ecs_codedeploy" {
  policy_arn = data.aws_iam_policy.AWSCodeDeployRoleForECS.arn
  role       = aws_iam_role.ecs_codedeploy.id
}
