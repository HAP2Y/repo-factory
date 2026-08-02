locals {
  managed_by = "terraform"
  timestamp = formatdate("YYYY-MM-DD", timestamp())

  # Merge default labels with per-repo extras
  repo_labels = {
    for name, cfg in var.repositories :
    name => merge(var.defualt_labels, cfg.extra_labels)
  }

  # Flatten to a set of composite keys for a future for_each
  label_pairs = merge([
    for repo, labels in local.repo_labels : {
        for label, cfg in labels : "${repo}:${label}" => {
            repo = repo
            label = label
            color = cfg.color
        }
    }
  ]...)
}

data "http" "gitignore_template" {
  url = "https://raw.githubusercontent.com/github/gitignore/main/Terraform.gitignore"

  request_headers = {
    Accept = "text/plain"
  }

  retry {
    attempts = 2
  }
}

check "gitignore_fetch_succeeded" {
  assert {
    condition = data.http.gitignore_template.status_code == 200
    error_message = "Could not fetch the upstream .gitignore template."
  }
}