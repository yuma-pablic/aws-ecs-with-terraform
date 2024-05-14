
resource "aws_iam_role_policy_attachment" "sbcntr-task-role-attachement" {
  role       = aws_iam_role.sbcntr-ecsTaskRole.id
  policy_arn = aws_iam_policy.sbcntr-AccessingLogDestionation.arn
}
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
resource "aws_iam_policy" "sbcntr-AccessingLogDestionation" {
  name   = "sbcntr-AccessingLogDestionation"
  policy = data.aws_iam_policy_document.sbcntr-AccessingLogDestionation.json
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
resource "aws_iam_role" "sbcntr-ecsTaskRole" {
  name               = "sbcntr-ecsTaskRole"
  assume_role_policy = data.aws_iam_policy_document.sbcntr-ecsTaskRole-policy_document.json
}

resource "aws_iam_role_policy_attachment" "ecs-backend-extension-role-attachement" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecs-backend-extension-role.id
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
resource "aws_iam_policy" "sbcntr-getting-secrets-policy" {
  name   = "sbcntr-GettingSecretsPolicy"
  policy = data.aws_iam_policy_document.sbcntr-getting-secrets-policy_document.json
}
resource "aws_iam_role_policy_attachment" "ecs-backend-extension-role-attachement-secrets" {
  policy_arn = aws_iam_policy.sbcntr-getting-secrets-policy.arn
  role       = aws_iam_role.ecs-backend-extension-role.id
}
