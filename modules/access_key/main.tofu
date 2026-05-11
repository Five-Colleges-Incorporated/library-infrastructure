resource "digitalocean_spaces_key" "created_key" {
  name = local.name
  dynamic "grant" {
    for_each = var.buckets

    bucket     = each.value.bucket
    permission = each.value.readonly ? "read" : "readwrite"
  }
}
