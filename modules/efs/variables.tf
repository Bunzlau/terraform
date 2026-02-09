variable "environment" {
  description = "Deployment environment (used as prefix for names)"
  type        = string
}

variable "project_name" {
  description = "Project name used for tags"
  type        = string
}

variable "subnets_ids" {
    description = "List of subnet IDs where the EFS mount targets will be created"
    type        = list(string)
}

variable "efs_sg_id" {
    description = "ID of the EFS security group to allow NFS access"
    type        = string
}