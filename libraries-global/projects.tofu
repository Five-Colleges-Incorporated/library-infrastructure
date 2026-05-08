module "project_infrastructure" {
  source = "../modules/project"
  providers = {
    digitalocean.global  = digitalocean
    digitalocean.sandbox = digitalocean.sandbox
  }

  name = "infrastructure"
}

module "project_userload" {
  source = "../modules/project"
  providers = {
    digitalocean.global  = digitalocean
    digitalocean.sandbox = digitalocean.sandbox
  }

  name = "userload"
}
