resource "aws_lb_target_group" "k8-airflow" {
  name     = "k8-airflow"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "vpc-026cf352a9c7840a0" #Replace with the 
  target_type = "ip"

  health_check {
    interval            = 15
    path                = "/login"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    "Name" = "k8-airflow"
  }
}

resource "aws_lb_target_group_attachment" "k8-airflow-attachment" {
  target_group_arn = aws_lb_target_group.k8-airflow.arn
  target_id        = "10.2.0.10" # Place the target id
  port             = 8080
}

resource "aws_lb_target_group" "k8-argocd" {
  name     = "k8-argocd"
  port     = 8080
  protocol = "HTTPS"
  vpc_id   = "vpc-026cf352a9c7840a0" #Add the vpc id here
  target_type = "ip"


  health_check {
    interval            = 15
    path                = "/assets/images/logo.png"
    protocol            = "HTTPS"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    "Name" = "k8-argocd"
  }
}

resource "aws_lb_target_group_attachment" "k8-argocd-attachment" {
  target_group_arn = aws_lb_target_group.k8-argocd.arn
  target_id        = "10.2.0.20"
  port             = 8080
}

resource "aws_lb_target_group" "k8-backoffice" {
  name     = "k8-backoffice"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = "vpc-026cf352a9c7840a0" #Add the vpc id here
  target_type = "ip"


  health_check {
    interval            = 15
    path                = "/"
    protocol            = "HTTPS"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    "Name" = "k8-backoffice"
  }
}

resource "aws_lb_target_group_attachment" "k8-backoffice-attachment" {
  target_group_arn = aws_lb_target_group.k8-backoffice.arn
  target_id        = "10.2.0.30"
  port             = 3000
}

resource "aws_lb_target_group" "k8-cmsadmin" {
  name     = "k8-cmsadmin"
  port     = 4005
  protocol = "HTTP"
  vpc_id   = "vpc-026cf352a9c7840a0" #Add the vpc id here
  target_type = "ip"

  health_check {
    interval            = 15
    path                = "/login"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    "Name" = "k8-cmsadmin"
  }
}

resource "aws_lb_target_group_attachment" "k8-cmsadmin-attachment" {
  target_group_arn = aws_lb_target_group.k8-cmsadmin.arn
  target_id        = "10.2.0.40"
  port             = 4005
}

resource "aws_lb_target_group" "k8-cmsapi" {
  name     = "k8-cmdapi"
  port     = 5000
  protocol = "HTTP"
  vpc_id   = "vpc-026cf352a9c7840a0" #Add the vpc id here
  target_type = "ip"


  health_check {
    interval            = 15
    path                = "/healthcheck"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    "Name" = "k8-cmsapi"
  }
}

resource "aws_lb_target_group_attachment" "k8-cmsapi-attachment" {
  target_group_arn = aws_lb_target_group.k8-cmsapi.arn
  target_id        = "10.2.0.50"
  port             = 5000
}

resource "aws_lb_target_group" "k8-crmadmin" {
  name     = "k8-crmadmin"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "vpc-026cf352a9c7840a0" #Add the vpc id here
  target_type = "ip"

  health_check {
    interval            = 15
    path                = "/login"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    "Name" = "k8-crmadmin"
  }
}

resource "aws_lb_target_group_attachment" "k8-crmadmin-attachment" {
  target_group_arn = aws_lb_target_group.k8-crmadmin.arn
  target_id        = "10.2.0.40"
  port             = 8080
}

resource "aws_lb_target_group" "k8-mainfrontend" {
  name     = "k8-mainfrontend"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = "vpc-026cf352a9c7840a0" #Add the vpc id here
  target_type = "ip"


  health_check {
    interval            = 15
    path                = "/login"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    "Name" = "k8-mainfrontend"
  }
}

resource "aws_lb_target_group_attachment" "k8-mainfrontend-attachment" {
  target_group_arn = aws_lb_target_group.k8-mainfrontend.arn
  target_id        = "10.2.0.60"
  port             = 3000
}

resource "aws_lb_target_group" "k8-owneradmin" {
  name     = "k8-owneradmin"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "vpc-026cf352a9c7840a0" #Add the vpc id here
  target_type = "ip"


  health_check {
    interval            = 15
    path                = "/login"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    "Name" = "k8-owneradmin"
  }
}

resource "aws_lb_target_group_attachment" "k8-owneradmin-attachment" {
  target_group_arn = aws_lb_target_group.k8-owneradmin.arn
  target_id        = "10.2.0.70"
  port             = 8080
}

