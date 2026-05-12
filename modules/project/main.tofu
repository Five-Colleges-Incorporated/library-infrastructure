resource "digitalocean_project" "global" {
  provider = digitalocean.global
  name     = var.name

  environment = "Production"
}
resource "digitalocean_project" "global_sandbox" {
  count = var.name != "infrastructure" ? 1 : 0

  provider = digitalocean.global
  name     = "${var.name}-test"

  environment = "Staging"
}
resource "digitalocean_project" "global_development" {
  count = var.name != "infrastructure" ? 1 : 0

  provider = digitalocean.global
  name     = "${var.name}-dev"

  environment = "Development"
}

resource "digitalocean_project" "production" {
  provider = digitalocean.production
  name     = var.name

  environment = "Production"
}
resource "digitalocean_project" "production_sandbox" {
  provider = digitalocean.production
  name     = "${var.name}-sandbox"

  environment = "Staging"
}

resource "digitalocean_project" "development" {
  provider = digitalocean.development
  name     = var.name

  environment = "Development"
}

output "name" {
  value = var.name
}
