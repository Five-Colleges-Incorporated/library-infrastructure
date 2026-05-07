resource "digitalocean_project" "infrastructure" {
  name = "infrastructure"

  # TODO: maybe encapsulate this because it is noisy
  environment = "Production"
}
