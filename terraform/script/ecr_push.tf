resource "null_resource" "default" {
  provisioner "local-exec" {
    command = "$(aws ecr get-login --no-include-email --region ${""})"
  }

  provisioner "local-exec" {
    command = "docker build -t ${""} ${""}"
  }

  provisioner "local-exec" {
    command = "docker tag ${""}:latest ${aws_ecr_repository.default.repository_url}"
  }

  provisioner "local-exec" {
    command = "docker push ${aws_ecr_repository.default.repository_url}"
  }
}
