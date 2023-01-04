#コンテナアプリ用のプライベートサブネット
resource "aws_subnet" "sbcntr-subnet-private-container-1a" {
  vpc_id                  = aws_vpc.sbcntrVpc.id
  cidr_block              = "10.0.8.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "sbcntr-subnet-private-container-1a"
    Type = "Isolated"
  }
}


resource "aws_subnet" "sbcntr-subnet-private-container-1c" {
  vpc_id                  = aws_vpc.sbcntrVpc.id
  cidr_block              = "10.0.9.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = false
  tags = {
    Name = "sbcntr-subnet-private-container-1c"
    Type = "Isolated"
  }
}


#DB用プライベートサブネット
resource "aws_subnet" "sbcntr-subnet-private-db-1a" {
  vpc_id                  = aws_vpc.sbcntrVpc.id
  cidr_block              = "10.0.16.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "sbcntr-subnet-private-db-1a"
    Type = "Isolated"
  }
}

resource "aws_subnet" "sbcntr-subnet-private-db-1c" {
  vpc_id                  = aws_vpc.sbcntrVpc.id
  cidr_block              = "10.0.17.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = false
  tags = {
    Name = "sbcntr-subnet-private-db-1c"
    Type = "Isolated"
  }
}

#Ingress用のパブリックサブネット
resource "aws_subnet" "sbcntr-subnet-public-ingress-1a" {
  vpc_id                  = aws_vpc.sbcntrVpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "sbcntr-subnet-public-ingress-1a"
    Type = "public"
  }
}

resource "aws_subnet" "sbcntr-subnet-public-ingress-1c" {
  vpc_id                  = aws_vpc.sbcntrVpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true
  tags = {
    Name = "sbcntr-subnet-public-ingress-1c"
    Type = "public"
  }
}

## 管理サーバ用のサブネット
resource "aws_subnet" "sbcntr-subnet-public-management-1a" {
  vpc_id                  = aws_vpc.sbcntrVpc.id
  cidr_block              = "10.0.240.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "sbcntr-subnet-public-management-1a"
    Type = "Public"
  }
}

resource "aws_subnet" "sbcntr-subnet-public-management-1c" {
  vpc_id                  = aws_vpc.sbcntrVpc.id
  cidr_block              = "10.0.241.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true
  tags = {
    Name = "sbcntr-subnet-public-management-1c"
    Type = "Public"
  }
}

## VPC Endpoint用のサブネット
resource "aws_subnet" "sbcntr-subnet-private-egress-1a" {
  vpc_id                  = aws_vpc.sbcntrVpc.id
  cidr_block              = "10.0.248.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "sbcntr-subnet-private-egress-1a"
    Type = "Isolated"
  }
}

resource "aws_subnet" "sbcntr-subnet-private-egress-1c" {
  vpc_id                  = aws_vpc.sbcntrVpc.id
  cidr_block              = "10.0.249.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = false
  tags = {
    Name = "sbcntr-subnet-private-egress-1c"
    Type = "Isolated"
  }
}