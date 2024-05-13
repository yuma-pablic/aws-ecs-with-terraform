resource "aws_s3_bucket" "sbcntr-account-id" {
  bucket = "sbcntr-${data.aws_caller_identity.self.account_id}"
}
