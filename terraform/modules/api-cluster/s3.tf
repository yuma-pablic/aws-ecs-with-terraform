resource "aws_s3_bucket" "firelens" {
  bucket        = "${var.env}-${var.service}-firelens"
  force_destroy = true

  tags = {
    Name = "${var.env}-${var.service}firelens"
  }
}

resource "aws_s3_bucket_acl" "firelens" {
  bucket = aws_s3_bucket.firelens.bucket
  acl    = "private"
}
