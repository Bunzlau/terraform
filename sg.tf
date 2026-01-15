locals {
    alb_name_sg = "${var.environment}-${var.alb_security_group}"

    common_tags_sg = {
        Project     = var.project_name
        Environment = var.environment
    }
}

resource "aws_security_group" "alb_sg" {
  name        =  var.alb_security_group
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP from anywhere"
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidrs
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = var.egress_cidrs
  }
  tags = merge(local.common_tags_sg,{
    Name = local.alb_name_sg
  })
}

resource "aws_security_group" "ec2_sg" {
  name        =  var.ec2_security_group
  description = "Allow traffic from ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP from ALB"
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    description = "SSH from Your IP"
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = var.ssh_allowed_cidrs
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = var.egress_cidrs

  }
}

resource "aws_lb_target_group" "tg" {
  name = var.tg_name
  port = var.http_port
  protocol = var.alb_protocol
  vpc_id = aws_vpc.main.id

  health_check {
    path = var.health_check_path
    port = var.http_port_string
  }

  tags = {
    Name = var.tg
  }
}

resource "aws_lb_target_group_attachment" "az1" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.ec2_az1.id
  port             = var.http_port
}

resource "aws_lb_target_group_attachment" "az2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.ec2_z2.id
  port             = var.http_port
}