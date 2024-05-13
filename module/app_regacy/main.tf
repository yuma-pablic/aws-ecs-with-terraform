#コンテナアプリ用のプライベートサブネット
resource "aws_subnet" "sbcntr-subnet-private-container-1a" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.8.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "sbcntr-subnet-private-container-1a"
    Type = "Isolated"
  }
}


resource "aws_subnet" "sbcntr-subnet-private-container-1c" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.9.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = false
  tags = {
    Name = "sbcntr-subnet-private-container-1c"
    Type = "Isolated"
  }
}


#Ingress用のパブリックサブネット
resource "aws_subnet" "sbcntr-subnet-public-ingress-1a" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "sbcntr-subnet-public-ingress-1a"
    Type = "public"
  }
}

resource "aws_subnet" "sbcntr-subnet-public-ingress-1c" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true
  tags = {
    Name = "sbcntr-subnet-public-ingress-1c"
    Type = "public"
  }
}

## 管理サーバ用のサブネット
resource "aws_subnet" "sbcntr-subnet-public-management-1a" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.240.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "sbcntr-subnet-public-management-1a"
    Type = "Public"
  }
}

resource "aws_subnet" "sbcntr-subnet-public-management-1c" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.241.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true
  tags = {
    Name = "sbcntr-subnet-public-management-1c"
    Type = "Public"
  }
}

## VPC Endpoint用のサブネット
resource "aws_subnet" "sbcntr-subnet-private-egress-1a" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.248.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "sbcntr-subnet-private-egress-1a"
    Type = "Isolated"
  }
}

resource "aws_subnet" "sbcntr-subnet-private-egress-1c" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.249.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = false
  tags = {
    Name = "sbcntr-subnet-private-egress-1c"
    Type = "Isolated"
  }
}

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

#コンテナアプリ用のルートテーブル
resource "aws_route_table" "sbcntr-route-app" {
  vpc_id = var.vpc_id
  tags = {
    Name = "sbcntr-route-app"
  }
}

#コンテナアプリ用サブネットルート紐付け
resource "aws_route_table_association" "private-1a" {
  subnet_id      = aws_subnet.sbcntr-subnet-private-container-1a.id
  route_table_id = aws_route_table.sbcntr-route-app.id
}

resource "aws_route_table_association" "private-1c" {
  subnet_id      = aws_subnet.sbcntr-subnet-private-container-1c.id
  route_table_id = aws_route_table.sbcntr-route-app.id
}

#Ingress用のルートテーブル
resource "aws_route_table" "sbcntr-route-ingress" {
  vpc_id = var.vpc_id
  tags = {
    Name = "sbcntr-route-ingress"
  }
}
## Ingressサブネットへルート紐付け
resource "aws_route_table_association" "public-ingress-1a" {
  subnet_id      = aws_subnet.sbcntr-subnet-public-ingress-1a.id
  route_table_id = aws_route_table.sbcntr-route-ingress.id
}

resource "aws_route_table_association" "public-ingress-1c" {
  subnet_id      = aws_subnet.sbcntr-subnet-public-ingress-1c.id
  route_table_id = aws_route_table.sbcntr-route-ingress.id
}

## Ingress用ルートテーブルのデフォルトルート
resource "aws_route" "PublicRouteTable_Connect_InternetGateway" {
  route_table_id         = aws_route_table.sbcntr-route-ingress.id
  destination_cidr_block = "0.0.0.0/0" # internet_gatewayの外への通信許可設定
  gateway_id             = aws_internet_gateway.sbcntr-igw.id
}

## 管理用サブネットのルートはIngressと同様として作成する
resource "aws_route_table_association" "public-management-1a" {
  subnet_id      = aws_subnet.sbcntr-subnet-public-management-1a.id
  route_table_id = aws_route_table.sbcntr-route-ingress.id
}

resource "aws_route_table_association" "public-management-1c" {
  subnet_id      = aws_subnet.sbcntr-subnet-public-management-1c.id
  route_table_id = aws_route_table.sbcntr-route-ingress.id
}

############################################################################

# ECRからImageを取得する用
resource "aws_vpc_endpoint" "sbcntr-vpce-ecr-api" {
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

resource "aws_vpc_endpoint" "sbcntr-vpce-ecr-dkr" {
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

resource "aws_vpc_endpoint" "sbcntr-vpce-s3" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.ap-northeast-1.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.sbcntr-route-app.id]
}

#Cloud watch logsにデータを送信する用
resource "aws_vpc_endpoint" "sbcntr-vpce-logs" {
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



resource "aws_cloudwatch_log_group" "ecs-sbcntr-backend-def" {
  name              = "/ecs/sbcntr-backend-def"
  retention_in_days = 30
}
resource "aws_cloudwatch_log_group" "ecs-sbcntr-firelens-log-group" {
  name              = "/aws/ecs/sbcntr-firelens-container"
  retention_in_days = 14
}




resource "aws_cloudwatch_log_group" "ecs-sbcntr-frontend-def" {
  name              = "ecs-sbcntr-frontend-def"
  retention_in_days = 30
}



resource "aws_iam_role_policy_attachment" "ecs-backend-extension-role-attachement" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecs-backend-extension-role.id
}

resource "aws_iam_policy" "sbcntr-getting-secrets-policy" {
  name = "sbcntr-GettingSecretsPolicy"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "GetSecretForECS",
          "Effect" : "Allow",
          "Action" : [
            "secretsmanager:GetSecretValue"
          ],
          "Resource" : ["*"]
        }
      ]
    }
  )
}
resource "aws_iam_role_policy_attachment" "ecs-backend-extension-role-attachement-secrets" {
  policy_arn = aws_iam_policy.sbcntr-getting-secrets-policy.arn
  role       = aws_iam_role.ecs-backend-extension-role.id
}



