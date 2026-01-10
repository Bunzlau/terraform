# terraform {
#   required_providers {
#     github = {
#       source  = "integrations/github"
#       version = "~> 6.0"
#     }
#   }
# }
#
# # Configure the GitHub Provider
# provider "github" {
#   token = "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"
# }
#
# resource "github_repository" "example" {
#   name        = "example"
#   description = "My awesome codebase"
#
#   visibility = "private"
#
# }