#コンテナアプリ用のルートテーブル
resource "aws_route_table" "sbcntr-route-app" {
  vpc_id            = aws_vpc.sbcntrVpc.id
  tags = {
    Name = "sbcntr-route-app"
  }
}

#コンテナアプリ用サブネットルート紐付け
resource "aws_route_table_association" "private-1a" {
  subnet_id      = aws_subnet.sbcntr-subnet-private-container-1a.id
  route_table_id = aws_route_table.sbcntr-route-app.id
}

resource "aws_route_table_association" "private-1c" {
  subnet_id      = aws_subnet.sbcntr-subnet-private-container-1c.id
  route_table_id = aws_route_table.sbcntr-route-app.id
}

# DB用ルートテーブル
resource "aws_route_table" "sbcntr-route-db" {
  vpc_id            = aws_vpc.sbcntrVpc.id
  tags = {
    Name = "sbcntr-route-db"
  }
}

#コンテナアプリ用サブネットルート紐付け
resource "aws_route_table_association" "private-db-1a" {
  subnet_id      = aws_subnet.sbcntr-subnet-private-db-1a.id
  route_table_id = aws_route_table.sbcntr-route-db.id
}

resource "aws_route_table_association" "private-db-1c" {
  subnet_id      = aws_subnet.sbcntr-subnet-private-db-1c.id
  route_table_id = aws_route_table.sbcntr-route-db.id
}


#Ingress用のルートテーブル
resource "aws_route_table" "sbcntr-route-ingress" {
  vpc_id            = aws_vpc.sbcntrVpc.id
  tags = {
    Name = "sbcntr-route-ingress"
  }
}
## Ingressサブネットへルート紐付け
resource "aws_route_table_association" "public-ingress-1a" {
  subnet_id      = aws_subnet.sbcntr-subnet-public-ingress-1a.id
  route_table_id = aws_route_table.sbcntr-route-ingress.id
}

resource "aws_route_table_association" "public-ingress-1c" {
  subnet_id      = aws_subnet.sbcntr-subnet-public-ingress-1c.id
  route_table_id = aws_route_table.sbcntr-route-ingress.id
}



