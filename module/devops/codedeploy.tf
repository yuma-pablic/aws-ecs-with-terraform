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
    cluster_name = module.aws_ecs_cluster.sbcntr-backend-cluster-name
    service_name = module.aws_ecs_service.sbcntr-ecs-backend-service-name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [aws_lb_listener.sbcntr-lisner-blue.arn]
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
