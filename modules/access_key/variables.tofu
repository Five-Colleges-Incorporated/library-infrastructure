variable "actor" {
  type        = string
  description = "The identify of the key owner."

  validation {
    condition     = length(regexall("^[[:alnum:]]+([.][[:alnum:]]+)*$", var.actor)) > 0
    error_message = "Actor must be alphanumeric or dot separated."
  }
}
variable "semester" {
  type        = string
  description = "The semester this key was created (for rotation purposes)."
  validation {
    condition     = contains(["fall", "spring"], var.semester)
    error_message = "Semester must be either 'fall' or 'spring'."
  }
}
variable "year" {
  type        = number
  description = "The year this key was created (for rotation purposes)."
  validation {
    condition     = 2026 <= var.year && var.year <= 2030
    error_message = "Year must be a year."
  }
}

variable "writeable_buckets" {
  type        = list(string)
  description = "Buckets for the key to have read/write access."
  default     = []
}

variable "readonly_buckets" {
  type        = list(string)
  description = "Buckets for the key to have readonly access."
  default     = []
}

variable "secret_store" {
  type        = string
  description = "The bucket name where the secret will be uploaded"
}
