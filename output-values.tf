# provider "aws" {
#   region = ""
# }
#
# resource "aws_eip" "lb" {
#     domain   = "vpc"
# }
#
# output "public-ip" {
#   value = "aws_eip.lb.public_ip"
# }