#コンテナアプリ用のプライベートサブネット
resource "aws_subnet" "private_container_1a" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.8.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.env}-${var.service}-subnet-private-container-1a"
    Type = "Isolated"
  }
}


resource "aws_subnet" "private_container_1c" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.9.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.env}-${var.service}-subnet-private-container-1c"
    Type = "Isolated"
  }
}


#Ingress用のパブリックサブネット
resource "aws_subnet" "public_ingress_1a" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.env}-${var.service}-subnet-public-ingress-1a"
    Type = "public"
  }
}

resource "aws_subnet" "public_ingress_1c" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.env}-${var.service}-subnet-public-ingress-1c"
    Type = "public"
  }
}

## 管理サーバ用のサブネット
resource "aws_subnet" "public_management_1a" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.240.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.env}-${var.service}-subnet-public-management-1a"
    Type = "Public"
  }
}

resource "aws_subnet" "public_management_1c" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.241.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.env}-${var.service}-subnet-public-management-1c"
    Type = "Public"
  }
}

## VPC Endpoint用のサブネット
resource "aws_subnet" "private_egress_1a" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.248.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.env}-${var.service}-subnet-private-egress-1a"
    Type = "Isolated"
  }
}

resource "aws_subnet" "private_egress_1c" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.249.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.env}-${var.service}-subnet-private-egress-1c"
    Type = "Isolated"
  }
}

# インターネットへ通信するためのゲートウェイの作成
resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.env}-${var.service}-igw"
  }
}

resource "aws_security_group" "ingress" {
  vpc_id      = var.vpc_id
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

# 管理用サーバ向けのセキュリティグループの生成
resource "aws_security_group" "management" {
  vpc_id      = var.vpc_id
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

## バックエンドコンテナアプリ用セキュリティグループの生成
resource "aws_security_group" "backend" {
  vpc_id      = var.vpc_id
  description = "Security Group of backend app"
  name        = "container"
  tags = {
    "Name" = "${var.env}-${var.service}-sg-backend-container"
  }
}

resource "aws_security_group_rule" "backdend_egress_v4" {
  type = "egress"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  description       = "Allow all outbound traffic by default"
  from_port         = 80
  protocol          = "-1"
  to_port           = 80
  security_group_id = aws_security_group.backend.id
}

## フロントエンドコンテナアプリ用セキュリティグループの生成
resource "aws_security_group" "front_container" {
  vpc_id      = var.vpc_id
  description = "Security Group of front container app"
  name        = "front-container"
  tags = {
    "Name" = "${var.env}-${var.service}-sg-front-container"
  }
}

resource "aws_security_group_rule" "frontend_egress_v4" {
  type = "egress"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  description       = "Allow all outbound traffic by default"
  from_port         = 80
  protocol          = "-1"
  to_port           = 80
  security_group_id = aws_security_group.front_container.id
}

## 内部用ロードバランサ用のセキュリティグループの生成
resource "aws_security_group" "internal" {
  vpc_id      = var.vpc_id
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

## VPCエンドポイント用セキュリティグループの生成
resource "aws_security_group" "vpce" {
  name        = "egress"
  description = "Security Group of VPC Endpoint"
  vpc_id      = var.vpc_id
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

## Internet LB -> Front Container
resource "aws_security_group_rule" "front_container_ingress" {
  type                     = "ingress"
  description              = "HTTP for Ingress"
  from_port                = 80
  source_security_group_id = aws_security_group.ingress.id
  security_group_id        = aws_security_group.front_container.id
  protocol                 = "tcp"
  to_port                  = 80
}


## Front Container -> Internal LB
resource "aws_security_group_rule" "ingress_from_front_container" {
  type                     = "ingress"
  description              = "HTTP for front container"
  from_port                = 80
  source_security_group_id = aws_security_group.front_container.id
  security_group_id        = aws_security_group.internal.id
  protocol                 = "tcp"
  to_port                  = 80
}

## Internal LB -> Back Container
resource "aws_security_group_rule" "internal_from_back_container" {
  type                     = "ingress"
  description              = "HTTP for internal lb"
  from_port                = 80
  source_security_group_id = aws_security_group.internal.id
  security_group_id        = aws_security_group.backend.id
  protocol                 = "tcp"
  to_port                  = 80
}


### Back container -> VPC endpoint
resource "aws_security_group_rule" "back_container_from_vpce" {
  type                     = "ingress"
  description              = " HTTPS for Container App"
  from_port                = 443
  source_security_group_id = aws_security_group.backend.id
  security_group_id        = aws_security_group.vpce.id
  protocol                 = "tcp"
  to_port                  = 443
}

### Front container -> VPC endpoint
resource "aws_security_group_rule" "front_container_from_vpce" {
  type                     = "ingress"
  description              = "HTTPS for Front Container App"
  from_port                = 443
  source_security_group_id = aws_security_group.front_container.id
  security_group_id        = aws_security_group.vpce.id
  protocol                 = "tcp"
  to_port                  = 443
}

### Management Server -> VPC endpoint
resource "aws_security_group_rule" "management_server_from_vpce" {
  type                     = "ingress"
  description              = "HTTPS for management server"
  from_port                = 443
  source_security_group_id = aws_security_group.management.id
  security_group_id        = aws_security_group.vpce.id
  protocol                 = "tcp"
  to_port                  = 443
}

### Management -> Internal
resource "aws_security_group_rule" "management_server_from_internal" {
  type                     = "ingress"
  description              = "HTTPS for management server"
  from_port                = 10080
  source_security_group_id = aws_security_group.management.id
  security_group_id        = aws_security_group.internal.id
  protocol                 = "tcp"
  to_port                  = 10080
}

#コンテナアプリ用のルートテーブル
resource "aws_route_table" "sbcntr-route-app" {
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.env}-${var.service}-route-app"
  }
}

#コンテナアプリ用サブネットルート紐付け
resource "aws_route_table_association" "private_1a" {
  subnet_id      = aws_subnet.private_container_1a.id
  route_table_id = aws_route_table.sbcntr-route-app.id
}

resource "aws_route_table_association" "private_1c" {
  subnet_id      = aws_subnet.private_container_1c.id
  route_table_id = aws_route_table.sbcntr-route-app.id
}

#Ingress用のルートテーブル
resource "aws_route_table" "route_ingress" {
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.env}-${var.service}-route-ingress"
  }
}
## Ingressサブネットへルート紐付け
resource "aws_route_table_association" "public_ingress_1a" {
  subnet_id      = aws_subnet.public_ingress_1a.id
  route_table_id = aws_route_table.route_ingress.id
}

