module "project_userload" {
  source = "../../modules/project"
  providers = {
    digitalocean.global      = digitalocean
    digitalocean.production  = digitalocean.production
    digitalocean.development = digitalocean.development
  }

  name = "userload"
}

module "bucket_userload_access_logs" {
  source = "../../modules/bucket"

  environment   = "production"
  school        = "5c"
  purpose       = "accesslogs"
  name_override = "prod-1-library-users-access-logs"

  lifecycle_rules = [["default", null, "365"]]
  unlogged_bucket = true

  project = module.project_userload.name
}

module "bucket_sandbox_userload_access_logs" {
  source = "../../modules/bucket"

  environment = "sandbox"
  school      = "5c"
  purpose     = "accesslogs"

  lifecycle_rules = [["default", null, "365"]]
  unlogged_bucket = true

  project = module.project_userload.name
}

module "bucket_userload_source" {
  for_each = {
    "ac" = [7, "amherst"],
    "mh" = [1, "mountholyoke"],
    "sc" = [1, "smith"],
    "um" = [1, "umass"]
  }
  source = "../../modules/bucket"

  environment   = "production"
  school        = each.key
  purpose       = "source"
  name_override = "prod-${each.value[0]}-${each.value[1]}-library-users"

  lifecycle_rules     = [["default", null, "60"]]
  logging_bucket_name = module.bucket_userload_access_logs.created_bucket.name

  project = module.project_userload.name
}
module "bucket_sandbox_userload_source" {
  for_each = {
    "ac" = 1,
    "mh" = 1,
    "sc" = 1,
    "um" = 1,
  }
  source = "../../modules/bucket"

  environment = "sandbox"
  school      = each.key
  purpose     = "source"
  iteration   = each.value

  lifecycle_rules     = [["default", null, "7"]]
  logging_bucket_name = module.bucket_sandbox_userload_access_logs.created_bucket.name

  project = module.project_userload.name
}

module "bucket_userload_logs" {
  source = "../../modules/bucket"

  environment   = "production"
  school        = "5c"
  purpose       = "runtimelogs"
  name_override = "prod-1-library-users-logs"

  lifecycle_rules     = [["default", null, "30"]]
  logging_bucket_name = module.bucket_userload_access_logs.created_bucket.name

  project = module.project_userload.name
}

module "bucket_sandbox_userload_logs" {
  source = "../../modules/bucket"

  environment = "sandbox"
  school      = "5c"
  purpose     = "runtimelogs"

  lifecycle_rules     = [["default", null, "7"]]
  logging_bucket_name = module.bucket_sandbox_userload_access_logs.created_bucket.name

  project = module.project_userload.name
}

module "bucket_development_userload" {
  source = "../../modules/bucket"

  environment = "development"
  school      = "5c"
  purpose     = "all"
  iteration   = 1

  lifecycle_rules = [["default", null, "1"]]

  project = module.project_userload.name
}

module "access_key_userload_development" {
  source = "../../modules/access_key"

  actor    = "userload.dev"
  semester = "spring"
  year     = 2026

  writeable_buckets = [
    module.bucket_development_userload.created_bucket.name,
    module.bucket_development_userload.logging_bucket.name,
  ]

  secret_store = module.bucket_admin_secrets.created_bucket.name
}

locals {
  userload_access_logs_r = [
    module.bucket_userload_access_logs.created_bucket.name,
    module.bucket_sandbox_userload_access_logs.created_bucket.name,
  ]
  useradmin_r = concat(local.userload_access_logs_r, [
    module.bucket_userload_logs.created_bucket.name,
    module.bucket_sandbox_userload_logs.created_bucket.name,
  ])
}
