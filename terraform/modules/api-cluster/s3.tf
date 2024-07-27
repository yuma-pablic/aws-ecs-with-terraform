resource "aws_s3_bucket" "firelens" {
  bucket        = "${var.env}-${var.service}-firelens"
  force_destroy = true

  tags = {
    Name = "${var.env}-${var.service}-firelens"
  }
}
