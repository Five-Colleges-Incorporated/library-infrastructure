locals {
  env = lookup({
    "sandbox"        = "test",
    "production"     = "prod",
    "development"    = "devv",
    "administrative" = "admn"
  }, var.environment)
  iter        = format("%02d", coalesce(var.iteration, 1))
  bucket_name = coalesce(var.name_override, "fclib-${local.env}-${lower(var.project)}-${var.school}-${lower(var.purpose)}-${local.iter}")

  create_logging_bucket = !var.unlogged_bucket && var.logging_bucket_name == null
  versioning_enabled    = var.noncurrent_version_expiration != null

  # TODO: How to make sure this stays in sync with project naming?
  do_project = (
    var.project == "infrastructure"
    ? var.project
    : (
      var.environment == "sandbox"
      ? "${var.project}-test"
      : (
        var.environment == "development"
        ? "${var.project}-dev"
        : var.project
  )))
}
