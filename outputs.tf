output "managed_repositories" {
  value = { for name, mod in module.repo : name => mod.full_name }
}

output "repository_count" {
  value = length(module.repo)
}

output "deploy_private_keys" {
  value     = { for name, mod in module.repo : name => mod.deploy_private_key }
  sensitive = true
}