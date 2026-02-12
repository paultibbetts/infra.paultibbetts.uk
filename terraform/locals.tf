locals {
  domain = "paultibbetts.uk"

  web_subdomains = {
    apex  = "@"
    www   = "www"
    infra = "infra"
    dev   = "dev"
  }

  proxy_records = {
    for key, host in local.web_subdomains : key => {
      type    = "CNAME"
      name    = host
      content = "proxy.mythic-beasts.com"
    }
  }

  records = merge(
    local.proxy_records,
    {
      micro = {
        type    = "CNAME"
        name    = "micro"
        content = "eu.micro.blog"
      }

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
  )
}

