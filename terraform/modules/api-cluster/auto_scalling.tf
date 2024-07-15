resource "aws_appautoscaling_target" "appautoscaling_ecs_target" {
  service_namespace  = "ecs"
  resource_id        = "sbcntr-api-service"
  scalable_dimension = "ecs:service:DesiredCount"

  role_arn = data.aws_iam_role.ecs_service_autoscaling.arn

  min_capacity = 2
  max_capacity = 4
}

resource "aws_appautoscaling_policy" "autoscaling_scale_up" {
  name              = "${var.env}-${var.service}-scale-up"
  service_namespace = "ecs"

  resource_id        = "sbcntr-api-service"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 120
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }
}

# サーバ台数減少設定
resource "aws_appautoscaling_policy" "appautoscaling_scale_down" {
  name              = "${var.env}-${var.service}-scale-down"
  service_namespace = "ecs"

  resource_id        = "sbcntr-api-service"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 120
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = -1
    }
  }
}
