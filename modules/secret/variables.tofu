variable "key" {
  type        = string
  description = "The key of the secret in the bucket."
}

variable "secret_store" {
  type        = string
  description = "The bucket name where the secret lives."
}
