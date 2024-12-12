resource "aws_lb_listener_certificate" "example" {
  listener_arn    = aws_lb_listener.example_https.arn # Add the certificate ARN
  certificate_arn = aws_acm_certificate.example.arn
}
