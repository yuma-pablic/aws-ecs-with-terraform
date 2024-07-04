resource "aws_iam_instance_profile" "cloud9_role" {
  name = "${var.env}-${var.service}-cloud9-role-profile"
  role = aws_iam_role.cloud9.name
}
