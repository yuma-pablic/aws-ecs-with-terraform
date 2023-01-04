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
      image  = ""
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
          awslogs-group : "/ecs/{task-definition-name}"
          awslogs-region : "ap-northeast-1"
          awslogs-stream-prefix : "ecs"
        }
      }
    }
  ])
}
