module "alb" {
  source  = "terraform-aws-modules/alb/aws"

  name               = "${var.lb_name}-alb"
  load_balancer_type = "application"
  vpc_id             = var.vpc_id
  subnets            = var.public_subnets

  enable_deletion_protection = false
  enforce_security_group_inbound_rules_on_private_link_traffic = "off"

  security_group_ingress_rules = {
    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      description = "HTTP web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = var.vpc_cidr_block
    }
  }

  listeners = {
    http = {
      port     = 80
      protocol = "HTTP"

      forward = {
        target_group_key = "esc-beta-alb"
      }
    }
  }

  target_groups = {
    esc-beta-alb = {
      backend_protocol                  = "HTTP"
      backend_port                      = var.container_svc_name_01_port
      target_type                       = "ip"
      deregistration_delay              = 5
      load_balancing_cross_zone_enabled = true

      health_check = {
        enabled             = true
        healthy_threshold   = 5 
        interval            = 60
        matcher             = "200-499"
        path                = "/explore"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = 59
        unhealthy_threshold = 2
      }

      create_attachment = false
    }
  }

  tags = var.tags
}
