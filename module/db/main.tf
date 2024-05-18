resource "aws_subnet" "private_db_1a" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.16.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.env}-${var.service}-subnet-private-db-1a"
    Type = "Isolated"
  }
}

resource "aws_subnet" "private_db_1c" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.17.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.env}-${var.service}-subnet-private-db-1c"
    Type = "Isolated"
  }
}

resource "aws_route_table" "db" {
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.env}-${var.service}-route-db"
  }
}

resource "aws_route_table_association" "private_db_1a" {
  subnet_id      = aws_subnet.private_db_1a.id
  route_table_id = aws_route_table.db.id
}

resource "aws_route_table_association" "private_db_1c" {
  subnet_id      = aws_subnet.private_db_1c.id
  route_table_id = aws_route_table.db.id
}

resource "aws_security_group" "db" {
  vpc_id      = var.vpc_id
  description = "Security Group of database"
  name        = "database"
  tags = {
    "Name" = "${var.env}-${var.service}-sg-db"
  }
}

resource "aws_security_group_rule" "db_egress_v4" {
  type = "egress"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  description       = "Allow all outbound traffic by default"
  from_port         = 80
  protocol          = "-1"
  to_port           = 80
  security_group_id = aws_security_group.db.id
}

resource "aws_security_group_rule" "back_container_from_db" {
  type                     = "ingress"
  description              = "MySQL protocol from backend App"
  from_port                = 3306
  source_security_group_id = var.sg-backend-id
  security_group_id        = aws_security_group.db.id
  protocol                 = "tcp"
  to_port                  = 3306
}

resource "aws_security_group_rule" "front_container_from_db" {
  type                     = "ingress"
  description              = "MySQL protocol from management server"
  from_port                = 3306
  source_security_group_id = var.sg-frontend-id
  security_group_id        = aws_security_group.db.id
  protocol                 = "tcp"
  to_port                  = 3306
}



resource "aws_security_group_rule" "management_from_db" {
  type                     = "ingress"
  description              = "MySQL protocol from management server"
  from_port                = 3306
  source_security_group_id = var.sg-management-id
  security_group_id        = aws_security_group.db.id
  protocol                 = "tcp"
  to_port                  = 3306
}


resource "aws_db_subnet_group" "default" {
  name        = "${var.env}-${var.service}-rds-subnet-group"
  description = "DB subnet group for Auroa"
  subnet_ids  = [aws_subnet.sbcntr-subnet-private-db-1a.id, aws_subnet.sbcntr-subnet-private-db-1c.id]
}

resource "aws_rds_cluster" "default" {
  cluster_identifier              = "sbcntr"
  database_name                   = "sbcntr"
  engine                          = "aurora-mysql"
  engine_version                  = "5.7.mysql_aurora.2.10.2"
  master_username                 = "admin"
  master_password                 = "foobarbaz"
  port                            = 3306
  vpc_security_group_ids          = [aws_security_group.sbcntr-sg-db.id]
  db_subnet_group_name            = aws_db_subnet_group.default.id
  db_cluster_parameter_group_name = "default.aurora-mysql5.7"
  enabled_cloudwatch_logs_exports = ["audit", "error", "slowquery"]
  skip_final_snapshot             = true
  apply_immediately               = true
  deletion_protection             = false
}
resource "aws_rds_cluster_instance" "default" {
  count                        = 3
  cluster_identifier           = aws_rds_cluster.default.id
  engine                       = aws_rds_cluster.default.engine
  engine_version               = aws_rds_cluster.default.engine_version
  instance_class               = "db.t3.small"
  db_subnet_group_name         = aws_db_subnet_group.default.id
  db_parameter_group_name      = "default.aurora-mysql5.7"
  publicly_accessible          = false
  auto_minor_version_upgrade   = true
  preferred_maintenance_window = "Sat:17:00-Sat:17:30"
}


resource "aws_vpc_endpoint" "secrets" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.ap-northeast-1.secretsmanager"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids = [
    var.subnet-private-egress-1a-id,
    var.subnet-private-egress-1c-id,
  ]
  security_group_ids = [var.vpce_sg_id]
}
