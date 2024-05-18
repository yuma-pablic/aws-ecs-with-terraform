output "aws_ecs_cluster-sbcntr-backend-cluster-name" {
  description = "The name of the ECS cluster"
  value       = aws_ecs_cluster.sbcntr-backend-cluster
}
output "aws_ecs_service-sbcntr-ecs-backend-service-name" {
  description = "The name of the ECS service"
  value       = aws_ecs_service.sbcntr-ecs-backend-service.name
}
