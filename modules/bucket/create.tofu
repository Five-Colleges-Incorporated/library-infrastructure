resource "digitalocean_spaces_bucket" "created_bucket" {
  count = var.create ? 1 : 0

  name          = local.bucket_name
  force_destroy = var.force_destroy

  lifecycle_rule {
    id      = "multipart_upload"
    enabled = true

    abort_incomplete_multipart_upload_days = 7
  }

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rules

    content {
      id     = lifecycle_rule.value[0]
      prefix = lifecycle_rule.value[1]
      expiration {
        days = lifecycle_rule.value[2]

        expired_object_delete_marker = var.noncurrent_version_expiration != null
      }
      enabled = true
    }
  }

  dynamic "lifecycle_rule" {
    for_each = local.versioning_rules
    content {
      id      = "noncurrent_version"
      enabled = true

      noncurrent_version_expiration {
        days = var.noncurrent_version_expiration
      }
    }
  }
  versioning {
    enabled = var.noncurrent_version_expiration != null
  }

  # TODO: Figure out if we need multi-region support
  region = "nyc3"
  # TODO: When creating public buckets is supported
  # also implement spaces_bucket_cors_configuration
  acl = "private"
}

resource "digitalocean_spaces_bucket" "logging_bucket" {
  count = var.create && local.create_logging_bucket ? 1 : 0

  name          = "${local.bucket_name}-accesslogs"
  force_destroy = var.force_destroy

  lifecycle_rule {
    id      = "multipart_upload"
    enabled = true

    abort_incomplete_multipart_upload_days = 1
  }

  lifecycle_rule {
    id      = "default"
    enabled = true

    expiration {
      days = 365
    }
  }

  # TODO: Figure out if we need multi-region support
  region = "nyc3"
  acl    = "private"
}
data "digitalocean_spaces_bucket" "logging_bucket" {
  count = var.create && !local.create_logging_bucket && var.logging_bucket_name != null ? 1 : 0

  name   = var.logging_bucket_name
  region = "nyc3"
}

locals {
  logging_bucket = length(digitalocean_spaces_bucket.logging_bucket) > 0 ? digitalocean_spaces_bucket.logging_bucket : (length(data.digitalocean_spaces_bucket.logging_bucket) > 0 ? data.digitalocean_spaces_bucket.logging_bucket : [])
}
resource "digitalocean_spaces_bucket_logging" "access_logs" {
  count = length(local.logging_bucket)

  region        = "nyc3"
  bucket        = digitalocean_spaces_bucket.created_bucket[0].id
  target_bucket = local.logging_bucket[0].id
  target_prefix = "${local.bucket_name}/"
}

output "created_bucket" {
  value = length(digitalocean_spaces_bucket.created_bucket) == 0 ? null : digitalocean_spaces_bucket.created_bucket[0]
}
output "logging_bucket" {
  value = length(local.logging_bucket) == 0 ? null : local.logging_bucket
}
