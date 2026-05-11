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

  encryption {
    method "external" "age" {
      # TODO: Switch to using the .sops.yaml file
      encrypt_command = ["tofu-age-encryption", "--encrypt",
        "--recipient", "age1hyrn327p0ke8j9jjgf09agma446ah0n3umerftkrasrn5e8qla2qqau9sf",
        "--recipient", "age1dgtl76dv8nyuvyhkp954fjaqa7ueyrqswdjjl6lp2nt8v46u249sh2w2pu",
        "--recipient", "age1flzetpexjgxtqrtjerrrqump69x0554zaarr43me7ew7v3x8acgsd998ge",
      ]
      decrypt_command = ["tofu-age-encryption", "--decrypt"]
    }
    state {
      method = method.external.age
    }
  }

  required_providers {
    digitalocean = {
      source  = "opentofu/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
}

variable "LIBRARIES_PRODUCTION_DIGITALOCEAN_ACCESS_TOKEN" {
  type = string
}
provider "digitalocean" {
  alias = "production"
  token = var.LIBRARIES_PRODUCTION_DIGITALOCEAN_ACCESS_TOKEN
}

variable "LIBRARIES_DEVELOPMENT_DIGITALOCEAN_ACCESS_TOKEN" {
  type = string
}
provider "digitalocean" {
  alias = "development"
  token = var.LIBRARIES_DEVELOPMENT_DIGITALOCEAN_ACCESS_TOKEN
}
