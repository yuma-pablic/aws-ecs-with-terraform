resource "aws_codecommit_repository" "backend" {
  repository_name = "${var.env}-${var.service}-backend"
  description     = "Repository for sbcntr backend application"
}

