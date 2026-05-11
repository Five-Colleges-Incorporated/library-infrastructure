module "project_userload" {
  source = "../../modules/project"
  providers = {
    digitalocean.global  = digitalocean
    digitalocean.sandbox = digitalocean.sandbox
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
