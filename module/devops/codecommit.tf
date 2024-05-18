resource "aws_codecommit_repository" "backend" {
  repository_name = "${local.service_name}-backend"
  description     = "Repository for sbcntr backend application"
}

