locals {
  full_name = "${var.name_prefix}${var.name}" # convention layer two
}

##
## ----- RESOURCE -----
##
resource "github_repository" "this" {
  name        = local.full_name
  description = var.description
  visibility  = var.visibility

  auto_init              = true
  has_issues             = true
  has_wiki               = false
  has_projects           = false
  delete_branch_on_merge = true
  topics                 = var.topics

  lifecycle {
    # Branch protection on private repos needs a paid GitHub plan.
    precondition {
      condition     = !(var.protect_default_branch && var.visibility == "private")
      error_message = "Branch protection on a private repo requires GitHub Pro or Team. Set visibility = \"public\" or protect_default_branch = false."
    }
  }
}

resource "github_branch_protection" "this" {
  count = var.protect_default_branch ? 1 : 0

  repository_id = github_repository.this.node_id
  pattern       = github_repository.this.default_branch

  enforce_admins          = false
  allows_force_pushes     = false
  allows_deletions        = false
  required_linear_history = true

  depends_on = [github_repository.this]

  required_pull_request_reviews {
    required_approving_review_count = var.required_reviewers
    dismiss_stale_reviews           = true
  }
}

resource "github_issue_label" "this" {
  for_each = var.labels

  repository  = github_repository.this.name
  name        = each.key
  color       = each.value.color
  description = each.value.description

  depends_on = [github_repository.this]
}

resource "tls_private_key" "deploy" {
  algorithm = "ED25519"
}

resource "github_repository_deploy_key" "this" {
  title      = "terraform-managed-readonly"
  repository = github_repository.this.name
  key        = tls_private_key.deploy.public_key_openssh
  read_only  = true

  depends_on = [github_repository.this]
}

resource "github_repository_file" "readme" {
  repository = github_repository.this.name
  branch     = github_repository.this.default_branch
  file       = "README.md"

  content = templatefile("${path.module}/templates/README.md.tftpl", {
    name        = var.name
    description = var.description
    topics      = var.topics
    labels      = keys(var.labels)
    managed_by  = var.managed_by
  })

  depends_on = [github_repository.this]

  commit_message      = "chore(terraform): sync README"
  overwrite_on_create = true
}

resource "github_repository_file" "gitignore" {
  count = var.gitignore_content == "" ? 0 : 1

  repository          = github_repository.this.name
  branch              = github_repository.this.default_branch
  file                = ".gitignore"
  content             = var.gitignore_content
  commit_message      = "chore(terraform): sync .gitignore"
  overwrite_on_create = true

  depends_on = [github_repository.this]
}