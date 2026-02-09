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
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from anywhere"
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidrs
  }

  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
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
  vpc_id      = var.vpc_id

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
resource "aws_security_group" "efs_sg" {
  name = "ef-sg-${var.environment}"
  description = "Security group for EFS"
  vpc_id = var.vpc_id

  ingress  {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }

    egress {
        from_port = 0
        to_port   = 0
        protocol  = "-1"
        cidr_blocks = var.egress_cidrs
    }

  tags = {
    Name = "efs-sg-${var.environment}"
  }
}
