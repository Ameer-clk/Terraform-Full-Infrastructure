resource "aws_lb" "k8s-alb" {
  client_keep_alive = "3600"

  connection_logs {
    enabled = "false"
    bucket = "project636testing" #Place the bucket name for collecting the logs
  }

  desync_mitigation_mode                      = "defensive"
  drop_invalid_header_fields                  = "false"
  enable_cross_zone_load_balancing            = "true"
  enable_deletion_protection                  = "true"
  enable_http2                                = "true"
  enable_tls_version_and_cipher_suite_headers = "false"
  enable_waf_fail_open                        = "false"
  enable_xff_client_port                      = "false"
  enable_zonal_shift                          = "false"
  idle_timeout                                = "60"
  internal                                    = "false"
  ip_address_type                             = "ipv4"
  load_balancer_type                          = "application"
  name                                        = "k8s-alb"
  preserve_host_header                        = "false"
  security_groups                             = [""] # Security group of k8

  subnet_mapping {
    subnet_id = "" # Repalce with the subnet id for mapping
  }

  subnet_mapping {
    subnet_id = ""
  }

  subnet_mapping {
    subnet_id = ""
  }

  tags = {
    "elbv2.k8s.aws/cluster"    = "project636-eks-beta"
    "ingress.k8s.aws/resource" = "LoadBalancer"
    "ingress.k8s.aws/stack"    = "common-ingress-group"
  }

  tags_all = {
    "elbv2.k8s.aws/cluster"    = "project636-eks-beta"
    "ingress.k8s.aws/resource" = "LoadBalancer"
    "ingress.k8s.aws/stack"    = "common-ingress-group"
  }

  xff_header_processing_mode = "append"
}

