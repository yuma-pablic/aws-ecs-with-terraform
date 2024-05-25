output "vpd_id" {
  value = aws_vpc.this.id
}
output "vpce_sg" {
  value = aws_security_group.vpce.id
}

output "sg_api_id" {
  value = aws_security_group.backend.id
}
output "sg_web_id" {
  value = aws_security_group.front_container.id
}

output "sg_management_id" {
  value = aws_security_group.management.id
}

output "subnet_private_egress_1a_id" {
  value = aws_subnet.private_egress_1a.id
}

output "subnet_private_egress_1c_id" {
  value = aws_subnet.private_egress_1c.id
}

output "tg_blue_name" {
  value = aws_lb_target_group.blue.name
}

output "tg_green_name" {
  value = aws_lb_target_group.green.name
}

output "alb_web_arn" {
  value = aws_alb.frontend.arn
}

output "db_subnet_group_id" {
  value = aws_db_subnet_group.default.id
}
