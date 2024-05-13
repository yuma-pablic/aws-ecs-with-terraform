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
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        RepositoryName : aws_codecommit_repository.sbcntr-backend.repository_name
        BranchName : "main"
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
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildOutput"]

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
      provider        = "CodeDeployToECS"
      version         = 1
      input_artifacts = ["SourceArtifact", "BuildOutput"]
      configuration = {
        AppSpecTemplateArtifact        = "SourceArtifact",
        ApplicationName                = aws_codedeploy_app.app-ecs-sbcntr-ecs-backend-cluster-sbcntr-ecs-backend-service.name
        DeploymentGroupName            = "Dpgsbcntr-ecs-backend-cluster-sbcntr-ecs-backend-service"
        Image1ArtifactName             = "BuildOutput"
        Image1ContainerName            = "IMAGE1_NAME"
        TaskDefinitionTemplateArtifact = "SourceArtifact"
      }
    }
  }
}
