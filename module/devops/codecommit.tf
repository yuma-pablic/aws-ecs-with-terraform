resource "aws_codecommit_repository" "backend" {
  repository_name = "sbcntr-backend"
  description     = "Repository for sbcntr backend application"
}

