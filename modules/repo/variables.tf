variable "name_prefix" {
  description = "Prefix applied to every repository name created by this factory."
  type        = string
  default     = "repo-factory-"

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]*-$", var.name_prefix))
    error_message = "name_prefix must be lowercase, URL-safe, and end with a hyphen."
  }
}

variable "name" {
  description = "Repository name."
  type        = string
}

variable "description" {
  description = "Repository description."
  type        = string
}

variable "visibility" {
  description = "public or private."
  type        = string
  default     = "public"
}

variable "topics" {
  description = "Repository topics."
  type        = list(string)
  default     = []
}

variable "labels" {
  description = "Issue labels to create."
  type = map(object({
    color       = string
    description = string
  }))
  default = {}
}

variable "protect_default_branch" {
  description = "Apply branch protection to the default branch."
  type        = bool
  default     = true
}

variable "required_reviewers" {
  description = "Approving reviews required before merge."
  type        = number
  default     = 0

  validation {
    condition     = var.required_reviewers >= 0 && var.required_reviewers <= 6
    error_message = "GitHub allows between 0 and 6 required reviewers."
  }
}

variable "gitignore_content" {
  description = "Contents of the .gitignore file to commit."
  type        = string
  default     = ""
}

variable "managed_by" {
  description = "Free-text marker written into the generated README."
  type        = string
  default     = "terraform"
}