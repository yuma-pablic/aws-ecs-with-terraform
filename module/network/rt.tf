#コンテナアプリ用のルートテーブル
resource "aws_route_table" "sbcntr-route-app" {
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.env}-${var.service}-route-app"
  }
}

#コンテナアプリ用サブネットルート紐付け
resource "aws_route_table_association" "private_1a" {
  subnet_id      = aws_subnet.private_container_1a.id
  route_table_id = aws_route_table.sbcntr-route-app.id
}

resource "aws_route_table_association" "private_1c" {
  subnet_id      = aws_subnet.private_container_1c.id
  route_table_id = aws_route_table.sbcntr-route-app.id
}

#Ingress用のルートテーブル
resource "aws_route_table" "route_ingress" {
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.env}-${var.service}-route-ingress"
  }
}
## Ingressサブネットへルート紐付け
resource "aws_route_table_association" "public_ingress_1a" {
  subnet_id      = aws_subnet.public_ingress_1a.id
  route_table_id = aws_route_table.route_ingress.id
}

resource "aws_route_table_association" "public_ingress_1c" {
  subnet_id      = aws_subnet.public_ingress_1c.id
  route_table_id = aws_route_table.route_ingress.id
}

## Ingress用ルートテーブルのデフォルトルート
resource "aws_route" "public_route_table_connect_internet_gateway" {
  route_table_id         = aws_route_table.route_ingress.id
  destination_cidr_block = "0.0.0.0/0" # internet_gatewayの外への通信許可設定
  gateway_id             = aws_internet_gateway.igw.id
}

## 管理用サブネットのルートはIngressと同様として作成する
resource "aws_route_table_association" "public_management_1a" {
  subnet_id      = aws_subnet.public_management_1a.id
  route_table_id = aws_route_table.route_ingress.id
}

resource "aws_route_table_association" "public_management_1c" {
  subnet_id      = aws_subnet.public_management_1c.id
  route_table_id = aws_route_table.route_ingress.id
}
