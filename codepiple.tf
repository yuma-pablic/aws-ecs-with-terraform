resource "aws_codepipeline" "sbcntr-pipeline" {
  name     = "sbcntr-pipeline"
  role_arn = aws_iam_role.sbcntr-pipeline-role.arn

  artifact_store {
    location = aws_s3_bucket.sbcntr-codepipline-bucket.bucket
    type     = "S3"
  }
  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        RepositoryName = aws_codecommit_repository.sbcntr-backend.id
        BranchName     = "main"
      }
    }
  }

  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = 1
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]

      configuration = {
        ProjectName = aws_codebuild_project.sbcntr-codebuild.id
      }
    }
  }

  stage {
    name = "Deploy"
    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      version         = 1
      input_artifacts = ["build_output"]
      configuration = {
        ClusterName = aws_ecs_cluster.sbcntr-backend-cluster.id
        ServiceName = aws_ecs_service.sbcntr-ecs-backend-service.name
      }
    }
  }
}

# cloudwatch event rule
resource "aws_cloudwatch_event_rule" "sbcntr-cw-ev" {
  name = "sbcntr-cw-ev"

  event_pattern = jsonencode(
    {
      "source" : ["aws.codecommit"],
      "detail-type" : ["CodeCommit Repository State Change"],
      "resources" : ["${aws_codecommit_repository.sbcntr-backend.id}"],
      "detail" : {
        "event" : ["referenceCreated", "referenceUpdated"],
        "referenceType" : ["branch"],
        "referenceName" : ["main"]
      }
    }
  )
}

resource "aws_cloudwatch_event_target" "codepipeline_sample_app" {
  rule     = aws_cloudwatch_event_rule.sbcntr-cw-ev.name
  arn      = aws_codepipeline.sbcntr-pipeline.arn
  role_arn = aws_iam_role.event_bridge_codepipeline.arn
}
