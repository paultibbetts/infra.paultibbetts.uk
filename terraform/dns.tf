locals {
  zone = "paultibbetts.uk"

  default_ttl     = 1 # auto
  default_proxied = false

  records = {

    # paultibbetts.uk

    #apex4 = {
    #  type    = "A"
    #  name    = "@"                          # TODO: check
    #  content = mythic_beasts_proxy.web.ipv4 # TODO: check
    #}

    #apex6 = {
    #  type    = "AAAA"
    #  name    = "@"                       # TODO: check
    #  content = mythic_beasts_pi.web.ipv6 # TODO: check
    #}

    # CNAME

    www = {
      type    = "CNAME"
      name    = "www"
      content = "paultibbetts.uk"
    }

    micro = {
      type    = "CNAME"
      name    = "micro"
      content = "eu.micro.blog"
    }

    # TXT

    atproto = {
      type    = "TXT"
      name    = "_atproto"
      content = "did=did:plc:adwdgyaga5q2psrjbvo4pndr"
    }

    github_pages_challenge = {
      type    = "TXT"
      name    = "_github-pages-challenge-paultibbetts"
      content = "0d468c5988c95ab09a88f0c494dcb9"
    }

    mythic_beasts_challenge = {
      type    = "TXT"
      name    = "_mythic-beasts-challenge"
      content = "T7eS19QKZV6VOo0og5sn2OmKDoem4dLL7IgT9tJLT7c"
    }

    openai_domain_verification = {
      type    = "TXT"
      name    = "@"
      content = "openai-domain-verification=dv-CPJLyYLfDZ990DDlefMkxdkN"
    }

    # Apple iCloud email
    # https://support.apple.com/en-gb/102374

    apple_domain_verificaton = {
      type    = "TXT"
      name    = "@"
      content = "apple-domain=JTK5xOaQo9cwujIv"
    }

    spf = {
      type    = "TXT"
      name    = "@"
      content = "v=spf1 include:icloud.com ~all"
    }

    mx_icloud_01 = {
      type     = "MX"
      name     = "@"
      content  = "mx01.mail.icloud.com"
      priority = 10
    }

    mx_icloud_02 = {
      type     = "MX"
      name     = "@"
      content  = "mx02.mail.icloud.com"
      priority = 10
    }

    dkim_sig1 = {
      type    = "CNAME"
      name    = "sig1._domainkey"
      content = "sig1.dkim.paultibbetts.uk.at.icloudmailadmin.com"
    }

  }
}

data "cloudflare_zones" "zones" {
  name = local.zone
}

#resource "cloudflare_dns_record" "paultibbettsuk" {
#  zone_id = data.cloudflare_zones.zones.result[0].id

#  name    = "@"
#  type    = "A"
#  content = mythic_beasts_proxy.pi.ipv4

#  ttl     = 1
#  proxied = false
#}

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
