#コンテナアプリ用のプライベートサブネット
resource "aws_subnet" "sbcntr-subnet-private-container-1a" {
  vpc_id            = aws_vpc.sbcntrVpc.id
  cidr_block        = "10.0.8.0/24"
  availability_zone = "ap-northeast-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "sbcntr-subnet-private-container-1a"
    Type = "Isolated"
  }
}


resource "aws_subnet" "sbcntr-subnet-private-container-1c" {
  vpc_id            = aws_vpc.sbcntrVpc.id
  cidr_block        = "10.0.9.0/24"
  availability_zone = "ap-northeast-1c"
  map_public_ip_on_launch = false
  tags = {
    Name = "sbcntr-subnet-private-container-1c"
    Type = "Isolated"
  }
}