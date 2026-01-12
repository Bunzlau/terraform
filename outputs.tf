# VPC Outputs
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

# Subnet Outputs
output "public_subnet_az1_id" {
  description = "The ID of the public subnet in AZ1"
  value       = aws_subnet.public_az1.id
}

output "public_subnet_az2_id" {
  description = "The ID of the public subnet in AZ2"
  value       = aws_subnet.public_az2.id
}

# EC2 Instance Outputs
output "ec2_az1_id" {
  description = "The ID of EC2 instance in AZ1"
  value       = aws_instance.ec2_az1.id
}

output "ec2_az1_public_ip" {
  description = "The public IP of EC2 instance in AZ1"
  value       = aws_instance.ec2_az1.public_ip
}

output "ec2_az2_id" {
  description = "The ID of EC2 instance in AZ2"
  value       = aws_instance.ec2_z2.id
}

output "ec2_az2_public_ip" {
  description = "The public IP of EC2 instance in AZ2"
  value       = aws_instance.ec2_z2.public_ip
}

# Load Balancer Outputs
output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = aws_lb.alb.dns_name
}

output "alb_arn" {
  description = "The ARN of the Application Load Balancer"
  value       = aws_lb.alb.arn
}

output "alb_zone_id" {
  description = "The zone ID of the Application Load Balancer"
  value       = aws_lb.alb.zone_id
}

# Target Group Outputs
output "target_group_arn" {
  description = "The ARN of the target group"
  value       = aws_lb_target_group.tg.arn
}

# Security Group Outputs
output "alb_security_group_id" {
  description = "The ID of the ALB security group"
  value       = aws_security_group.alb_sg.id
}

output "ec2_security_group_id" {
  description = "The ID of the EC2 security group"
  value       = aws_security_group.ec2_sg.id
}

# Application URL
output "application_url" {
  description = "The URL to access your application through the ALB"
  value       = "http://${aws_lb.alb.dns_name}"
}

