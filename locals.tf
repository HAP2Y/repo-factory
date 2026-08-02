##
## ----- LOCALS -----
##
locals {
  managed_by = "${var.org_name} team"

  # Merge default labels with per-repo extras
  repo_labels = {
    for name, cfg in var.repositories :
    name => merge(var.default_labels, cfg.extra_labels)
  }

  # Physical names, keyed by logical name. You'll need these for outputs and imports.
  repo_full_names = {
    for name, cfg in var.repositories : name => "${var.name_prefix}${name}"
  }

  gitignore_content = data.http.gitignore_template.response_body
}


##
## ----- DATA -----
##
data "http" "gitignore_template" {
  url = "https://raw.githubusercontent.com/github/gitignore/main/Terraform.gitignore"

  request_headers = {
    Accept = "text/plain"
  }

  retry {
    attempts = 2
  }
}


##
## ----- CHECKS -----
##
check "gitignore_fetch_succeeded" {
  assert {
    condition     = data.http.gitignore_template.status_code == 200
    error_message = "Could not fetch the upstream .gitignore template."
  }
}