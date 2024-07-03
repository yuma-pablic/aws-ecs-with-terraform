resource "aws_cloudwatch_event_rule" "codecommit" {
  name = "${var.env}-${var.service}-codecommit-event-rule"

  event_pattern = jsonencode(
    {
      "source" : ["aws.codecommit"],
      "detail-type" : ["CodeCommit Repository State Change"],
      "resources" : ["${aws_codecommit_repository.backend.id}"],
      "detail" : {
        "event" : ["referenceCreated", "referenceUpdated"],
        "referenceType" : ["branch"],
        "referenceName" : ["main"]
      }
    }
  )
}

resource "aws_cloudwatch_event_target" "codepipeline" {
  rule     = aws_cloudwatch_event_rule.codecommit.name
  arn      = aws_codepipeline.api.arn
  role_arn = aws_iam_role.pipeline.arn
}
