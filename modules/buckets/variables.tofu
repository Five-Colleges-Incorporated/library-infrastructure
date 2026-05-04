variable "environment" {
  type        = string
  description = "Environment for the bucket."

  validation {
    condition     = contains(["sandbox", "production", "sensitive"], var.environment)
    error_message = "Environment must be one of 'sandbox', 'production', or 'sensitive'."
  }
}
variable "school" {
  type        = string
  description = "School this bucket is for."
  default     = null

  validation {
    condition     = contains([null, "ac", "hc", "mh", "sc", "um", "5c"], var.school)
    error_message = "Environment must be one of 'ac', 'hc', 'mh', 'sc', 'hc', or '5c'."
  }
}

variable "application" {
  type        = string
  description = "Application this bucket is used by."
  default     = null
}
variable "purpose" {
  type        = string
  description = "The purpose this bucket serves."
  default     = null
}

variable "iteration" {
  type        = number
  description = "The iteration of this bucket. DigitalOcean buckets must be unique and deleting a bucket takes 14 to reclaim an existing name."
  default     = null
}

variable "create" {
  type        = bool
  description = "Whether the bucket should be created."
  default     = true

  validation {
    condition     = !var.create || (var.create && length([for v in [var.school, var.application, var.purpose, var.iteration] : v if v == null]) == 0)
    error_message = "Parameters required to create the bucket are missing."
  }
}
