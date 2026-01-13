variable "region" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "internet_gateway" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_route_table" {
  type = string
}

variable "public_subnet_az1_name" {
  type = string
}

variable "public_subnet_az1_cidr" {
  type = string
}

variable "public_subnet_az1_az" {
  type = string
}

variable "public_subnet_az2_name" {
  type = string
}

variable "public_subnet_az2_cidr" {
  type = string
}

variable "public_subnet_az2_az" {
  type = string
}

variable "ec2_az1" {
  type = string
}

variable "ec2_az2" {
  type = string
}

variable "ec2_instance_type" {
  type = string
}

variable "ec2_key_name" {
  type = string
}

variable "ec2_security_group" {
  type = string
}

variable "alb_name" {
  type = string
}

variable "alb_security_group" {
  type = string
}

variable "tg_name" {
  type = string
}

variable "tg" {
  type = string
}

variable "target_group_name" {
  type = string
}

variable "http_port" {
  type    = number
}
variable "http_port_string" {
  type    = string
}

variable "https_port" {
  type    = number
}
variable "https_port_string" {
  type    = string
}

variable "ssh_port" {
  type    = number
}
variable "ssh_port_string" {
  type    = string
}

// Added variables to remove hard-coded values from main.tf
variable "default_route_cidr" {
  type        = string
  description = "CIDR used for default route (e.g. 0.0.0.0/0)"
}

variable "ingress_cidrs" {
  type        = list(string)
  description = "CIDR blocks allowed for generic ingress rules"
}

variable "egress_cidrs" {
  type        = list(string)
  description = "CIDR blocks allowed for egress rules"
}

variable "ssh_allowed_cidrs" {
  type        = list(string)
  description = "CIDR(s) allowed for SSH access"
}

variable "ami_name_filter" {
  type        = string
  description = "AMI name filter for the aws_ami data source"
}

variable "ami_virtualization" {
  type        = string
  description = "Virtualization type filter for AMI lookup"
}

variable "ami_owners" {
  type        = list(string)
  description = "Owners used when looking up AMIs"
}

variable "alb_type" {
  type        = string
  description = "Type of load balancer (application or network)"
}

variable "alb_internal" {
  type        = bool
  description = "Whether the ALB is internal"
}

variable "health_check_path" {
  type        = string
  description = "Health check path for the target group"
}

variable "alb_protocol" {
  type        = string
  description = "Protocol used by ALB/target group (HTTP/HTTPS)"
}

variable "map_public_ip_on_launch" {
  type        = bool
  description = "Whether to auto-assign public IPs on subnet launch"
}
