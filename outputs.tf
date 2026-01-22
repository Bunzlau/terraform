# VPC Outputs
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "The CIDR block of the VPC (configured variable)"
  value       = var.vpc_cidr
}

# Subnet Outputs
output "public_subnet_az1_id" {
  description = "The ID of the public subnet in AZ1"
  value       = module.vpc.public_subnet_az1_id
}

output "public_subnet_az2_id" {
  description = "The ID of the public subnet in AZ2"
  value       = module.vpc.public_subnet_az2_id
}

output "public_route_table_id" {
  description = "The ID of the created public route table"
  value       = module.vpc.public_route_table_id
}

# Load Balancer Outputs (from module.lb)
output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = module.lb.alb_dns_name
}

output "alb_arn" {
  description = "The ARN of the Application Load Balancer"
  value       = module.lb.alb_arn
}

# Security Group Outputs (from module.sg)
output "alb_security_group_id" {
  description = "The ID of the ALB security group"
  value       = module.sg.alb_sg_id
}

output "ec2_security_group_id" {
  description = "The ID of the EC2 security group"
  value       = module.sg.ec2_sg_id
}

# Application URL built from module.lb output
output "application_url" {
  description = "The URL to access your application through the ALB"
  value       = "http://${module.lb.alb_dns_name}"
}
