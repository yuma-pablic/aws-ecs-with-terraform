resource "aws_security_group" "sbcntr-sg-ingress" {
    vpc_id = aws_vpc.sbcntrVpc.id
    description = "Security group for ingress"
    name = "ingress"
    tags = {
      "key" = "Name"
      "Value" = "sbcntr-sg-ingress"
    }
}

resource "aws_security_group_rule" "inbaund" {
    type        = "ingress"
    cidr_blocks =[
        "0.0.0.0/0"
    ]
    description = "Allow all outbound traffic by default"
    from_port = 80
    to_port = 80
    protocol = "-1"
    security_group_id = aws_security_group.sbcntr-sg-ingress.id
}

resource "aws_security_group_rule" "egress-v4" {
    type = "egress"
    cidr_blocks = [
        "0.0.0.0/0"
    ]
    description = "from 0.0.0.0/0:80"
    from_port = 80
    protocol = "tcp"
    to_port = 80
    security_group_id = aws_security_group.sbcntr-sg-ingress.id 
}

resource "aws_security_group_rule" "egress-v6" {
    type = "egress"
    cidr_blocks = [
        "::/0"
    ]
    description = "from ::/0:80"
    from_port = 80
    protocol = "tcp"
    to_port = 80
    security_group_id = aws_security_group.sbcntr-sg-ingress.id
}