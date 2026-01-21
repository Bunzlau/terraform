// Variables required by modules/vpc/vpc.tf

variable "environment" {
  description = "Deployment environment (used as prefix for resource names)"
  type        = string
}

variable "project_name" {
  description = "Project name used for tags"
  type        = string
}

variable "vpc_name" {
  description = "Base name for the VPC (used for tagging)"
  type        = string
}

variable "internet_gateway" {
  description = "Name for the internet gateway resource (used for tagging)"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC (e.g. 10.0.0.0/16)"
  type        = string
}

variable "default_route_cidr" {
  description = "Destination CIDR where the public route points (commonly 0.0.0.0/0)"
  type        = string
}

variable "public_route_table" {
  description = "Name for the public route table (used for tagging)"
  type        = string
}

variable "public_subnet_az1_cidr" {
  description = "CIDR block for the public subnet in AZ1 (e.g. 10.0.1.0/24)"
  type        = string
}

variable "public_subnet_az1_az" {
  description = "Availability zone for public subnet AZ1 (e.g. eu-west-1a)"
  type        = string
}

variable "public_subnet_az1_name" {
  description = "Name tag for the public subnet AZ1"
  type        = string
}

variable "public_subnet_az2_cidr" {
  description = "CIDR block for the public subnet in AZ2 (e.g. 10.0.2.0/24)"
  type        = string
}

variable "public_subnet_az2_az" {
  description = "Availability zone for public subnet AZ2 (e.g. eu-west-1b)"
  type        = string
}

variable "public_subnet_az2_name" {
  description = "Name tag for the public subnet AZ2"
  type        = string
}

variable "map_public_ip_on_launch" {
  description = "Whether instances launched in the public subnets should receive a public IP"
  type        = bool
}

