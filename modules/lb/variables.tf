variable "environment" {
  description = "Deployment environment (used as prefix for names)"
  type        = string
}

variable "project_name" {
  description = "Project name used for tags"
  type        = string
}

variable "alb_name" {
  description = "Base name for the ALB (resource name uses this)"
  type        = string
}

variable "target_group_name" {
  description = "Base name for the target group; local.tg_name is constructed from this and environment"
  type        = string
}


variable "tg_name" {
  description = "(Compatibility) Target group name variable referenced directly in the module. If empty, the module's local.tg_name will be used by you to set the real name. This exists to avoid breaking the current inconsistent reference in lb.tf."
  type        = string
}

variable "tg" {
  description = "(Compatibility) Tag value used for the Target Group Name tag. If empty, the computed name will be used instead."
  type        = string
}

variable "alb_type" {
  description = "Type of load balancer (application or network)"
  type        = string
  validation {
    condition     = contains(["application", "network"], var.alb_type)
    error_message = "alb_type must be either \"application\" or \"network\""
  }
}

variable "alb_internal" {
  description = "Whether the ALB is internal (no public IP)"
  type        = bool
}

variable "alb_protocol" {
  description = "Protocol used by the ALB and target group listeners"
  type        = string
  validation {
    condition     = contains(["HTTP", "HTTPS", "TCP", "TLS"], upper(var.alb_protocol))
    error_message = "alb_protocol must be one of HTTP, HTTPS, TCP or TLS"
  }
}

variable "http_port" {
  description = "Port for the listener and target group (numeric)"
  type        = number
}

variable "http_port_string" {
  description = "Port for health checks; usually \"traffic-port\" or a number as string"
  type        = string
}

variable "health_check_path" {
  description = "HTTP path that the target group's health check will use"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs to attach the ALB to (usually public subnets)"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs to attach to the ALB"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC id where target group and ALB live"
  type        = string
}

variable "ec2_instance_z1_id" {
  description = "ID of the EC2 instance in availability zone 1 to attach to the target group"
  type        = string
}

variable "ec2_instance_z2_id" {
  description = "ID of the EC2 instance in availability zone 2 to attach to the target group"
  type        = string
}

variable "certificate_arn" {
  type = string
  description = "ARN of the SSL certificate to use for HTTPS listener"
}

variable "certificate_arn_www" {
  type = string
  description = "ARN of the SSL certificate to use for HTTPS listener"
}

variable "domain_name" {
  type = string
  description = "Domain name for the ACM certificate"
}

variable "domain_name_www" {
  type = string
  description = "Domain name for the ACM certificate"
}
