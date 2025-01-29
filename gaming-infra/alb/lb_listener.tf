# HTTP listener for the application loadbalancer
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.k8s-alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
  }
}

# HTTPS listener for the application loadbalancer
resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.k8s-alb.arn 
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.example.arn 
  default_action {
    type             = "forward"
  }
}
