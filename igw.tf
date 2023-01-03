# インターネットへ通信するためのゲートウェイの作成
resource "aws_internet_gateway" "sbcntr-igw" {
    vpc_id = aws_vpc.sbcntrVpc.id
    tags ={
        Name = "sbcntr-igw"
    }
}