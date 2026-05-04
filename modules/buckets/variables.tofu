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

  validation {
    condition     = contains(["ac", "hc", "mh", "sc", "um", "5c"], var.school)
    error_message = "Environment must be one of 'ac', 'hc', 'mh', 'sc', 'hc', or '5c'."
  }
}

variable "application" {
  type        = string
  description = "Application this bucket is used by."
  validation {
    condition     = length(regexall("^[[:alnum:]]+$", var.application)) > 0
    error_message = "Application must be alphanumeric"
  }
}
variable "purpose" {
  type        = string
  description = "The purpose this bucket serves."
  validation {
    condition     = length(regexall("^[[:alnum:]]+$", var.purpose)) > 0
    error_message = "Application must be alphanumeric"
  }
}

variable "iteration" {
  type        = number
  description = "The iteration of this bucket. DigitalOcean buckets must be unique and deleting a bucket takes 14 to reclaim an existing name."
}

variable "create" {
  type        = bool
  description = "Whether the bucket should be created."
  default     = true
}
