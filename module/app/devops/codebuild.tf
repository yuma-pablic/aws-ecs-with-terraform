
resource "aws_codebuild_project" "sbcntr-codebuild" {
  depends_on = [
    aws_s3_bucket.sbcntr-codepipline-bucket
  ]
  name = "sbcntr-codebuild"
  source {
    type            = "CODECOMMIT"
    location        = aws_codecommit_repository.sbcntr-backend.clone_url_http
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = true
    }
  }
  source_version = "refs/heads/main"
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
  }
  service_role   = aws_iam_role.sbcntr-codebuild-role.arn
  build_timeout  = "5"
  queued_timeout = "8"


  artifacts {
    type = "NO_ARTIFACTS"
  }
  cache {
    type  = "LOCAL"
    modes = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
  }


}
resource "aws_iam_role" "sbcntr-codebuild-role" {
  name = "sbcntr-codebuild-role"
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "codebuild.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
    }
  )
}
resource "aws_iam_role_policy_attachment" "sbcntr-codebuild-attachement-role" {
  role       = aws_iam_role.sbcntr-codebuild-role.id
  policy_arn = aws_iam_policy.sbcntr-accessing-codecommit-policy.arn
}