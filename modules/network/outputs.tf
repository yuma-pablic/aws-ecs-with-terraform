output "vpc_id" {
  value = aws_vpc.main.id
}
output "vpce_sg" {
  value = aws_security_group.vpce.id
}

output "sg_api_id" {
  value = aws_security_group.api.id
}
output "sg_web_id" {
  value = aws_security_group.web.id
}

output "sg_management_id" {
  value = aws_security_group.management.id
}

output "sb_private_egress_1a_id" {
  value = aws_subnet.private_egress_1a.id
}

output "sb_private_egress_1c_id" {
  value = aws_subnet.private_egress_1c.id
}

output "tg_blue_api_name" {
  value = aws_lb_target_group.api_blue.name
}

output "tg_green_api_name" {
  value = aws_lb_target_group.api_green.name
}

output "alb_web_arn" {
  value = aws_alb.web.arn
}

output "db_sb_group_id" {
  value = aws_db_subnet_group.default.id
}

output "sg_db_subnet" {
  value = aws_security_group.db.id
}
