
resource "aws_ecs_cluster" "api" {
  name = "${var.env}-${var.service}-api-cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}
resource "aws_ecs_cluster_capacity_providers" "api" {
  cluster_name       = aws_ecs_cluster.api.name
  capacity_providers = ["FARGATE"]
  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
  }
}
# ecsspressoに置き換える
resource "aws_ecs_service" "api" {
  depends_on                         = [var.lisner_blue, var.lisner_green]
  name                               = "${var.env}-${var.service}-ecs-api-service"
  cluster                            = aws_ecs_cluster.api.id
  platform_version                   = "LATEST"
  task_definition                    = aws_ecs_task_definition.api.arn
  desired_count                      = 2
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE"
  deployment_controller {
    type = "CODE_DEPLOY"
  }
  network_configuration {
    subnets = [
      var.sb_private_1a,
      var.sb_private_1c
    ]
    security_groups  = [var.sg_api]
    assign_public_ip = false
  }
  health_check_grace_period_seconds = 120
  load_balancer {
    target_group_arn = var.lisner_blue
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

resource "aws_ecs_task_definition" "api" {
  family                   = "${var.env}-${var.service}-api-def"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = aws_iam_role.ecs_api_extension.arn
  task_role_arn            = aws_iam_role.ecsTaskRole.arn
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
      # アプリのログはfirelensで出力
      logConfiguration = {
        logDriver = "awsfirelens"
      }
      }, {
      essential         = true,
      name              = "log_router"
      image             = "${data.aws_caller_identity.self.account_id}.dkr.ecr.ap-northeast-1.amazonaws.com/sbcntr-base:log-router"
      memoryReservation = 128,
      cpu               = 64
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group : aws_cloudwatch_log_group.ecs_firelens.name,
          awslogs-region : "ap-northeast-1",
          awslogs-stream-prefix : "firelens"
        }
      },
      firelensConfiguration = {
        type = "fluentbit",
        options = {
          config-file-type  = "file",
          config-file-value = "/fluent-bit/custom.conf"
        }
      },
      environment = [
        {
          name : "APP_ID"
          value : "api-def"
          }, {
          name : "AWS_ACCOUNT_ID"
          value : "${data.aws_caller_identity.self.account_id}"
          }, {
          name : "AWS_REGION"
          value : "ap-northeast-1"
          }, {
          name : "LOG_BUCKET_NAME"
          value : "${var.env}-${var.service}-${data.aws_caller_identity.self.account_id}"
          }, {
          name : "LOG_GROUP_NAME"
          value : "/ecs/${var.env}-${var.service}-api-def"
        }
      ],
    }
  ])
}
