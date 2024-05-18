
resource "aws_ecs_cluster" "backend" {
  name = "sbcntr-backend-cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}
resource "aws_ecs_cluster_capacity_providers" "backend" {
  cluster_name       = aws_ecs_cluster.backend.name
  capacity_providers = ["FARGATE"]
  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
  }
}
resource "aws_ecs_service" "backend" {
  depends_on                         = [aws_lb_listener.sbcntr-lisner-blue, aws_lb_listener.sbcntr-lisner-green]
  name                               = "sbcntr-ecs-backend-service"
  cluster                            = aws_ecs_cluster.backend.id
  platform_version                   = "LATEST"
  task_definition                    = aws_ecs_task_definition.backend.arn
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
    target_group_arn = aws_lb_target_group.blue.arn
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

resource "aws_ecs_task_definition" "backend" {
  family                   = "sbcntr-backend-def"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = aws_iam_role.ecs-backend-extension-role.arn
  task_role_arn            = aws_iam_role.sbcntr-ecsTaskRole.arn
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
          awslogs-group : aws_cloudwatch_log_group.ecs-sbcntr-firelens-log-group.name,
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
          value : "backend-def"
          }, {
          name : "AWS_ACCOUNT_ID"
          value : "${data.aws_caller_identity.self.account_id}"
          }, {
          name : "AWS_REGION"
          value : "ap-northeast-1"
          }, {
          name : "LOG_BUCKET_NAME"
          value : "sbcntr-${data.aws_caller_identity.self.account_id}"
          }, {
          name : "LOG_GROUP_NAME"
          value : "/ecs/sbcntr-backend-def"
        }
      ],
    }
  ])
}
