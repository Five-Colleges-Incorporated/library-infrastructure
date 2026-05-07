module "project_infrastructure" {
  source = "./project"
  providers = {
    digitalocean.global  = digitalocean
    digitalocean.sandbox = digitalocean.sandbox
  }

  name = "infrastructure"
}

module "project_userload" {
  source = "./project"
  providers = {
    digitalocean.global  = digitalocean
    digitalocean.sandbox = digitalocean.sandbox
  }

  name = "userload"
}
