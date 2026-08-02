terraform {
  required_version = "~> 1.12"

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}