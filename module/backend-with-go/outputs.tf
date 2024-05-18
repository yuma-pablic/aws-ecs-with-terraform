output "aws_ecs_cluster-sbcntr-backend-cluster-name" {
  value = aws_ecs_cluster.sbcntr-backend-cluster.name
}
output "aws_ecs_service-sbcntr-ecs-backend-service-name" {
  value = aws_ecs_service.sbcntr-ecs-backend-service.name
}
