# インターネットへ通信するためのゲートウェイの作成
resource "aws_internet_gateway" "sbcntr-igw" {
  vpc_id = var.vpc_id
  tags = {
    Name = "sbcntr-igw"
  }
}

resource "aws_security_group" "sbcntr-sg-ingress" {
  vpc_id      = var.vpc_id
  description = "Security group for ingress"
  name        = "ingress"
  tags = {
    "Name" = "sbcntr-sg-ingress"
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
  security_group_id = aws_security_group.sbcntr-sg-ingress.id
}

resource "aws_security_group_rule" "egress-v4" {
  type = "egress"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  description       = "from 0.0.0.0/0:80"
  from_port         = 80
  protocol          = "tcp"
  to_port           = 80
  security_group_id = aws_security_group.sbcntr-sg-ingress.id
}

resource "aws_security_group_rule" "egress-v6" {
  type              = "egress"
  ipv6_cidr_blocks  = ["::/0"]
  description       = "from ::/0:80"
  from_port         = 80
  protocol          = "tcp"
  to_port           = 80
  security_group_id = aws_security_group.sbcntr-sg-ingress.id
}

# 管理用サーバ向けのセキュリティグループの生成
resource "aws_security_group" "sbcntr-sg-management" {
  vpc_id      = var.vpc_id
  description = "Security Group of management server"
  name        = "management"
  tags = {
    "Name" = "sbcntr-sg-management"
  }
}

resource "aws_security_group_rule" "management-egress-v4" {
  type = "egress"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  description       = "from 0.0.0.0/0:80"
  from_port         = 80
  protocol          = "-1"
  to_port           = 80
  security_group_id = aws_security_group.sbcntr-sg-management.id
}

## バックエンドコンテナアプリ用セキュリティグループの生成
resource "aws_security_group" "sbcntr-sg-backend" {
  vpc_id      = var.vpc_id
  description = "Security Group of backend app"
  name        = "container"
  tags = {
    "Name" = "sbcntr-sg-container"
  }
}

resource "aws_security_group_rule" "backdend-egress-v4" {
  type = "egress"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  description       = "Allow all outbound traffic by default"
  from_port         = 80
  protocol          = "-1"
  to_port           = 80
  security_group_id = aws_security_group.sbcntr-sg-backend.id
}

## フロントエンドコンテナアプリ用セキュリティグループの生成
resource "aws_security_group" "sbcntr-sg-front-container" {
  vpc_id      = var.vpc_id
  description = "Security Group of front container app"
  name        = "front-container"
  tags = {
    "Name" = "sbcntr-sg-front-container"
  }
}

resource "aws_security_group_rule" "frontend-egress-v4" {
  type = "egress"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  description       = "Allow all outbound traffic by default"
  from_port         = 80
  protocol          = "-1"
  to_port           = 80
  security_group_id = aws_security_group.sbcntr-sg-front-container.id
}

## 内部用ロードバランサ用のセキュリティグループの生成
resource "aws_security_group" "sbcntr-sg-internal" {
  vpc_id      = var.vpc_id
  description = "Security group for internal load balancer"
  name        = "internal"
  tags = {
    "Name" = "sbcntr-sg-internal"
  }
}

resource "aws_security_group_rule" "internal-egress-v4" {
  type = "egress"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  description       = "Allow all outbound traffic by default"
  from_port         = 80
  protocol          = "-1"
  to_port           = 80
  security_group_id = aws_security_group.sbcntr-sg-internal.id
}

## VPCエンドポイント用セキュリティグループの生成
resource "aws_security_group" "sbcntr-sg-vpce" {
  name        = "egress"
  description = "Security Group of VPC Endpoint"
  vpc_id      = var.vpc_id
  tags = {
    "Name" = "sbcntr-sg-vpce"
  }
}

resource "aws_security_group_rule" "sbcntr-sg-vpce-egress" {
  type = "egress"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  description       = "Allow all outbound traffic by default"
  from_port         = 80
  protocol          = "-1"
  to_port           = 80
  security_group_id = aws_security_group.sbcntr-sg-vpce.id
}

## Internet LB -> Front Container
resource "aws_security_group_rule" "sbcntr-sg-frontcontainer-from-sg-ingress" {
  type                     = "ingress"
  description              = "HTTP for Ingress"
  from_port                = 80
  source_security_group_id = aws_security_group.sbcntr-sg-ingress.id
  security_group_id        = aws_security_group.sbcntr-sg-front-container.id
  protocol                 = "tcp"
  to_port                  = 80
}


## Front Container -> Internal LB
resource "aws_security_group_rule" "sbcntr-sg-ingress-from-sg-frontcontainer" {
  type                     = "ingress"
  description              = "HTTP for front container"
  from_port                = 80
  source_security_group_id = aws_security_group.sbcntr-sg-front-container.id
  security_group_id        = aws_security_group.sbcntr-sg-internal.id
  protocol                 = "tcp"
  to_port                  = 80
}

## Internal LB -> Back Container
resource "aws_security_group_rule" "sbcntr-sg-internal-from-sg-backcontainer" {
  type                     = "ingress"
  description              = "HTTP for internal lb"
  from_port                = 80
  source_security_group_id = aws_security_group.sbcntr-sg-internal.id
  security_group_id        = aws_security_group.sbcntr-sg-backend.id
  protocol                 = "tcp"
  to_port                  = 80
}


### Back container -> VPC endpoint
resource "aws_security_group_rule" "sbcntr-sg-back-container-from-vpce" {
  type                     = "ingress"
  description              = " HTTPS for Container App"
  from_port                = 443
  source_security_group_id = aws_security_group.sbcntr-sg-backend.id
  security_group_id        = aws_security_group.sbcntr-sg-vpce.id
  protocol                 = "tcp"
  to_port                  = 443
}

### Front container -> VPC endpoint
resource "aws_security_group_rule" "sbcntr-sg-front-container-from-vpce" {
  type                     = "ingress"
  description              = "HTTPS for Front Container App"
  from_port                = 443
  source_security_group_id = aws_security_group.sbcntr-sg-front-container.id
  security_group_id        = aws_security_group.sbcntr-sg-vpce.id
  protocol                 = "tcp"
  to_port                  = 443
}

### Management Server -> VPC endpoint
resource "aws_security_group_rule" "sbcntr-sg-management-server-from-vpce" {
  type                     = "ingress"
  description              = "HTTPS for management server"
  from_port                = 443
  source_security_group_id = aws_security_group.sbcntr-sg-management.id
  security_group_id        = aws_security_group.sbcntr-sg-vpce.id
  protocol                 = "tcp"
  to_port                  = 443
}

### Management -> Internal
resource "aws_security_group_rule" "sbcntr-sg-management-server-from-internal" {
  type                     = "ingress"
  description              = "HTTPS for management server"
  from_port                = 10080
  source_security_group_id = aws_security_group.sbcntr-sg-management.id
  security_group_id        = aws_security_group.sbcntr-sg-internal.id
  protocol                 = "tcp"
  to_port                  = 10080
}

