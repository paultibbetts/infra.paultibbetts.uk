locals {
  pi_identifier = var.pi_identifier
  domain        = "paultibbetts.uk"
  subdomains = {
    apex = "@"
    www  = "www"
    dev  = "dev"
  }
}
resource "mythicbeasts_pi" "web" {
  identifier = local.pi_identifier
  disk_size  = 50
  model      = 4
  memory     = 4096
}

resource "mythicbeasts_proxy_endpoint" "endpoint" {
  for_each = local.subdomains

  domain         = local.domain
  hostname       = each.value
  address        = mythicbeasts_pi.web.ip
  site           = "all"
  proxy_protocol = true
}

resource "ansible_host" "web" {
  name   = "pi"
  groups = ["web"]
  variables = {
    ansible_host = "ssh.${mythicbeasts_pi.web.identifier}.hostedpi.com"
    ansible_port = mythicbeasts_pi.web.ssh_port
    ansible_user = "ops"
  }
}
