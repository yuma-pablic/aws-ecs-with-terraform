resource "aws_iam_instance_profile" "sbcntr-cloud9-role-profile" {
  name = "sbcntr-cloud9-role-profile"
  role = aws_iam_role.sbcntr-cloud9-role.name
}

resource "aws_iam_role" "ecs-backend-extension-role" {
  name = "ecsBackendTaskExecutionRole"
  assume_role_policy = jsonencode(
    {
      "Version" : "2008-10-17",
      "Statement" : [
        {
          "Sid" : "",
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "ecs-tasks.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
    }
  )
}
