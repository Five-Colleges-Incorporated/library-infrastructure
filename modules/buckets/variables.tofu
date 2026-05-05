variable "environment" {
  type        = string
  description = "Environment for the bucket."

  validation {
    condition     = contains(["sandbox", "production", "administrative"], var.environment)
    error_message = "Environment must be one of 'sandbox', 'production', or 'administrative'."
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
    error_message = "Purpose must be alphanumeric"
  }
}

variable "iteration" {
  type        = number
  description = "The iteration of this bucket. DigitalOcean buckets must be unique and deleting a bucket takes 14 to reclaim an existing name."
}

variable "name_override" {
  type        = string
  description = "Override the generated bucket name (use this for resource imports)."
  default     = null
}
variable "create" {
  type        = bool
  description = "Whether the bucket should be created."
  default     = true
}

variable "lifecycle_rules" {
  type        = list(tuple([string, string, number]))
  description = "A list of ids, prefixes, and days to set as lifecycle rules."
  default     = []
}
variable "noncurrent_version_expiration" {
  type        = number
  description = "Enable bucket versioning and specify the number of days after which an object's non-current versions expire."
  default     = null
}
variable "force_destroy" {
  type        = bool
  description = "Unless true, the bucket will only be destroyed if empty (Defaults to true)."
  default     = true
}

variable "logging_bucket_id" {
  type        = string
  description = "The id of the bucket to use for access logs. If not provided a bucket will be created unless unlogged_bucket is set."
  default     = null
}
variable "unlogged_bucket" {
  type        = bool
  description = "Whether to create an access logs bucket by default if a loggin_bucket_id is not provided."
  default     = false
}
