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
  family                   = "sbcntr-backed-def"
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
