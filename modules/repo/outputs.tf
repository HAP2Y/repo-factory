output "full_name" {
  description = "owner/repo identifier."
  value       = github_repository.this.full_name
}

output "logical_name" {
  description = "Real Repository name without the org specific prefix."
  value       = var.name
}

output "node_id" {
  description = "GraphQL node ID, needed for branch protection references."
  value       = github_repository.this.node_id
}

output "clone_url" {
  description = "HTTPS clone URL."
  value       = github_repository.this.http_clone_url
}

output "default_branch" {
  description = "Default branch for this repository."
  value       = github_repository.this.default_branch
}

output "branch_protection_enabled" {
  description = "Branch Protection is enabled or not."
  value       = var.protect_default_branch ? 1 : 0
}

output "deploy_private_key" {
  description = "Private half of the generated deploy key."
  value       = tls_private_key.deploy.private_key_openssh
  sensitive   = true
}