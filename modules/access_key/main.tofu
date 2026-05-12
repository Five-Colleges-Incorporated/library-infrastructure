resource "digitalocean_spaces_key" "created_key" {
  name = local.name

  dynamic "grant" {
    for_each = var.writeable_buckets
    content {
      bucket     = grant.value
      permission = "readwrite"
    }
  }

  dynamic "grant" {
    for_each = var.readonly_buckets
    content {
      bucket     = grant.value
      permission = "read"
    }
  }
}

# In order to delete the key during teardown we're creating a placeholder
# This object gets overwritten with the actual key once it is encrypted
resource "digitalocean_spaces_bucket_object" "placeholder" {
  region       = "nyc3"
  bucket       = var.secret_store
  key          = "access_keys/${local.name}.json"
  content      = "{}"
  content_type = "application/json"
}

resource "terraform_data" "key_upload" {
  input = "s3://${var.secret_store}/${digitalocean_spaces_bucket_object.placeholder.key}"
  provisioner "local-exec" {
    command = "echo '${jsonencode(digitalocean_spaces_key.created_key)}' | sops --encrypt --filename-override access_key.json /dev/stdin | aws s3 cp --content-type 'application/json' --endpoint-url 'https://nyc3.digitaloceanspaces.com' - '${self.input}'"
  }
}
