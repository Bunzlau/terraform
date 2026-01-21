output "instance_public_ip" {
  value       = ""                                          # The actual value to be outputted
  description = "The public IP address of the EC2 instance" # Description of what this output represents
}

output "ec2_security_group_id" {
  value       = aws_instance.ec2_az1                               # The actual value to be outputted
  description = "The ID of the EC2 instance"      # Description of what this output represents
}