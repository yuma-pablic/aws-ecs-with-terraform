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

#ECS Backend用タスク定義
resource "aws_ecs_task_definition" "sbcntr-backend-def" {
  family                   = "sbcntr-backed-def"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "1G"
  memory                   = "0.5G"
  container_definitions = jsonencode([
    {
      name   = "app"
      image  = "${data.aws_caller_identity.self.account_id}.dkr.ecr.ap-northeast-1.amazonaws.com/sbcntr-backend"
      cpu    = 256
      memory = 512
      portMappings = [
        {
          containerPort = 80
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group : "/ecs/sbcntr-backend-def"
          awslogs-region : "ap-northeast-1"
          awslogs-stream-prefix : "ecs"
        }
      }
    }
  ])
}

#ECS Backend用サービス
resource "aws_ecs_service" "sbcntr-ecs-backend-service" {
  name                               = "sbcntr-ecs-backend-service"
  cluster                            = aws_ecs_cluster.sbcntr-backend-cluster
  platform_version                   = "LATEST"
  task_definition                    = aws_ecs_task_definition.sbcntr-backend-def.id
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
    security_groups  = [aws_security_group.sbcntr-sg-internal.id]
    assign_public_ip = false
  }
  health_check_grace_period_seconds = 120
  load_balancer {
    elb_name         = aws_alb.sbcntr-alb-internal.id
    target_group_arn = aws_lb_target_group.sbcntr-tg-blue.id
    container_name   = 80
    container_port   = 80
  }
}

#Code Deploy
resource "aws_codedeploy_app" "AppECS-sbcntr-ecs-backend-cluster-sbcntr-ecs-backend-service" {
  compute_platform = "ECS"
  name             = "AppECS-sbcntr-ecs-backend-cluster-sbcntr-ecs-backend-service"
}

resource "aws_codedeploy_deployment_group" "Dpgsbcntr-ecs-backend-cluster-sbcntr-ecs-backend-service" {
  app_name               = "AppECS-sbcntr-ecs-backend-cluster-sbcntr-ecs-backend-service"
  deployment_group_name  = "Dpgsbcntr-ecs-backend-cluster-sbcntr-ecs-backend-service"
  service_role_arn       = ""
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
    cluster_name = aws_ecs_cluster.sbcntr-backend-cluster
    service_name = aws_ecs_service.sbcntr-ecs-backend-service
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [aws_lb_listener.sbcntr-lisner-blue.id, aws_lb_listener.sbcntr-lisner-green.id]
      }
      target_group {
        name = aws_lb_target_group.sbcntr-tg-blue.id
      }
      target_group {
        name = aws_lb_target_group.sbcntr-tg-green.id
      }
    }
  }
}
