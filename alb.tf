resource "aws_alb" "sbcntr-alb-internal" {
    name = "sbcntr-alb-internal"
    internal = true
    security_groups =[aws_security_group.sbcntr-sg-internal.id]
    subnets = [
        aws_subnet.sbcntr-subnet-private-container-1a.id, 
        aws_subnet.sbcntr-subnet-private-container-1c.id, 
    ]
}

resource "aws_lb_target_group" "sbcntr-tg-blue" {
    name = "sbcntr-tg-blue"
    port = 80
    protocol  = "HTTP"
    vpc_id = aws_vpc.sbcntrVpc.id
    
    health_check {
        protocol = "http"
        path = "/healthcheck"
        port = "traffic-port"
        healthy_threshold = 3
        unhealthy_threshold = 2
        timeout = 5
        interval = 15
        matcher = 200
    }
}

resource "aws_alb_target_group" "sbcntr-tg-green" {
    name = "sbcntr-tg-green"
    port = 80
    protocol  = "HTTP"
    vpc_id = aws_vpc.sbcntrVpc.id
    health_check {
        protocol = "http"
        path = "/healthcheck"
        port = "traffic-port"
        healthy_threshold = 3
        unhealthy_threshold = 2
        timeout = 5
        interval = 15
        matcher = 200
    }
}

resource "aws_lb_listener" "sbcntr-lisner-blue" {
    load_balancer_arn = aws_alb.sbcntr-alb-internal
    port = 80
    protocol = "http"
    default_action {
      type = "redirect"
      target_group_arn = aws_lb_target_group.sbcntr-tg-blue.id
    }
}

resource "aws_lb_listener" "sbcntr-lisner-green" {
    load_balancer_arn = aws_alb.sbcntr-alb-internal
    port = 10080
    protocol = "http"
    default_action {
      type = "redirect"
      target_group_arn = aws_lb_target_group.sbcntr-tg-green.id
    }
}