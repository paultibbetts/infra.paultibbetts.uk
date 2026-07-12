variable "cloudflare_api_token" {
  type        = string
  description = "api token"
}

variable "bunnynet_api_key" {
  type        = string
  sensitive   = true
  description = "bunny.net account API key"
}

variable "pi_identifier" {
  type        = string
  description = "the identifier of the Pi to use"
}
