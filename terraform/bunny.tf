locals {
  media_hostname       = "media.${local.domain}"
  media_storage_region = "DE"
  media_s3_region      = lower(local.media_storage_region)
}

resource "bunnynet_storage_zone" "media" {
  name      = "paultibbetts-uk-media"
  region    = local.media_storage_region
  zone_tier = "Standard"
  type      = "S3"
}

resource "bunnynet_pullzone" "media" {
  name = "paultibbetts-uk-media"

  origin {
    type        = "StorageZone"
    storagezone = bunnynet_storage_zone.media.id
  }

  routing {
    tier = "Standard"
    zones = ["EU", "US"]
  }

  cache_enabled       = true
  cache_chunked       = true
  block_post_requests = true
  strip_cookies       = true
}

resource "bunnynet_pullzone_hostname" "media" {
  pullzone    = bunnynet_pullzone.media.id
  name        = local.media_hostname
  tls_enabled = true
  force_ssl   = true

  depends_on = [cloudflare_dns_record.record["media"]]
}

output "media_store" {
  value = {
    bucket          = bunnynet_storage_zone.media.name
    access_key      = bunnynet_storage_zone.media.name
    endpoint        = "https://${local.media_s3_region}-s3.storage.bunnycdn.com"
    public_base_url = "https://${local.media_hostname}"
    region          = local.media_s3_region
  }
}

output "media_store_secret_key" {
  value     = bunnynet_storage_zone.media.password
  sensitive = true
}
