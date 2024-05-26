resource "aws_rds_cluster" "db" {
  cluster_identifier              = "${var.env}-${var.service}-db"
  database_name                   = "${var.env}-${var.service}-db"
  engine                          = "aurora-mysql"
  engine_version                  = "5.7.mysql_aurora.2.10.2"
  master_username                 = "admin"
  master_password                 = "foobarbaz"
  port                            = 3306
  vpc_security_group_ids          = [aws_security_group.sbcntr-sg-db.id]
  db_subnet_group_name            = var.subnet_group.name
  db_cluster_parameter_group_name = "default.aurora-mysql5.7"
  enabled_cloudwatch_logs_exports = ["audit", "error", "slowquery"]
  skip_final_snapshot             = true
  apply_immediately               = true
  deletion_protection             = false
}
resource "aws_rds_cluster_instance" "db" {
  count                        = 3
  cluster_identifier           = aws_rds_cluster.db.id
  engine                       = aws_rds_cluster.db.engine
  engine_version               = aws_rds_cluster.db.engine_version
  instance_class               = "db.t3.small"
  db_subnet_group_name         = var.subnet_group.name
  db_parameter_group_name      = "default.aurora-mysql5.7"
  publicly_accessible          = false
  auto_minor_version_upgrade   = true
  preferred_maintenance_window = "Sat:17:00-Sat:17:30"
}
