resource "aws_db_subnet_group" "sbcntr-rds-subnet-group" {
  name        = "sbcntr-rds-subnet-group"
  description = "DB subnet group for Auroa"
  subnet_ids  = [aws_subnet.sbcntr-subnet-private-db-1a.id, aws_subnet.sbcntr-subnet-private-db-1c.id]
}

resource "aws_rds_cluster" "sbcntr-db-cluster" {
  cluster_identifier              = "sbcntr"
  database_name                   = "sbcntr"
  engine                          = "aurora-mysql"
  engine_version                  = "5.7.mysql_aurora.2.10.2"
  master_username                 = "admin"
  master_password                 = "foobarbaz"
  port                            = 3306
  vpc_security_group_ids          = [aws_security_group.sbcntr-sg-db.id]
  db_subnet_group_name            = aws_db_subnet_group.sbcntr-rds-subnet-group.id
  db_cluster_parameter_group_name = "default.aurora-mysql5.7"
  enabled_cloudwatch_logs_exports = ["audit", "error", "slowquery"]
  skip_final_snapshot             = true
  apply_immediately               = true
  deletion_protection             = false
}
resource "aws_rds_cluster_instance" "sbcntr-db" {
  count                        = 3
  cluster_identifier           = aws_rds_cluster.sbcntr-db-cluster.id
  engine                       = aws_rds_cluster.sbcntr-db-cluster.engine
  engine_version               = aws_rds_cluster.sbcntr-db-cluster.engine_version
  instance_class               = "db.t3.small"
  db_subnet_group_name         = aws_db_subnet_group.sbcntr-rds-subnet-group.id
  db_parameter_group_name      = "default.aurora-mysql5.7"
  publicly_accessible          = false
  auto_minor_version_upgrade   = true
  preferred_maintenance_window = "Sat:17:00-Sat:17:30"
}
