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
resource "aws_alb" "sbcntr-alb-internal" {
  name            = "sbcntr-alb-internal"
  internal        = true
  security_groups = [aws_security_group.sbcntr-sg-internal.id]
  subnets = [
    aws_subnet.sbcntr-subnet-private-container-1a.id,
    aws_subnet.sbcntr-subnet-private-container-1c.id,
  ]
}

resource "aws_lb_target_group" "sbcntr-tg-blue" {
  name        = "sbcntr-backend-tg-blue"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  tags = {
    Name = "sbcntr-tg-blue"
  }
  health_check {
    protocol            = "HTTP"
    path                = "/healthcheck"
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 15
    matcher             = 200
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group" "sbcntr-tg-green" {
  name        = "sbcntr-backend-tg-green"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  tags = {
    "Name" = "sbcntr-tg-green"
  }
  health_check {
    protocol            = "HTTP"
    path                = "/healthcheck"
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 15
    matcher             = 200
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "sbcntr-lisner-blue" {
  load_balancer_arn = aws_alb.sbcntr-alb-internal.id
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sbcntr-tg-blue.id
  }
}

resource "aws_lb_listener" "sbcntr-lisner-green" {
  load_balancer_arn = aws_alb.sbcntr-alb-internal.id
  port              = 10080
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sbcntr-tg-green.id
  }
}

resource "aws_alb" "sbcntr-alb-frontend" {
  name            = "sbcntr-alb-frontend"
  internal        = false
  security_groups = [aws_security_group.sbcntr-sg-ingress.id]
  subnets = [
    aws_subnet.sbcntr-subnet-public-ingress-1a.id,
    aws_subnet.sbcntr-subnet-public-ingress-1c.id,
  ]
}

resource "aws_lb_target_group" "sbcntr-tg-frontend" {
  name        = "sbcntr-tg-frontend"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    protocol            = "HTTP"
    path                = "/healthcheck"
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 15
    matcher             = 200
  }
}

resource "aws_lb_listener" "sbcntr-lisner-frontend" {
  load_balancer_arn = aws_alb.sbcntr-alb-frontend.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sbcntr-tg-frontend.id
  }
}

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

# ECS Backend用クラスター
resource "aws_ecs_cluster" "sbcntr-backend-cluster" {
  name               = "sbcntr-backend-cluster"
  capacity_providers = ["FARGATE"]
  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
  }
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_cloudwatch_log_group" "ecs-sbcntr-backend-def" {
  name              = "/ecs/sbcntr-backend-def"
  retention_in_days = 30
}

#ECS Backend用タスク定義
resource "aws_ecs_task_definition" "sbcntr-backend-def" {
  family                   = "sbcntr-backend-def"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = aws_iam_role.ecs-backend-extension-role.arn
  container_definitions = jsonencode([
    {
      name               = "app"
      image              = "${data.aws_caller_identity.self.account_id}.dkr.ecr.ap-northeast-1.amazonaws.com/sbcntr-backend:v1"
      cpu                = 256
      memory_reservation = 512
      essential          = true
      runtime_platform = {
        operating_system_family = "LINUX"
      }

      portMappings = [
        {
          containerPort = 80
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-create-group : "true",
          awslogs-group : aws_cloudwatch_log_group.ecs-sbcntr-backend-def.name
          awslogs-region : "ap-northeast-1"
          awslogs-stream-prefix : "ecs"
        }
      }
    }
  ])
}

