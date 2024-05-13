

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


resource "aws_iam_role_policy_attachment" "ecs-frontend-extension-role-attachement" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecs-frontend-extension-role.id
}

resource "aws_iam_role_policy_attachment" "ecs-frontend-extension-role-attachement-secrets" {
  policy_arn = aws_iam_policy.sbcntr-getting-secrets-policy.arn
  role       = aws_iam_role.ecs-frontend-extension-role.id
}
