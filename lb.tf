locals {
    alb_name = "${var.environment}-${var.alb_name}"
    tg_name = "${var.environment}-${var.target_group_name}"

    common_tags = {
        Project     = var.project_name
        Environment = var.environment
    }
}
resource "aws_lb" "alb" {
  name = var.alb_name
  load_balancer_type = var.alb_type
  //internal znaczy czy ALB bedzie mial publiczny IP czy nie
  internal = var.alb_internal

  subnets = [
    aws_subnet.public_az1.id,
    aws_subnet.public_az2.id]

  security_groups = [aws_security_group.alb_sg.id]

    tags = merge(local.common_tags, {
        Name = local.alb_name
    })
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port = var.http_port
  protocol = var.alb_protocol

  // definiujemy co ma sie stac z ruchem przychodzacym na listenera
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}