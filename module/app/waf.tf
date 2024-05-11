resource "aws_wafv2_web_acl_association" "waf-alb-front-association" {
  resource_arn = aws_alb.sbcntr-alb-frontend.arn
  web_acl_arn  = aws_wafv2_web_acl.sbcntr-waf-webacl.arn
}