resource "aws_rds_cluster" "db" {
  cluster_identifier              = "${var.env}-${var.service}-db"
  database_name                   = "sbcntr"
  engine                          = "aurora-mysql"
  engine_version                  = "8.0.mysql_aurora.3.02.0"
  master_username                 = "admin"
  manage_master_user_password     = true
  port                            = 3306
  vpc_security_group_ids          = [var.sg_db_id]
  db_subnet_group_name            = var.subnet_group
  db_cluster_parameter_group_name = "default.aurora-mysql8.0"
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
  db_subnet_group_name         = var.subnet_group
  db_parameter_group_name      = "aurora-mysql8.0"
  publicly_accessible          = false
  auto_minor_version_upgrade   = true
  preferred_maintenance_window = "Sat:17:00-Sat:17:30"
}
