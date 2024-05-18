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

resource "aws_cloudwatch_event_target" "codepipeline_" {
  rule     = aws_cloudwatch_event_rule.sbcntr-cw-ev.name
  arn      = aws_codepipeline.sbcntr-pipeline.arn
  role_arn = aws_iam_role.sbcntr-event-bridge-codepipeline-role.arn
}
