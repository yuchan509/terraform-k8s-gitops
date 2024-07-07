module "nlb" {
  source = "terraform-aws-modules/alb/aws"

  name               = "${var.elb_name}-nlb"
  load_balancer_type = "network"
  vpc_id             = var.vpc_id
  subnet_mapping     = [for id in var.public_subnet_ids :
                        {
                          allocation_id = var.eip_allocation_ids[id]
                          subnet_id     = id
                        }
                      ]
  # enable_deletion_protection = false
  enforce_security_group_inbound_rules_on_private_link_traffic = "off"
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  
  security_group_ingress_rules = {
    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      description = "HTTP web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
    all_https = {
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      description = "HTTPS web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  listeners = {
    http = {
      port = 80
      protocol = "TCP"
      forward = {
        target_group_key = "alb-tg-80"
      }
    }

    https = {
      port = 443
      protocol = "TCP"
      forward         = {
        target_group_key = "alb-tg-443"
      }
    }
  }

  target_groups = {
    alb-tg-80 = {
      name_prefix = "${var.target_prefix}-"
      protocol    = "TCP"
      port        = 80
      target_type = "alb"

      health_check = {
        enabled             = true
        healthy_threshold   = 5
        interval            = 30
        matcher             = "200"
        path                = "/"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = 5
        unhealthy_threshold = 2
    }

      create_attachment = false
    }

    alb-tg-443 = {
      name_prefix = "${var.target_prefix}-"
      protocol    = "TCP"
      port        = 443
      target_type = "alb"

      health_check = {
        enabled             = true
        healthy_threshold   = 5
        interval            = 30
        matcher             = "200"
        path                = "/"
        port                = "traffic-port"
        protocol            = "HTTPS"
        timeout             = 5
        unhealthy_threshold = 2
      }

      create_attachment = false
    }
  }

  tags = var.tags
}