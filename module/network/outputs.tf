output "vpd_id" {
  value = aws_vpc.this.id
}
output "vpce_sg" {
  value = aws_security_group.vpce.id
}

output "sg-backend-id" {
  value = aws_security_group.backend.id
}
output "sg-frontend-id" {
  value = aws_security_group.front_container.id
}

output "sg-management-id" {
  value = aws_security_group.management.id
}

output "subnet-private-egress-1a-id" {
  value = aws_subnet.private_egress_1a.id
}

output "subnet-private-egress-1c-id" {
  value = aws_subnet.private_egress_1c.id
}

output "aws_lb_target_group.sbcntr-tg-blue.name" {
  value = aws_lb_target_group.blue.name
}

output "aws_lb_target_group.sbcntr-tg-green.name" {
  value = aws_lb_target_group.green.name
}

output "sbcntr-alb-front-arn" {
  value = aws_alb.frontend.arn
}
