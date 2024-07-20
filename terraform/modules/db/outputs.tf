output "rds_cluster_arn" {
  description = "The ARN of the RDS cluster"
  value       = aws_secretsmanager_secret.rds_cluster_arn.arn
}

output "aws_rds_db_password_arn" {
  value = aws_rds_cluster.db.master_user_secret[0].secret_arn
}
