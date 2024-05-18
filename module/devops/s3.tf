resource "aws_s3_bucket" "codepipline_bucket" {
  bucket = "${var.env}-${var.service}-codepipline-bucket"
}
