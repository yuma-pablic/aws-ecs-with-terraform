resource "aws_ecs_cluster" "api" {
  name = "${var.env}-${var.service}-api-cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_cluster_capacity_providers" "api" {
  cluster_name       = aws_ecs_cluster.api.name
  capacity_providers = [var.env == "prod" || var.env == "stg" ? "FARGATE" : "FARGATE_SPOT"]
  default_capacity_provider_strategy {
    capacity_provider = var.env == "prod" || var.env == "stg" ? "FARGATE" : "FARGATE_SPOT"
  }
}
