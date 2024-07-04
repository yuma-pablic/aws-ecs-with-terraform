resource "aws_s3_bucket" "api" {
  bucket = "${var.env}-${var.service}-${var.aws_caller_identity}"
}
