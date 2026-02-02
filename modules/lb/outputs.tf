output "alb_dns_name" {
  value       = aws_lb.alb.dns_name
  description = "DNS name of the created Application Load Balancer"
}

output "alb_arn" {
  value       = aws_lb.alb.arn
  description = "ARN of the created Application Load Balancer"
}

output "target_group_arn" {
  value       = aws_lb_target_group.tg.arn
  description = "ARN of the ALB target group"
}

output "target_group_name" {
  value       = aws_lb_target_group.tg.name
  description = "Name of the ALB target group"
}

output "certificate_arn" {
  description = "ARN of the ACM certificate"
  value = aws_acm_certificate.cert.arn
}

output "certificate_arn_www" {
    description = "ARN of the ACM certificate for www domain"
    value = aws_acm_certificate.cert_www.arn
}