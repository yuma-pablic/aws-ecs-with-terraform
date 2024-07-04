resource "aws_s3_bucket" "api_codepipline_bucket" {
  bucket = "${var.env}-${var.service}-codepipline-bucket"
}
