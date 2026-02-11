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
    mythicbeasts = {
      source  = "paultibbetts/mythicbeasts"
      version = "0.1.0"
    }
  }
  required_version = "~> 1.14.3"
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
