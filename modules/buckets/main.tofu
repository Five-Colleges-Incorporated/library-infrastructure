locals {
  env         = lookup({ "sandbox" = "test", "production" = "prod", "administrative" = "admn" }, var.environment)
  iter        = format("%02d", var.iteration)
  bucket_name = coalesce(var.name_override, "fclib-${local.env}-${lower(var.application)}-${var.school}-${lower(var.purpose)}-${local.iter}")

  create_logging_bucket = !var.unlogged_bucket && var.logging_bucket_id == null

  versioning_rules = var.noncurrent_version_expiration == null ? [] : [true]
}