#ECS Backend用サービス
resource "aws_ecs_service" "sbcntr-ecs-backend-service" {
  depends_on                         = [aws_lb_listener.sbcntr-lisner-blue, aws_lb_listener.sbcntr-lisner-green]
  name                               = "sbcntr-ecs-backend-service"
  cluster                            = aws_ecs_cluster.sbcntr-backend-cluster.id
  platform_version                   = "LATEST"
  task_definition                    = aws_ecs_task_definition.sbcntr-backend-def.arn
  desired_count                      = 2
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE"
  deployment_controller {
    type = "CODE_DEPLOY"
  }
  network_configuration {
    subnets = [
      aws_subnet.sbcntr-subnet-private-container-1a.id,
      aws_subnet.sbcntr-subnet-private-container-1c.id,
    ]
    security_groups  = [aws_security_group.sbcntr-sg-backend.id]
    assign_public_ip = false
  }
  health_check_grace_period_seconds = 120
  load_balancer {
    target_group_arn = aws_lb_target_group.sbcntr-tg-blue.arn
    container_name   = "app"
    container_port   = 80
  }
  lifecycle {
    ignore_changes = [
      desired_count,
      task_definition,
      load_balancer,
      network_configuration,
      platform_version
    ]
  }
}

#Code Deploy
resource "aws_codedeploy_app" "app-ecs-sbcntr-ecs-backend-cluster-sbcntr-ecs-backend-service" {
  compute_platform = "ECS"
  name             = "AppECS-sbcntr-ecs-backend-cluster-sbcntr-ecs-backend-service"
}

resource "aws_codedeploy_deployment_group" "dpg-sbcntr-ecs-backend-cluster-sbcntr-ecs-backend-service" {
  depends_on = [
    aws_iam_role.ecs-codedeploy-role,
    aws_ecs_cluster.sbcntr-backend-cluster
  ]
  app_name               = "AppECS-sbcntr-ecs-backend-cluster-sbcntr-ecs-backend-service"
  deployment_group_name  = "Dpgsbcntr-ecs-backend-cluster-sbcntr-ecs-backend-service"
  service_role_arn       = aws_iam_role.ecs-codedeploy-role.arn
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 10
    }
  }
  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = aws_ecs_cluster.sbcntr-backend-cluster.name
    service_name = aws_ecs_service.sbcntr-ecs-backend-service.name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [aws_lb_listener.sbcntr-lisner-blue.arn]
      }
      target_group {
        name = aws_lb_target_group.sbcntr-tg-blue.name
      }
      target_group {
        name = aws_lb_target_group.sbcntr-tg-green.name
      }
    }
  }
}

#ECS フロントエンド用クラスター
resource "aws_ecs_cluster" "sbcntr-frontend-cluster" {
  name               = "sbcntr-frontend-cluster"
  capacity_providers = ["FARGATE"]
  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
  }
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

#ECS フロンドエンド用タスク定義
resource "aws_ecs_task_definition" "sbcntr-frontend-def" {
  depends_on               = [aws_alb.sbcntr-alb-frontend]
  family                   = "sbcntr-frontend-def"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = aws_iam_role.ecs-frontend-extension-role.arn
  container_definitions = jsonencode([
    {
      name               = "app"
      image              = "${data.aws_caller_identity.self.account_id}.dkr.ecr.ap-northeast-1.amazonaws.com/sbcntr-frontend:v1"
      cpu                = 256
      memory_reservation = 512
      essential          = true
      runtime_platform = {
        operating_system_family = "LINUX"
      }

      portMappings = [
        {
          containerPort = 80
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-create-group : "true"
          awslogs-group : aws_cloudwatch_log_group.ecs-sbcntr-frontend-def.name
          awslogs-region : "ap-northeast-1"
          awslogs-stream-prefix : "ecs"
        }
      }
      environment = [
        {
          name : "SESSION_SECRET_KEY"
          value : "41b678c65b37bf99c37bcab522802760"
        },
        {
          name : "APP_SERVICE_HOST"
          value : "http://${aws_alb.sbcntr-alb-internal.dns_name}"
        },
        {
          name : "NOTIF_SERVICE_HOST"
          value : "http://${aws_alb.sbcntr-alb-internal.dns_name}"
        }
      ]

    }
  ])
}

resource "aws_cloudwatch_log_group" "ecs-sbcntr-frontend-def" {
  name              = "ecs-sbcntr-frontend-def"
  retention_in_days = 30
}

