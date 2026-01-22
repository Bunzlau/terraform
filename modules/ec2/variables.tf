variable "ec2_instance_type" {
    type        = string
    description = "EC2 instance type (e.g. t3.micro)."
}

variable "environment" {
    type        = string
    description = "Deployment environment used in names and tags (e.g. dev, staging, prod)."
}

variable "ec2_az1" {
    type        = string
    description = "Availability zone suffix/identifier for the first instance (used in name)."
}

variable "ec2_az2" {
    type        = string
    description = "Availability zone suffix/identifier for the second instance (used in name)."
}

variable "project_name" {
    type        = string
    description = "Project name used in resource tags."
}

variable "ami_name_filter" {
    type        = string
    description = "AMI name filter (glob) used to find the AMI for instances."
}

variable "ami_virtualization" {
    type        = string
    description = "Virtualization type filter for AMI lookup."
}

variable "ami_owners" {
    type        = list(string)
    description = "List of AMI owners (aliases or account IDs) used for AMI lookup."
}

variable "ec2_key_name" {
    type        = string
    description = "Optional EC2 key pair name for SSH access. Leave empty to disable key_name."
}

variable "subnet_id_public_az1" {
    type        = string
    description = "Subnet ID for public subnet in AZ1 where ec2_az1 will be launched."
}

variable "subnet_id_public_az2" {
    type        = string
    description = "Subnet ID for public subnet in AZ2 where ec2_z2 will be launched."
}

variable "ec2_security_group_ids" {
    type        = list(string)
    description = "List of security group IDs to associate with the EC2 instances."
}