locals {
  env         = lookup({ "sandbox" = "sand", "production" = "prod", "sensitive" = "sens" }, var.environment)
  iter        = format("%02d", var.iteration)
  bucket_name = "fclib-${local.env}-${lower(var.application)}-${var.school}-${lower(var.purpose)}-${local.iter}"
}

resource "digitalocean_spaces_bucket" "created_bucket" {
  name   = local.bucket_name
  region = "nyc3"
  count  = var.create ? 1 : 0
}

data "digitalocean_spaces_bucket" "found_bucket" {
  name   = local.bucket_name
  region = "nyc3"
  count  = var.create ? 0 : 1
}

output "name" {
  value = var.create ? digitalocean_spaces_bucket.created_bucket : data.digitalocean_spaces_bucket.found_bucket
}