resource "aws_route_table_association" "public_ingress_1c" {
  subnet_id      = aws_subnet.public_ingress_1c.id
  route_table_id = aws_route_table.route_ingress.id
}

## Ingress用ルートテーブルのデフォルトルート
resource "aws_route" "PublicRouteTable_Connect_InternetGateway" {
  route_table_id         = aws_route_table.route_ingress.id
  destination_cidr_block = "0.0.0.0/0" # internet_gatewayの外への通信許可設定
  gateway_id             = aws_internet_gateway.igw.id
}

## 管理用サブネットのルートはIngressと同様として作成する
resource "aws_route_table_association" "public_management_1a" {
  subnet_id      = aws_subnet.public_management_1a.id
  route_table_id = aws_route_table.route_ingress.id
}

resource "aws_route_table_association" "public_management_1c" {
  subnet_id      = aws_subnet.public_management_1c.id
  route_table_id = aws_route_table.route_ingress.id
}

############################################################################

# ECRからImageを取得する用
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.ap-northeast-1.ecr.api"
  private_dns_enabled = true
  vpc_endpoint_type   = "Interface"
  subnet_ids = [
    aws_subnet.sbcntr-subnet-private-egress-1a.id,
    aws_subnet.sbcntr-subnet-private-egress-1c.id,
  ]
  security_group_ids = [aws_security_group.sbcntr-sg-vpce.id]
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.ap-northeast-1.ecr.dkr"
  private_dns_enabled = true
  vpc_endpoint_type   = "Interface"
  subnet_ids = [
    aws_subnet.sbcntr-subnet-private-egress-1a.id,
    aws_subnet.sbcntr-subnet-private-egress-1c.id,
  ]
  security_group_ids = [aws_security_group.sbcntr-sg-vpce.id]
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.ap-northeast-1.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.sbcntr-route-app.id]
}

#Cloud watch logsにデータを送信する用
resource "aws_vpc_endpoint" "logs" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.ap-northeast-1.logs"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids = [
    aws_subnet.sbcntr-subnet-private-egress-1a.id,
    aws_subnet.sbcntr-subnet-private-egress-1c.id,
  ]
  security_group_ids = [aws_security_group.sbcntr-sg-vpce.id]
}

data "aws_caller_identity" "self" {}
