resource "null_resource" "ecspresso" {
  triggers = {
    cluster            = aws_ecs_cluster.api.name,
    execution_role_arn = aws_iam_role.ecs_task_execution.arn,
    target_group_blue  = var.tg_blue,
  }
  provisioner "local-exec" {
    command     = "ecspresso deploy --no-wait"
    working_dir = var.ecspress_env_dir
    environment = {
      ECS_CLUSTER        = aws_ecs_cluster.api.name,
      EXECUTION_ROLE_ARN = aws_iam_role.ecs_task_execution.arn
    }
  }

  provisioner "local-exec" {
    command     = "ecspresso scale --tasks 0 && ecspresso delete --force"
    working_dir = "../../../api/deploy"
    when        = destroy
  }
}
