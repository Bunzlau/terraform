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
    type = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
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
