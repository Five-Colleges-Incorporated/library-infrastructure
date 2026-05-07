variable "name" {
  type        = string
  description = "Name of the project."

  validation {
    condition     = length(regexall("^[[:alnum:]]+$", var.name)) > 0
    error_message = "Name must be alphanumeric"
  }
}
