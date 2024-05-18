output "aws_ecs_cluster-sbcntr-backend-cluster-name" {
  description = "The name of the ECS cluster"
  value       = aws_ecs_cluster.backend
}
output "aws_ecs_service_backend_name" {
  description = "The name of the ECS service"
  value       = aws_ecs_service.backend.name
}
