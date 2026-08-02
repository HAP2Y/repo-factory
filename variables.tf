variable "org_name" {
  description = "Logical name of the platform team owning these repos."
  type        = string
  default     = "platform"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,20}$", var.org_name))
    error_message = "org_name must be lowercase alphanumeric with hyphens, 3-21 chars."
  }
}

variable "default_labels" {
  description = "Labels applied to every, managed repository."
  type = map(object({
    color       = string
    description = string
  }))

  default = {
    "bug" = {
      color       = "d73a4a",
      description = "Something is broken"
    }
    "enhancement" = {
      color       = "a2eeef",
      description = "New feature or request"
    }
    "tech-debt" = {
      color       = "fbca04",
      description = "Cleanup work"
    }
    "needs-triage" = {
      color       = "ededed",
      description = "Not yet assessed"
    }
  }

  validation {
    condition     = alltrue([for name, l in var.default_labels : can(regex("^[0-9a-fA-F]{6}$", l.color))])
    error_message = "Every label colour must be a 6-digit hex code without a leading #."
  }
}

variable "repositories" {
  description = "The repositories this factory manages. Key is the repo name."
  type = map(object({
    description        = string
    topics             = optional(list(string), [])
    visibility         = optional(string, "public")
    required_reviewers = optional(number, 0)
    extra_labels = optional(map(object({
      color       = string
      description = string
    })), {})
  }))

  default = {}

  validation {
    condition     = alltrue([for name, r in var.repositories : can(regex("^[a-z0-9][a-z0-9._-]{0,80}$", name))])
    error_message = "Repository names must be lowercase and URL-safe."
  }

  validation {
    condition     = alltrue([for name, r in var.repositories : contains(["public", "private"], r.visibility)])
    error_message = "Visibility must be either 'public' or 'private'."
  }
}

variable "github_owner" {
  description = "Github user or org that owns the repositories."
  type        = string
  default     = "HAP2Y"
}

variable "name_prefix" {
  description = "Prefix applied to every repository name created by this factory."
  type        = string
  default     = "repo-factory-"

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]*-$", var.name_prefix))
    error_message = "name_prefix must be lowercase, URL-safe, and end with a hyphen."
  }
}