module "project_infrastructure" {
  source = "./project"
  providers = {
    digitalocean.global  = digitalocean
    digitalocean.sandbox = digitalocean.sandbox
  }

  name = "infrastructure"
}
