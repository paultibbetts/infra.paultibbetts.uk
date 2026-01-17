#resource "mythic_beasts_pi" "web" {
# TODO: finish the provider
# TODO: add the definition here
# TODO: import the pi here
# TODO: rebuild it
#}

#resource "mythic_beasts_proxy" "web" {
# TODO: add the proxy to the provider
# TODO: add the definition here
# TODO: wire up the proxy to use the IPv6 of the Pi
#}

resource "ansible_host" "web" {
  name   = "pi"
  groups = ["web"]
  variables = {
    ansible_host = "ssh.pangolin.hostedpi.com"
    ansible_port = 5310
    ansible_user = "ops"
  }
}
