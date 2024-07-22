resource "aws_rds_cluster" "db" {
  cluster_identifier              = "${var.env}-${var.service}-db"
  database_name                   = "sbcntr"
  engine                          = "aurora-mysql"
  engine_version                  = "8.0.mysql_aurora.3.04.1"
  master_username                 = "admin"
  manage_master_user_password     = true
  port                            = 3306
  vpc_security_group_ids          = [var.sg_db_id]
  db_subnet_group_name            = var.subnet_group
  enabled_cloudwatch_logs_exports = ["audit", "error", "slowquery"]
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.this.name
  skip_final_snapshot             = true
  apply_immediately               = false
  deletion_protection             = false
}

resource "aws_rds_cluster_instance" "db" {
  count                        = var.env == "prod" ? 3 : 1
  cluster_identifier           = aws_rds_cluster.db.id
  engine                       = aws_rds_cluster.db.engine
  engine_version               = aws_rds_cluster.db.engine_version
  instance_class               = "db.t3.medium"
  db_subnet_group_name         = var.subnet_group
  publicly_accessible          = false
  auto_minor_version_upgrade   = true
  preferred_maintenance_window = "Sat:17:00-Sat:17:30"
}

resource "aws_rds_cluster_parameter_group" "this" {
  name   = "${var.env}-${var.service}-database-cluster-parameter-group"
  family = "aurora-mysql8.0"

  parameter {
    name  = "time_zone"
    value = "Asia/Tokyo"
  }
}
