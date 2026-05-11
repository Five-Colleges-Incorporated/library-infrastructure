module "project_infrastructure" {
  source = "../../modules/project"
  providers = {
    digitalocean.global      = digitalocean
    digitalocean.production  = digitalocean.production
    digitalocean.development = digitalocean.development
  }

  name = "infrastructure"
}

module "bucket_admin_secrets" {
  source = "../../modules/bucket"

  environment = "administrative"
  school      = "5c"
  purpose     = "secrets"

  noncurrent_version_expiration = 365
  force_destroy                 = false

  project = module.project_infrastructure.name
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
module "bucket_production_secrets" {
  source = "../../modules/bucket"

  environment = "production"
  school      = "5c"
  purpose     = "secrets"

  noncurrent_version_expiration = 365
  force_destroy                 = false

  project = module.project_infrastructure.name
}
module "bucket_sandbox_secrets" {
  source = "../../modules/bucket"

  environment = "sandbox"
  school      = "5c"
  purpose     = "secrets"

  noncurrent_version_expiration = 365
  force_destroy                 = false

  project = module.project_infrastructure.name
}

module "bucket_development_terraform" {
  source = "../../modules/bucket"

  environment = "development"
  school      = "5c"
  purpose     = "state"

  noncurrent_version_expiration = 30

  project = module.project_infrastructure.name
}
module "bucket_development_secrets" {
  source = "../../modules/bucket"

  environment = "development"
  school      = "5c"
  purpose     = "secrets"

  noncurrent_version_expiration = 365
  force_destroy                 = false

  project = module.project_infrastructure.name
}
