resource "digitalocean_spaces_bucket" "created_bucket" {
  count = var.create ? 1 : 0

  name          = local.bucket_name
  force_destroy = var.force_destroy

  # DigitalOcean smashes together lifecycle rules by prefix
  # This results in drift and plan noise
  # All the dynamics here are to generate a configuration that DO
  # leaves well enough alone
  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rules

    content {
      enabled = true
      id      = lifecycle_rule.value[0]
      prefix  = lifecycle_rule.value[1]
      expiration {
        days = lifecycle_rule.value[2]
      }
      abort_incomplete_multipart_upload_days = 7

      dynamic "noncurrent_version_expiration" {
        for_each = local.versioning_enabled ? [true] : []
        content {
          days = var.noncurrent_version_expiration
        }
      }
    }
  }

  dynamic "lifecycle_rule" {
    for_each = local.versioning_enabled && length(var.lifecycle_rules) > 0 ? [true] : []

    content {
      enabled = true
      id      = "object_delete_marker"
      expiration {
        expired_object_delete_marker = true
      }
    }
  }

  dynamic "lifecycle_rule" {
    for_each = length(var.lifecycle_rules) == 0 ? [true] : []

    content {
      enabled = true
      id      = "default"
      dynamic "expiration" {
        for_each = local.versioning_enabled ? [true] : []

        content {
          expired_object_delete_marker = true
        }
      }
      abort_incomplete_multipart_upload_days = 7

      dynamic "noncurrent_version_expiration" {
        for_each = local.versioning_enabled ? [true] : []
        content {
          days = var.noncurrent_version_expiration
        }
      }
    }
  }

  versioning {
    enabled = local.versioning_enabled
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
  force_destroy = true

  lifecycle_rule {
    id      = "default"
    enabled = true

    abort_incomplete_multipart_upload_days = 1

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
  logging_bucket = concat(digitalocean_spaces_bucket.logging_bucket, data.digitalocean_spaces_bucket.logging_bucket)
}
resource "digitalocean_spaces_bucket_logging" "access_logs" {
  count = length(local.logging_bucket)

  region        = "nyc3"
  bucket        = digitalocean_spaces_bucket.created_bucket[0].id
  target_bucket = local.logging_bucket[0].id
  target_prefix = "${local.bucket_name}/"
}

data "digitalocean_project" "project" {
  count = var.create ? 1 : 0

  name = local.do_project
}
resource "digitalocean_project_resources" "project_spaces" {
  count = length(data.digitalocean_project.project)

  project   = data.digitalocean_project.project[0].id
  resources = [for b in concat(digitalocean_spaces_bucket.created_bucket, digitalocean_spaces_bucket.logging_bucket) : b.urn]
}

output "created_bucket" {
  value = length(digitalocean_spaces_bucket.created_bucket) == 0 ? null : digitalocean_spaces_bucket.created_bucket[0]
}
output "logging_bucket" {
  value = length(local.logging_bucket) == 0 ? null : local.logging_bucket
}
