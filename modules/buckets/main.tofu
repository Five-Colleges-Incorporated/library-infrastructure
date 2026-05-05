locals {
  env         = lookup({ "sandbox" = "test", "production" = "prod", "administrative" = "admn" }, var.environment)
  iter        = format("%02d", var.iteration)
  bucket_name = coalesce(var.name_override, "fclib-${local.env}-${lower(var.application)}-${var.school}-${lower(var.purpose)}-${local.iter}")

  versioning_rules = var.noncurrent_version_expiration == null ? [] : [true]
}

resource "digitalocean_spaces_bucket" "created_bucket" {
  count = var.create ? 1 : 0

  name          = locals.bucket_name
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

data "digitalocean_spaces_bucket" "found_bucket" {
  count = var.create ? 0 : 1

  name   = local.bucket_name
  region = "nyc3"
}

output "name" {
  value = var.create ? digitalocean_spaces_bucket.created_bucket : data.digitalocean_spaces_bucket.found_bucket
}
