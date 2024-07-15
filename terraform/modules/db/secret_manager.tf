resource "aws_secretsmanager_secret" "rds_cluster_arn" {
  name = "${var.env}-${var.service}-rds-cluster-arn"
}

resource "aws_secretsmanager_secret_version" "asm_secret_rds_cluster_arn_version" {
  secret_id     = aws_secretsmanager_secret.rds_cluster_arn.id
  secret_string = jsonencode({ "host" = aws_rds_cluster_endpoint.db.endpoint })
}

resource "aws_secretsmanager_secret" "rds_cluster_arn" {
  name = "${var.env}-${var.service}-rds-cluster-arn"
}

resource "aws_secretsmanager_secret_version" "asm_secret_web_version" {
  secret_id     = aws_secretsmanager_secret.rds_cluster_arn.id
  secret_string = jsonencode({ "dbname" = "sbcntrapp" })
}
