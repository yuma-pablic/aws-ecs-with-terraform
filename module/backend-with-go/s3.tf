resource "aws_s3_bucket" "sbcntr-account-id" {
  bucket = "${var.env}-${var.service}-${data.aws_caller_identity.self.account_id}"
}
