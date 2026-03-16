output "file_system_id" {
  value       = aws_efs_file_system.efs.id
  description = "The ID of the created EFS file system (e.g. fs-12345678)"
}

output "access_point_id" {
  value       = aws_efs_access_point.training_ap.id
  description = "The EFS access point id (if created)"
}
