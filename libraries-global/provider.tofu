terraform {
  backend "s3" {
    bucket = "fclib-admn-infrastructure-5c-state-01"
    key    = "libraries-global.tfstate"
    endpoints = {
      s3 = "https://nyc3.digitaloceanspaces.com"
    }

    # DO specific config
    skip_credentials_validation = true
    region                      = "us-east-1"
  }

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}
