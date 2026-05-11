module "project_infrastructure" {
  source = "../../modules/project"
  providers = {
    digitalocean.global  = digitalocean
    digitalocean.sandbox = digitalocean.sandbox
  }

  name = "infrastructure"
}

module "bucket_production_terraform" {
  source = "../../modules/bucket"

  environment = "production"
  school      = "5c"
  purpose     = "state"
  iteration   = 2

  noncurrent_version_expiration = 365
  force_destroy                 = false

  project = module.project_infrastructure.name
}

module "bucket_sandbox_terraform" {
  source = "../../modules/bucket"

  environment = "sandbox"
  school      = "5c"
  purpose     = "state"

  noncurrent_version_expiration = 365
  force_destroy                 = false

  project = module.project_infrastructure.name
}
