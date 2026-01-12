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
