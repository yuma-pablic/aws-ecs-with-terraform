resource "aws_ecr_repository" "api" {
  name                 = "sbcntr-api"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}