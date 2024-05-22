output "backend-ecs-cluster" {
  description = "The name of the ECS cluster"
  value       = aws_ecs_cluster.backend
}
output "backend-ecs-service" {
  description = "The name of the ECS service"
  value       = aws_ecs_service.backend
}
