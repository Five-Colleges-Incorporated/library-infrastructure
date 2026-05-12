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

resource "terraform_data" "key_upload" {
  provisioner "local-exec" {
    command = "echo '${jsonencode(digitalocean_spaces_key.created_key)}' | sops --encrypt --filename-override access_key.json /dev/stdin | aws s3 cp --endpoint-url https://nyc3.digitaloceanspaces.com - s3://${var.secret_store}/access_keys/${local.name}.json"
  }
  lifecycle {
    ignore_changes = all
  }
}
