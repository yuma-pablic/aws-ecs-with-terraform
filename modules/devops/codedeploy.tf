resource "aws_codedeploy_app" "api" {
  compute_platform = "ECS"
  name             = "${var.env}-${var.service}-api"
}
resource "aws_codedeploy_deployment_group" "api" {
  depends_on = [
    aws_iam_role.ecs_codedeploy,
    aws_ecs_cluster.api.name,
  ]
  app_name               = "${var.env}-${var.service}-api"
  deployment_group_name  = "${var.env}-${var.service}-api"
  service_role_arn       = aws_iam_role.ecs_codedeploy.arn
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
    cluster_name = module.aws_ecs_cluster.api.name
    service_name = module.aws_ecs_service.api.name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [aws_lb_listener.blue.arn]
      }
      target_group {
        name = module.aws_lb_target_group.sbcntr-tg-blue.name
      }
      target_group {
        name = module.aws_lb_target_group.sbcntr-tg-green.name
      }
    }
  }
}
