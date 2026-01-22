// Variables required by modules/sg/sg.tf

variable "environment" {
  description = "Deployment environment (used for resource name prefixes)"
  type        = string
}

variable "project_name" {
  description = "Project name used for tags"
  type        = string
}

variable "alb_security_group" {
  description = "Name for the ALB security group"
  type        = string
}

variable "ec2_security_group" {
  description = "Name for the EC2 security group"
  type        = string
}

variable "http_port" {
  description = "Port used for HTTP between ALB and EC2"
  type        = number
  validation {
    condition     = var.http_port > 0 && var.http_port <= 65535
    error_message = "http_port must be a valid TCP port (1-65535)"
  }
}

variable "ingress_cidrs" {
  description = "List of CIDR blocks allowed to reach the ALB (ingress)"
  type        = list(string)
}

variable "egress_cidrs" {
  description = "List of CIDR blocks allowed for egress from the security groups"
  type        = list(string)
}

variable "ssh_port" {
  description = "SSH port used to access EC2 instances"
  type        = number
  validation {
    condition     = var.ssh_port > 0 && var.ssh_port <= 65535
    error_message = "ssh_port must be a valid TCP port (1-65535)"
  }
}

variable "ssh_allowed_cidrs" {
  description = "List of CIDR blocks allowed to SSH into EC2 instances"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC id where the security groups will be created"
  type        = string
}
