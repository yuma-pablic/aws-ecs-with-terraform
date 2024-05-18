resource "aws_alb" "internal" {
  name            = "sbcntr-alb-internal"
  internal        = true
  security_groups = [aws_security_group.sbcntr-sg-internal.id]
  subnets = [
    aws_subnet.sbcntr-subnet-private-container-1a.id,
    aws_subnet.sbcntr-subnet-private-container-1c.id,
  ]
}

resource "aws_lb_target_group" "blue" {
  name        = "sbcntr-backend-tg-blue"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  tags = {
    Name = "sbcntr-tg-blue"
  }
  health_check {
    protocol            = "HTTP"
    path                = "/healthcheck"
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 15
    matcher             = 200
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group" "green" {
  name        = "sbcntr-backend-tg-green"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  tags = {
    "Name" = "sbcntr-tg-green"
  }
  health_check {
    protocol            = "HTTP"
    path                = "/healthcheck"
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 15
    matcher             = 200
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "blue" {
  load_balancer_arn = aws_alb.internal.id
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.id
  }
}

resource "aws_lb_listener" "green" {
  load_balancer_arn = aws_alb.internal.id
  port              = 10080
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.green.id
  }
}

resource "aws_alb" "frontend" {
  name            = "sbcntr-alb-frontend"
  internal        = false
  security_groups = [aws_security_group.sbcntr-sg-ingress.id]
  subnets = [
    aws_subnet.sbcntr-subnet-public-ingress-1a.id,
    aws_subnet.sbcntr-subnet-public-ingress-1c.id,
  ]
}

resource "aws_lb_target_group" "frontend" {
  name        = "sbcntr-tg-frontend"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    protocol            = "HTTP"
    path                = "/healthcheck"
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 15
    matcher             = 200
  }
}

resource "aws_lb_listener" "frontend" {
  load_balancer_arn = aws_alb.frontend.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.id
  }
}
