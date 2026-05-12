data "digitalocean_spaces_bucket_object" "encrypted_secrets" {
  key    = var.key
  bucket = var.secret_store
  region = "nyc3"

  lifecycle {
    postcondition {
      condition     = self.body != null
      error_message = "Encrypted secret body was null."
    }
  }
}

data "sops_external" "decrypted_secrets" {
  source     = data.digitalocean_spaces_bucket_object.encrypted_secrets.body
  input_type = "json"
}

output "values" {
  value     = data.sops_external.decrypted_secrets.data
  sensitive = true
}
