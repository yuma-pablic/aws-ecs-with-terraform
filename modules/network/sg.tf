resource "aws_security_group" "ingress" {
  vpc_id      = aws_vpc.main.id
  description = "Security group for ingress"
  name        = "ingress"
  tags = {
    "Name" = "${var.env}-${var.service}-sg-ingress"
  }
}
resource "aws_security_group_rule" "inbaund" {
  type = "ingress"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  description       = "Allow all outbound traffic by default"
  from_port         = 80
  to_port           = 80
  protocol          = "-1"
  security_group_id = aws_security_group.ingress.id
}

resource "aws_security_group_rule" "egress_v4" {
  type = "egress"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  description       = "from 0.0.0.0/0:80"
  from_port         = 80
  protocol          = "tcp"
  to_port           = 80
  security_group_id = aws_security_group.ingress.id
}

resource "aws_security_group_rule" "egress_v6" {
  type              = "egress"
  ipv6_cidr_blocks  = ["::/0"]
  description       = "from ::/0:80"
  from_port         = 80
  protocol          = "tcp"
  to_port           = 80
  security_group_id = aws_security_group.ingress.id

}

resource "aws_security_group" "management" {
  vpc_id      = aws_vpc.main.id
  description = "Security Group of management server"
  name        = "${var.env}-${var.service}-management"
  tags = {
    "Name" = "sbcntr-sg-management"
  }
}

resource "aws_security_group_rule" "management_egress_v4" {
  type = "egress"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  description       = "from 0.0.0.0/0:80"
  from_port         = 80
  protocol          = "-1"
  to_port           = 80
  security_group_id = aws_security_group.management.id
}

resource "aws_security_group" "api" {
  vpc_id      = aws_vpc.main.id
  description = "Security Group of backend app"
  name        = "${var.env}-${var.service}-sg-api"
  tags = {
    "Name" = "${var.env}-${var.service}-sg-api"
  }
}

resource "aws_security_group_rule" "api_egress_v4" {
  type = "egress"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  description       = "Allow all outbound traffic by default"
  from_port         = 80
  protocol          = "-1"
  to_port           = 80
  security_group_id = aws_security_group.api.id
}

resource "aws_security_group" "web" {
  vpc_id      = aws_vpc.main.id
  description = "Security Group of front container app"
  name        = "web-container"
  tags = {
    "Name" = "${var.env}-${var.service}-sg-web-container"
  }
}

resource "aws_security_group_rule" "web_egress_v4" {
  type = "egress"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  description       = "Allow all outbound traffic by default"
  from_port         = 80
  protocol          = "-1"
  to_port           = 80
  security_group_id = aws_security_group.web.id
}

resource "aws_security_group" "internal" {
  vpc_id      = aws_vpc.main.id
  description = "Security group for internal load balancer"
  name        = "internal"
  tags = {
    "Name" = "${var.env}-${var.service}-sg-internal"
  }
}

resource "aws_security_group_rule" "internal_egress_v4" {
  type = "egress"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  description       = "Allow all outbound traffic by default"
  from_port         = 80
  protocol          = "-1"
  to_port           = 80
  security_group_id = aws_security_group.internal.id
}

resource "aws_security_group" "vpce" {
  name        = "egress"
  description = "Security Group of VPC Endpoint"
  vpc_id      = aws_vpc.main.id
  tags = {
    "Name" = "${var.env}-${var.service}-sg-vpce"
  }
}

resource "aws_security_group_rule" "vpce_egress" {
  type = "egress"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  description       = "Allow all outbound traffic by default"
  from_port         = 80
  protocol          = "-1"
  to_port           = 80
  security_group_id = aws_security_group.vpce.id
}

resource "aws_security_group_rule" "web_ingress" {
  type                     = "ingress"
  description              = "HTTP for Ingress"
  from_port                = 80
  source_security_group_id = aws_security_group.ingress.id
  security_group_id        = aws_security_group.web.id
  protocol                 = "tcp"
  to_port                  = 80
}


resource "aws_security_group_rule" "ingress_from_web" {
  type                     = "ingress"
  description              = "HTTP for front container"
  from_port                = 80
  source_security_group_id = aws_security_group.web.id
  security_group_id        = aws_security_group.internal.id
  protocol                 = "tcp"
  to_port                  = 80
}

resource "aws_security_group_rule" "internal_from_api" {
  type                     = "ingress"
  description              = "HTTP for internal lb"
  from_port                = 80
  source_security_group_id = aws_security_group.internal.id
  security_group_id        = aws_security_group.api.id
  protocol                 = "tcp"
  to_port                  = 80
}


resource "aws_security_group_rule" "api_from_vpce" {
  type                     = "ingress"
  description              = " HTTPS for Container App"
  from_port                = 443
  source_security_group_id = aws_security_group.api.id
  security_group_id        = aws_security_group.vpce.id
  protocol                 = "tcp"
  to_port                  = 443
}

resource "aws_security_group_rule" "web_from_vpce" {
  type                     = "ingress"
  description              = "HTTPS for Front Container App"
  from_port                = 443
  source_security_group_id = aws_security_group.web.id
  security_group_id        = aws_security_group.vpce.id
  protocol                 = "tcp"
  to_port                  = 443
}

resource "aws_security_group_rule" "management_server_from_vpce" {
  type                     = "ingress"
  description              = "HTTPS for management server"
  from_port                = 443
  source_security_group_id = aws_security_group.management.id
  security_group_id        = aws_security_group.vpce.id
  protocol                 = "tcp"
  to_port                  = 443
}

resource "aws_security_group_rule" "management_server_from_internal" {
  type                     = "ingress"
  description              = "HTTPS for management server"
  from_port                = 10080
  source_security_group_id = aws_security_group.management.id
  security_group_id        = aws_security_group.internal.id
  protocol                 = "tcp"
  to_port                  = 10080
}
resource "aws_security_group" "db" {
  vpc_id      = aws_vpc.main.id
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
  source_security_group_id = aws_security_group.api.id
  security_group_id        = aws_security_group.db.id
  protocol                 = "tcp"
  to_port                  = 3306
}

resource "aws_security_group_rule" "front_container_from_db" {
  type                     = "ingress"
  description              = "MySQL protocol from management server"
  from_port                = 3306
  source_security_group_id = aws_security_group.web.id
  security_group_id        = aws_security_group.db.id
  protocol                 = "tcp"
  to_port                  = 3306
}



resource "aws_security_group_rule" "management_from_db" {
  type                     = "ingress"
  description              = "MySQL protocol from management server"
  from_port                = 3306
  source_security_group_id = aws_security_group.management.id
  security_group_id        = aws_security_group.db.id
  protocol                 = "tcp"
  to_port                  = 3306
}