resource "aws_lb_target_group" "k8-whitelabel" {
  name     = "k8-whitelabel"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "vpc-026cf352a9c7840a0" #Add the vpc id here
  target_type = "ip"


  health_check {
    interval            = 15
    path                = "/login"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    "Name" = "k8-whitelabel"
  }
}

resource "aws_lb_target_group_attachment" "k8-whitelabel-attachment" {
  target_group_arn = aws_lb_target_group.k8-whitelabel.arn
  target_id        = "10.2.0.80"
  port             = 8080
}

resource "aws_lb_target_group" "k8-whitelabel" {
  name     = "k8-whitelabel"
  port     = 4000
  protocol = "HTTP"
  vpc_id   = "vpc-026cf352a9c7840a0" #Add the vpc id here
  target_type = "ip"


  health_check {
    interval            = 15
    path                = "/healthcheck"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    "Name" = "k8-whitelabel"
  }
}

resource "aws_lb_target_group_attachment" "k8-whitelabel-attachment" {
  target_group_arn = aws_lb_target_group.k8-whitelabel.arn
  target_id        = "10.2.0.80"
  port             = 4000
}

resource "aws_lb_target_group" "k8-central-provider-socket" {
  name     = "k8-central-provider-socket"
  port     = 8001
  protocol = "HTTP"
  vpc_id   = "vpc-026cf352a9c7840a0" #Add the vpc id here
  target_type = "ip"


  health_check {
    interval            = 10
    path                = "/healthcheck"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  tags = {
    "Name" = "k8-central-provider-socket"
  }
}

resource "aws_lb_target_group" "k8-central-provider-socket" {
  name     = "k8-central-provider-socket"
  port     = 8000
  protocol = "HTTP"
  vpc_id   = "vpc-026cf352a9c7840a0" #Add the vpc id here
  target_type = "ip"


  health_check {
    interval            = 10
    path                = "/healthcheck"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  tags = {
    "Name" = "k8-central-provider-socket"
  }
}


resource "aws_lb_target_group_attachment" "k8-central-provider-socket-attachment" {
  target_group_arn = aws_lb_target_group.k8-central-provider-socket.arn
  target_id        = "10.2.0.90"
  port             = 8080
}

resource "aws_lb_target_group" "k8-elastic-stack" {
  name     = "k8-elastic-stack"
  port     = 5601
  protocol = "HTTPS"
  vpc_id   = "vpc-026cf352a9c7840a0" #Add the vpc id here
  target_type = "ip"


  health_check {
    interval            = 15
    path                = "/login"
    protocol            = "HTTPS"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    "Name" = "k8-elastic-stack"
  }
}

resource "aws_lb_target_group_attachment" "k8-elastic-stack-attachment" {
  target_group_arn = aws_lb_target_group.k8-elastic-stack.arn
  target_id        = "10.2.0.100"
  port             = 5601
}

resource "aws_lb_target_group" "k8-grafana" {
  name     = "k8-grafana"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = "vpc-026cf352a9c7840a0" #Add the vpc id here
  target_type = "ip"


  health_check {
    interval            = 15
    path                = "/login"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    "Name" = "k8-central-provider-socket"
  }
}

resource "aws_lb_target_group_attachment" "k8-grafana-attachment" {
  target_group_arn = aws_lb_target_group.k8-grafana.arn
  target_id        = "10.2.0.110"
  port             = 3000
}

resource "aws_lb_target_group" "k8-owner-api" {
  name     = "k8-owner-api"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = "vpc-026cf352a9c7840a0" #Add the vpc id here
  target_type = "ip"


  health_check {
    interval            = 15
    path                = "/healthcheck"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  tags = {
    "Name" = "k8-central-provider-socket"
  }
}

resource "aws_lb_target_group_attachment" "k8-owner-api-attachment" {
  target_group_arn = aws_lb_target_group.k8-owner-api.arn
  target_id        = "10.2.0.120"
  port             = 3000
}

resource "aws_lb_target_group" "k8-pg-admin" {
  name     = "k8-pg-admin"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-026cf352a9c7840a0" #Add the vpc id here
  target_type = "ip"


  health_check {
    interval            = 15
    path                = "/login"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    "Name" = "k8-pg-admin"
  }
}

resource "aws_lb_target_group_attachment" "k8-pg-admin-attachment" {
  target_group_arn = aws_lb_target_group.k8-pg-admin.arn
  target_id        = "10.2.0.130"
  port             = 80
}

