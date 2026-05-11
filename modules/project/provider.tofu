terraform {
  required_providers {
    digitalocean = {
      source  = "opentofu/digitalocean"
      version = "~> 2.0"

      configuration_aliases = [
        digitalocean.global,
        digitalocean.production,
        digitalocean.development
      ]
    }
  }
}
