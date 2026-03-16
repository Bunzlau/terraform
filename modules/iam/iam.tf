locals {
  common_tags_iam = {
    Project     = var.project_name
    Environment = var.environment
  }

}

resource "aws_iam_role" "ec2_secret_role" {
  name = "EC2-Secrets-Access-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(local.common_tags_iam, {
    Name = "${var.project_name}-${var.environment}-ec2-role"
  })
}