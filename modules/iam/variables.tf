variable "project_name" {
  type        = string
  description = "Project name used in resource tags."
}

variable "environment" {
  type        = string
  description = "Deployment environment used in names and tags (e.g. dev, staging, prod)."
}
