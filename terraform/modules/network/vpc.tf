resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    Name = "${var.env}-${var.service}-vpc"
  }
}
resource "aws_secretsmanager_secret" "rds_dbname" {
  name = "${var.env}-${var.service}-rds-dbnamee"
}

resource "aws_secretsmanager_secret_version" "asm_secret_dbname_version" {
  secret_id     = aws_secretsmanager_secret.rds_dbname.id
  secret_string = jsonencode({ "name" = "sbcntrapp" })
}
