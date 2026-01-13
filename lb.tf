resource "aws_lb" "alb" {
  name = var.alb_name
  load_balancer_type = var.alb_type
  //internal znaczy czy ALB bedzie mial publiczny IP czy nie
  internal = var.alb_internal

  subnets = [
    aws_subnet.public_az1.id,
    aws_subnet.public_az2.id]

  security_groups = [aws_security_group.alb_sg.id]
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