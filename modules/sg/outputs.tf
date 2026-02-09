output "alb_sg_id" {
  value       = aws_security_group.alb_sg.id
  description = "ID of the ALB security group created by this module"
}

output "ec2_sg_id" {
  value       = aws_security_group.ec2_sg.id
  description = "ID of the EC2 security group created by this module"
}

output "efs_sg_id" {
    value       = aws_security_group.efs_sg.id
    description = "ID of the EFS security group created by this module"
}