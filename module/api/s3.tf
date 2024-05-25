resource "aws_s3_bucket" "api" {
  bucket = "${var.env}-${var.service}-${data.aws_caller_identity.self.account_id}"
}
