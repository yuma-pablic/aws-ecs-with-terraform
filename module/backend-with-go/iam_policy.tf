data "aws_iam_policy_document" "sbcntr-AccessingLogDestionation" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject"
    ]
    resources = ["arn:aws:s3:::${aws_s3_bucket.sbcntr-account-id.id}", "arn:aws:s3:::${aws_s3_bucket.sbcntr-account-id.id}/*"]
  }
  statement {
    effect    = "Allow"
    actions   = ["kms:Decrypt", "kms:GenerateDataKey"]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents"
    ]
    resources = []
  }
}

data "aws_iam_policy_document" "sbcntr-ecsTaskRole-policy_document" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "sbcntr-getting-secrets-policy_document" {
  version = "2012-10-17"
  statement {
    sid       = "GetSecretForECS"
    effect    = "Allow"
    actions   = ["secretsmanager:GetSecretValue"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "sbcntr-ecsTaskRole-policy_document" {
  version = "2008-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}
