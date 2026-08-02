provider "github" {
  owner = var.github_owner
  # Token is read from the GITHUB_TOKEN environment variable.
  # Never put credentials in a .tf file: they get committed AND written to state.
}

provider "tls" {}
provider "http" {}