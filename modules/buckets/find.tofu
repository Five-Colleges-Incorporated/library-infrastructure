data "digitalocean_spaces_bucket" "found_bucket" {
  count = var.create ? 0 : 1

  name   = local.bucket_name
  region = "nyc3"
}

output "found_bucket" {
  value = length(digitalocean_spaces_bucket.found_bucket) == 0 ? null : digitalocean_spaces_bucket.found_bucket[0]
}
