locals {
  amherst_user_source_w = [
    module.bucket_userload_source["ac"].created_bucket.name,
    module.bucket_sandbox_userload_source["ac"].created_bucket.name
  ]
}

/*
# The digitalocean provider can't import access_keys
# This is for reference/testing for the next key rotation

module "access_key_amherst_it" {
  source = "../../modules/access_key"

  actor    = "amherst.it"
  semester = "spring"
  year     = 2026

  writeable_buckets = local.amherst_user_source_w
  readonly_buckets  = local.userload_access_logs_r

  secret_store = module.bucket_admin_secrets.created_bucket.name
}
*/
