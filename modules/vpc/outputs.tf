output "vpc_id" {
  value       = aws_vpc.main.id
  description = "ID of the created VPC"
}

output "public_subnet_az1_id" {
  value       = aws_subnet.public_az1.id
  description = "ID of public subnet in AZ1"
}

output "public_subnet_az2_id" {
  value       = aws_subnet.public_az2.id
  description = "ID of public subnet in AZ2"
}

output "public_route_table_id" {
  value       = aws_route_table.public.id
  description = "ID of the created public route table"
}

