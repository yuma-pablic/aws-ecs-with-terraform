resource "aws_ecr_repository" "api" {
  name                 = "sbcntr-api"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "api" {
  repository = aws_ecr_repository.api.name
  policy     = data.aws_ecr_lifecycle_policy_document.keep_last_30_images.json
}

resource "aws_ecr_repository" "firelens" {
  name                 = "${var.service}firelens"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "firelens" {
  repository = aws_ecr_repository.firelens.name
  policy     = data.aws_ecr_lifecycle_policy_document.keep_last_30_images.json
}

data "aws_ecr_lifecycle_policy_document" "keep_last_30_images" {
  rule {
    priority    = 30
    description = "Keep last 30 images"

    selection {
      tag_status      = "tagged"
      tag_prefix_list = ["dev", "prod", "stg"]
      count_type      = "imageCountMoreThan"
      count_number    = 100
    }
    action {
      type = "expire"
    }
  }
}
