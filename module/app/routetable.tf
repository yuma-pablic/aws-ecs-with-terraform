#コンテナアプリ用のルートテーブル
resource "aws_route_table" "sbcntr-route-app" {
  vpc_id = var.vpc_id
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

#Ingress用のルートテーブル
resource "aws_route_table" "sbcntr-route-ingress" {
  vpc_id = var.vpc_id
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

## Ingress用ルートテーブルのデフォルトルート
resource "aws_route" "PublicRouteTable_Connect_InternetGateway" {
  route_table_id         = aws_route_table.sbcntr-route-ingress.id
  destination_cidr_block = "0.0.0.0/0" # internet_gatewayの外への通信許可設定
  gateway_id             = aws_internet_gateway.sbcntr-igw.id
}

## 管理用サブネットのルートはIngressと同様として作成する
resource "aws_route_table_association" "public-management-1a" {
  subnet_id      = aws_subnet.sbcntr-subnet-public-management-1a.id
  route_table_id = aws_route_table.sbcntr-route-ingress.id
}

resource "aws_route_table_association" "public-management-1c" {
  subnet_id      = aws_subnet.sbcntr-subnet-public-management-1c.id
  route_table_id = aws_route_table.sbcntr-route-ingress.id
}

