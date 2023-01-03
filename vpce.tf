# ECRからImageを取得する用
resource "aws_vpc_endpoint" "sbcntr-vpce-ecr-api" {
    vpc_id          = aws_vpc.sbcntrVpc
    service_name    = "com.amazonaws.apnortheast-1.ecr.api"
    private_dns_enabled = true
    vpc_endpoint_type = "Interface"
}

resource "aws_vpc_endpoint" "sbcntr-vpce-ecr-dkr" {
    vpc_id = aws_vpc.sbcntrVpc
    service_name = "com.amazonaws.apnortheast-1.ecr.dkr"
    private_dns_enabled = true
    vpc_endpoint_type = "Interface"
}

resource "aws_vpc_endpoint" "sbcntr-vpce-ecr-s3" {
    vpc_id =  aws_vpc.sbcntrVpc
    service_name = "com.amazonaws.apnortheast-1.s3"
    vpc_endpoint_type = "Gateway"
}

#Cloud watch logsにデータを送信する用
#Secrets Manegerを参照する用