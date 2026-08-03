github_owner = "hap2y-platform"
org_name     = "platform"
name_prefix  = "repo-factory-"

repositories = {
  "svc-billing" = {
    description        = "Billing service — demo repository managed by Terraform"
    topics             = ["service", "go", "terraform-managed"]
    required_reviewers = 0
    extra_labels = {
      "area/payments" = { color = "5319e7", description = "Payments subsystem" }
    }
  }

  "svc-notifications" = {
    description = "Notification fan-out service — demo repository managed by Terraform"
    topics      = ["service", "python", "terraform-managed"]
  }

  "lib-common" = {
    description = "Shared internal library — demo repository managed by Terraform"
    topics      = ["library", "terraform-managed"]
    extra_labels = {
      "breaking-change" = { color = "b60205", description = "Requires a major version bump" }
    }
  }
}