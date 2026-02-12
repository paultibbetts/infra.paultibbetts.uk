locals {
  default_ttl     = 1 # auto
  default_proxied = false
}

data "cloudflare_zones" "zones" {
  name = local.domain
}

resource "cloudflare_dns_record" "record" {
  for_each = local.records

  zone_id = data.cloudflare_zones.zones.result[0].id

  name    = each.value.name
  type    = each.value.type
  content = each.value.content

  ttl     = try(each.value.ttl, local.default_ttl)
  proxied = try(each.value.proxied, local.default_proxied)

  priority = try(each.value.priority, null)
}
