variable "encryption_passphrase" {
  type      = string
  sensitive = true
}

terraform {
  encryption {
    key_provider "pbkdf2" "pbkdf2_key_provider" {
      passphrase = var.encryption_passphrase
    }
    method "aes_gcm" "aes_gcm_method" {
      keys = key_provider.pbkdf2.pbkdf2_key_provider
    }
    state {
      method   = method.aes_gcm.aes_gcm_method
      enforced = true
    }
  }

  backend "s3" {
    bucket = "fivecolleges-library-infrastructure-1"
    key    = "libraries-integrations.tfstate"
    endpoints = {
      s3 = "nyc3.digitaloceanspaces.com"
    }

    # s3 compatibility
    skip_credentials_validation = "true"
    region                      = "us-east-1"
  }
}
