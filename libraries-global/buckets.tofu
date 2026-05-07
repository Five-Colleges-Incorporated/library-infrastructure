module "bucket_production_terraform" {
  source = "../modules/bucket"

  environment = "production"
  school      = "5c"
  purpose     = "state"
  iteration   = 2

  noncurrent_version_expiration = 365
  force_destroy                 = false

  project = module.project_infrastructure.name
}

module "bucket_sandbox_terraform" {
  source = "../modules/bucket"

  environment = "sandbox"
  school      = "5c"
  purpose     = "state"

  noncurrent_version_expiration = 365
  force_destroy                 = false

  project = module.project_infrastructure.name
}

module "bucket_userload_access_logs" {
  source = "../modules/bucket"

  environment   = "production"
  school        = "5c"
  purpose       = "accesslogs"
  name_override = "prod-1-library-users-access-logs"

  lifecycle_rules = [["default", null, "365"]]
  unlogged_bucket = true

  project = module.project_userload.name
}

module "bucket_userload_source" {
  for_each = { "ac" = [7, "amherst"] }
  source   = "../modules/bucket"

  environment   = "production"
  school        = each.key
  purpose       = "source"
  name_override = "prod-${each.value[0]}-${each.value[1]}-library-users"

  lifecycle_rules     = [["default", null, "60"]]
  logging_bucket_name = module.bucket_userload_access_logs.created_bucket.name

  project = module.project_userload.name
}
