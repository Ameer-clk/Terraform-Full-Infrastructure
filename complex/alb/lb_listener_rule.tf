resource "aws_lb_listener_rule" "rule_airflow" {
  listener_arn = aws_lb_listener.http_listener.arn  # Correctly referencing the listener ARN
  priority     = 1
  
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.k8-airflow.arn
  }
  
  condition {
    host_header {
      values = [""] #Need to replace the service url of the application
    }
  }
  
  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

resource "aws_lb_listener_rule" "rule_argocd" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 2
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.k8-argocd.arn
  }
  condition {
    path_pattern {
      values = [""]
    }
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

resource "aws_lb_listener_rule" "rule_backoffice" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 3
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.k8-backoffice.arn
  }

  condition {
    path_pattern {
      values = [""]
    }
  }
    condition {
    path_pattern {
      values = ["/*"]
    }
  }
}


resource "aws_lb_listener_rule" "rule_cmsadmin" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 4
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.k8-cmsadmin.arn
  }
  condition {
    path_pattern {
      values = [""]
    }
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}


resource "aws_lb_listener_rule" "rule_cmsapi" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 5
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.k8-cmsapi.arn
  }
  condition {
    path_pattern {
      values = [""]
    }
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

resource "aws_lb_listener_rule" "rule_crmadmin" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 6
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.k8-crmadmin.arn
  }
  condition {
    path_pattern {
      values = [""]
    }
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

resource "aws_lb_listener_rule" "rule_mainfrontend" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 7
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.k8-mainfrontend.arn
  }
  condition {
    path_pattern {
      values = [""]
    }
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}


resource "aws_lb_listener_rule" "rule_owneradmin" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 8
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.k8-owneradmin.arn
  }
  condition {
    path_pattern {
      values = [""]
    }
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

resource "aws_lb_listener_rule" "rule_whitelabel" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 9
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.k8-whitelabel.arn
  }
  condition {
    path_pattern {
      values = [""]
    }
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

resource "aws_lb_listener_rule" "rule_central_provider_socket" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 10
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.k8-central-provider-socket.arn
  }
   condition {
    path_pattern {
      values = [""]
    }
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

resource "aws_lb_listener_rule" "rule_elastic_stack" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 11
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.k8-elastic-stack.arn
  }
   condition {
    path_pattern {
      values = [""]
    }
  }

    condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

resource "aws_lb_listener_rule" "rule_grafana" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 12
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.k8-grafana.arn
  }
   condition {
    path_pattern {
      values = [""]
    }
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}


resource "aws_lb_listener_rule" "rule_owner_api" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 13
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.k8-owner-api.arn
  }
   condition {
    path_pattern {
      values = [""]
    }
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

resource "aws_lb_listener_rule" "rule_pg_admin" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 14
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.k8-pg-admin.arn
  }
   condition {
    path_pattern {
      values = [""]
    }
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}
