output "api_ecs_cluster" {
  description = "The name of the ECS cluster"
  value       = aws_ecs_cluster.api
}
output "api_ecs_service" {
  description = "The name of the ECS service"
  value       = aws_ecs_service.api
}
