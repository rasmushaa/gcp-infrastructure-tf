variable "project_id" {
  description = "ID of the existing GCP project that owns the bucket."
  type        = string
  nullable    = false

  validation {
    condition     = length(trimspace(var.project_id)) > 0
    error_message = "project_id must not be empty."
  }
}

variable "bucket_name" {
  description = "Globally unique Cloud Storage bucket name."
  type        = string
  nullable    = false

  validation {
    condition = (
      length(var.bucket_name) >= 3 &&
      length(var.bucket_name) <= 63 &&
      can(regex("^[a-z0-9][a-z0-9._-]*[a-z0-9]$", var.bucket_name))
    )
    error_message = "bucket_name must be 3-63 characters, use lowercase letters, numbers, dots, underscores, or hyphens, and start and end with a letter or number."
  }
}
