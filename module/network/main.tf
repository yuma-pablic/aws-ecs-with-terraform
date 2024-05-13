# Resourceブロックで「aws_vpc」を指定してVPCを作成
resource "aws_vpc" "this" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    Name = "sbcntrVpc"
  }
}


