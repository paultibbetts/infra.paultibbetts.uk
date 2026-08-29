terraform {
  required_providers {
    ansible = {
      source  = "ansible/ansible"
      version = "1.5.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.11"
    }
    bunnynet = {
      source  = "BunnyWay/bunnynet"
      version = "~> 0.15"
    }
    mythicbeasts = {
      source  = "paultibbetts/mythicbeasts"
      version = "0.1.0"
    }
  }
  required_version = "~> 1.15.0"
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

provider "bunnynet" {
  api_key = var.bunnynet_api_key
}
