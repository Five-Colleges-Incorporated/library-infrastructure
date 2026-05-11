resource "digitalocean_project" "global" {
  provider = digitalocean.global
  name     = var.name

  environment = "Production"
}
resource "digitalocean_project" "production" {
  provider = digitalocean.production
  name     = var.name

  environment = "Production"
}
resource "digitalocean_project" "development" {
  provider = digitalocean.development
  name     = var.name

  environment = "Development"
}

output "name" {
  value = var.name
}
