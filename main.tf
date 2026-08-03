##
## ----- MODULE -----
##
module "repo" {
  source   = "git::https://github.com/HAP2Y/repo-factory.git//modules/repo?ref=v1.0.0"
  for_each = var.repositories

  name        = each.key
  name_prefix = var.name_prefix
  description = each.value.description
  visibility  = each.value.visibility
  topics      = each.value.topics

  labels             = local.repo_labels[each.key]
  required_reviewers = each.value.required_reviewers

  # Branch protection on a private repo needs a paid Github plan.
  protect_default_branch = each.value.visibility == "public"

  gitignore_content = local.gitignore_content
  managed_by        = local.managed_by
}