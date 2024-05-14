resource "aws_iam_instance_profile" "sbcntr-cloud9-role-profile" {
  name = "sbcntr-cloud9-role-profile"
  role = aws_iam_role.sbcntr-cloud9-role.name
}