resource "aws_iam_policy" "sbcntr-accessing-ecr-repository-policy" {
  name = "sbcntr-AccessingECRRepositoryPolicy"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "ListImagesInRepository",
          "Effect" : "Allow",
          "Action" : [
            "ecr:ListImages"
          ],
          "Resource" : [
            "arn:aws:ecr:ap-northeast-1:${data.aws_caller_identity.self.account_id}:repository/sbcntr-backend",
            "arn:aws:ecr:ap-northeast-1:${data.aws_caller_identity.self.account_id}:repository/sbcntr-frontend"
          ]
        },
        {
          "Sid" : "GetAuthorizationToken",
          "Effect" : "Allow",
          "Action" : [
            "ecr:GetAuthorizationToken"
          ],
          "Resource" : "*"
        },
        {
          "Sid" : "ManageRepositoryContents",
          "Effect" : "Allow",
          "Action" : [
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:GetRepositoryPolicy",
            "ecr:DescribeRepositories",
            "ecr:ListImages",
            "ecr:DescribeImages",
            "ecr:BatchGetImage",
            "ecr:InitiateLayerUpload",
            "ecr:UploadLayerPart",
            "ecr:CompleteLayerUpload",
            "ecr:PutImage"
          ],
          "Resource" : [
            "arn:aws:ecr:ap-northeast-1:${data.aws_caller_identity.self.account_id}:repository/sbcntr-backend",
            "arn:aws:ecr:ap-northeast-1:${data.aws_caller_identity.self.account_id}:repository/sbcntr-frontend"
          ]
        }
      ]
    }
  )
}

resource "aws_iam_policy" "sbcntr-administrater" {
  name = "sbcntr-administrater"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : "*",
          "Resource" : "*"
        }
      ]
    }
  )
}

resource "aws_iam_role" "sbcntr-cloud9-role" {
  name        = "sbcntr-cloud9-role"
  description = "Allow EC2 instances to call AWS service on your behalf ."
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}


resource "aws_iam_role_policy_attachment" "iam-atachement-sbcntr-cloud9-role-admin" {
  role       = aws_iam_role.sbcntr-cloud9-role.name
  policy_arn = aws_iam_policy.sbcntr-administrater.arn
}

resource "aws_iam_role_policy_attachment" "iam-atachment-sbcntr-cloud9-role-ecr" {
  role       = aws_iam_role.sbcntr-cloud9-role.name
  policy_arn = aws_iam_policy.sbcntr-accessing-ecr-repository-policy.arn
}

resource "aws_iam_instance_profile" "sbcntr-cloud9-role-profile" {
  name = "sbcntr-cloud9-role-profile"
  role = aws_iam_role.sbcntr-cloud9-role.name
}
# Blue Green Deploymentを実行する際の権限

resource "aws_iam_role" "ecs-codedeploy-role" {
  name               = "ecs-codedeploy-role"
  assume_role_policy = <<EOT
{
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "",
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "codedeploy.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
    }
EOT
}

resource "aws_iam_role_policy_attachment" "AWSCodeDeployRoleForECS" {
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
  role       = aws_iam_role.ecs-codedeploy-role.id
}

resource "aws_iam_role" "ecs-backend-extension-role" {
  name = "ecsBackendTaskExecutionRole"
  assume_role_policy = jsonencode(
    {
      "Version" : "2008-10-17",
      "Statement" : [
        {
          "Sid" : "",
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "ecs-tasks.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
    }
  )
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

resource "aws_iam_role" "ecs-frontend-extension-role" {
  name = "ecsFrontendTaskExecutionRole"
  assume_role_policy = jsonencode(
    {
      "Version" : "2008-10-17",
      "Statement" : [
        {
          "Sid" : "",
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "ecs-tasks.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "ecs-frontend-extension-role-attachement" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecs-frontend-extension-role.id
}

resource "aws_iam_role_policy_attachment" "ecs-frontend-extension-role-attachement-secrets" {
  policy_arn = aws_iam_policy.sbcntr-getting-secrets-policy.arn
  role       = aws_iam_role.ecs-frontend-extension-role.id
}
