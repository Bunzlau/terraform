terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.54.1"
    }
  }
}
locals {
    alb_name_lb = "${var.environment}-${var.alb_name}"
    tg_name = "${var.environment}-${var.target_group_name}"

    common_tags_tf = {
        Project     = var.project_name
        Environment = var.environment
    }
}
resource "aws_lb" "alb" {
  name = var.alb_name
  load_balancer_type = var.alb_type
  internal = var.alb_internal
  subnets = var.subnet_ids
  security_groups = var.security_group_ids

    tags = merge(local.common_tags_tf, {
        Name = local.alb_name_lb
    })
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port = var.http_port
  protocol = var.alb_protocol

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
    load_balancer_arn = aws_lb.alb.arn
    port = 443
    protocol = "HTTPS"
    ssl_policy = "ELBSecurityPolicy-TLS-1-2-Res-PQ-2025-09"

    certificate_arn = aws_acm_certificate.cert.arn

    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.tg.arn
    }
}


resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  tags = merge(local.common_tags_tf, {
    Name = "${var.environment}-acm-cert"
  })
}

resource "aws_acm_certificate" "cert_www" {
    domain_name       = var.domain_name_www
    validation_method = "DNS"

    tags = merge(local.common_tags_tf, {
        Name = "${var.environment}-acm-cert-www"
    })

}

resource "aws_lb_target_group" "tg" {
  name = local.tg_name
  port = var.http_port
  protocol = var.alb_protocol
  vpc_id = var.vpc_id

  health_check {
    path = var.health_check_path
    port = var.http_port_string
  }

  tags = {
    Name = var.tg
  }
}

resource "aws_lb_target_group_attachment" "ec2_attachment_z1" {

  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = var.ec2_instance_z1_id
}

resource "aws_lb_target_group_attachment" "ec2_attachment_z2" {

  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = var.ec2_instance_z2_id
}