terraform {
  required_providers {
    ansible = {
      source  = "ansible/ansible"
      version = "1.3.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.11"
    }
    #mythic_beasts = {
    #  source  = "TODO"
    #  version = "?"
    #}
  }
  required_version = "~> 1.14.3"
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
