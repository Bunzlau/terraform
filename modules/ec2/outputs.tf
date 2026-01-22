output "instance_ids" {
  value       = [aws_instance.ec2_az1.id, aws_instance.ec2_z2.id] # The actual value to be outputted
  description = "List of EC2 instance IDs created by this module"      # Description of what this output represents
}

output "instance_public_ips" {
  value       = [aws_instance.ec2_az1.public_ip, aws_instance.ec2_z2.public_ip] # The actual value to be outputted
  description = "Public IP addresses of the EC2 instances"                          # Description of what this output represents
}

output "ec2_security_group_id" {
  value       = aws_instance.ec2_az1.vpc_security_group_ids # The actual value to be outputted
  description = "The first security group ID used on the EC2 instance (for compatibility)"      # Description of what this output represents
}

output "ec2_z1_id"{
    value       = aws_instance.ec2_az1.id
    description = "The ID of the EC2 instance in AZ1"
}
output "ec2_z2_id"{
    value       = aws_instance.ec2_z2.id
    description = "The ID of the EC2 instance in AZ2"
}