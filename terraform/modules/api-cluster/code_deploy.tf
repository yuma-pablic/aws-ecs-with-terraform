resource "aws_codedeploy_app" "api" {
  compute_platform = "ECS"
  name             = "AppECS-${var.env}-${var.service}-api-cluster-sbcntr-backend-service"
}
resource "aws_codedeploy_deployment_group" "api" {
  depends_on = [
    aws_iam_role.ecs_code_deploy,
    aws_ecs_cluster.api,
  ]
  app_name               = aws_codedeploy_app.api.name
  deployment_group_name  = "DgpECS-${var.env}-${var.service}-api-cluster-sbcntr-backend-service"
  service_role_arn       = aws_iam_role.ecs_code_deploy.arn
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
  ecs_service {
    cluster_name = aws_ecs_cluster.api.name
    service_name = "sbncntr-backend-service"
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

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [var.listener_blue]
      }
      test_traffic_route {
        listener_arns = [var.listener_green]
      }
      target_group {
        name = var.tg_blue
      }
      target_group {
        name = var.tg_green
      }
    }
  }
}
