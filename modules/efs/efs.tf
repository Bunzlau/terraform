terraform {
  required_providers {
    awscc = {
      source  = "hashicorp/awscc"
      version = "1.2.0"
    }
  }
}
variable "efs_name" {
  default = ""
}
locals {
  efs_name = "${var.environment}-${var.efs_name}"

  common_tags_sg = {
    Project     = var.project_name
    Environment = var.environment
  }
}

#EFS File System
resource "aws_efs_file_system" "efs" {
  encrypted =  true
  performance_mode = "generalPurpose"
  throughput_mode = "bursting"

  tags = merge(local.common_tags_sg, {
    Name = local.efs_name
  })

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
}


resource "aws_efs_mount_target" "efs_mt" {
  count = length(var.subnets_ids)

    file_system_id = aws_efs_file_system.efs.id
    subnet_id      = var.subnets_ids[count.index]
    security_groups = [var.efs_sg_id]
}

resource "aws_efs_access_point" "training_ap" {
  file_system_id = aws_efs_file_system.efs.id

  root_directory {
    path = "/training-data"  # custom root directory

    creation_info {
      owner_uid   = 1000
      owner_gid   = 1000
      permissions = "775"
    }
  }

  posix_user {
    uid = 1000
    gid = 1000
  }

  tags = {
    Name = "training-access-point"
  }
}