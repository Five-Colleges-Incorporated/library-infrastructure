resource "digitalocean_project" "global" {
  provider = digitalocean
  name     = var.name

  environment = "Production"
}
resource "digitalocean_project" "sandbox" {
  provider = digitalocean.sandbox
  name     = var.name

  environment = "Production"
}

output "name" {
  value = var.name
}
