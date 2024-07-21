resource "aws_s3_bucket" "firelens-logs" {
  bucket = "firelens-logs-${var.environment}"
  acl    = "private"

  tags = {
    Name        = "firelens-logs-${var.environment}"
    Environment = var.environment
  }
}
