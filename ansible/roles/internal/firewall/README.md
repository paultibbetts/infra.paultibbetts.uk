Firewall Role
=============

Configures a host firewall using UFW with a deny-by-default inbound policy while keeping required access for SSH and web traffic.

This role is designed for safe remote rollout:

- allow rules are applied first
- default incoming policy is applied after allow rules
- default outgoing/routed policies are optional (`firewall_manage_outgoing_policy`, `firewall_manage_routed_policy`)
- firewall is enabled last

Requirements
------------

- Debian/Ubuntu target host.
- `become: true`.
- Collection: `community.general` (for `community.general.ufw`).

Role Variables
--------------

Defaults from `defaults/main.yml`:

| Variable | Default | Description |
| --- | --- | --- |
| `firewall_enabled` | `true` | Whether UFW should be enabled. |
| `firewall_ipv6` | `true` | Sets `IPV6=yes/no` in `/etc/default/ufw`. Keep this `true` for Mythic Beasts style IPv6 access. |
| `firewall_allow_potential_lockout` | `false` | Safety override. Role refuses `incoming: deny` without SSH allow unless this is `true`. |
| `firewall_default_incoming_policy` | `deny` | Default policy for incoming traffic. |
| `firewall_default_outgoing_policy` | `allow` | Default policy for outgoing traffic. |
| `firewall_default_routed_policy` | `deny` | Default policy for routed/forwarded traffic. |
| `firewall_manage_outgoing_policy` | `false` | Whether to actively apply `firewall_default_outgoing_policy`. Disabled by default for a minimal rollout profile. |
| `firewall_manage_routed_policy` | `false` | Whether to actively apply `firewall_default_routed_policy`. Disabled by default because some hosts can hang on `ufw default ... routed`. |
| `firewall_allow_ssh` | `true` | Manage SSH allow rule(s). |
| `firewall_ssh_port` | `"22"` | SSH destination port to allow. |
| `firewall_allow_ansible_port` | `true` | Also allow `ansible_port` used by the current connection. Useful when SSH is proxied/non-22. |
| `firewall_ssh_proto` | `tcp` | SSH protocol. |
| `firewall_ssh_sources` | `[]` | Source CIDRs allowed for SSH. Empty means any source. |
| `firewall_web_tcp_ports` | `["80", "443"]` | TCP ports to allow for web traffic. |
| `firewall_extra_rules` | `[]` | Extra UFW rules (list of dicts). |
| `firewall_rollback_enabled` | `true` | Schedules automatic `ufw disable` during enforce and cancels it on success. |
| `firewall_rollback_delay_seconds` | `180` | Rollback delay window in seconds. |
| `firewall_command_timeout_seconds` | `30` | Async timeout (seconds) for `ufw default` and `ufw enable/disable` commands during enforce. |

`firewall_extra_rules` schema
-----------------------------

Each entry can include:

| Key | Required | Example |
| --- | --- | --- |
| `rule` | yes | `allow`, `deny`, `limit`, `reject` |
| `direction` | no | `incoming`, `outgoing`, `routed` |
| `src` | no | `10.0.0.0/24` |
| `dest` | no | `any` |
| `port` | no | `"51820"` |
| `proto` | no | `udp` |
| `comment` | no | `Allow WireGuard` |
| `route` | no | `true` |

Example Playbook
----------------

```yaml
- hosts: pi
  become: true
  serial: 1
  roles:
    - { role: firewall, tags: [firewall] }
```

Example Variables
-----------------

```yaml
# group_vars/all/main.yaml
firewall_ssh_sources: []
firewall_web_tcp_ports:
  - "80"
  - "443"

firewall_extra_rules:
  - rule: allow
    port: "51820"
    proto: udp
    comment: "Allow WireGuard"
```

Safe Rollout
------------

Use a two-phase apply for remote hosts:

1. `ansible-playbook site.yaml --tags firewall_prep --limit pi -f 1`
2. Verify you can still open a fresh SSH session.
3. `ansible-playbook site.yaml --tags firewall_enforce --limit pi -f 1`

Enforce Safety
--------------

During `firewall_enforce`, the role starts a temporary rollback timer on the host (`ufw --force disable` after delay) and cancels it at the end if the play succeeds.
If connectivity breaks mid-run, the rollback should restore access automatically.

Check Mode Note
---------------

On a host where `ufw` is not installed yet, first-run `--check` cannot validate rule tasks because the `ufw` binary is missing.
Run `firewall_prep` once without `--check`, then rerun in check mode.

Notes
-----

- If you rely on IPv6 for SSH reachability, keep `firewall_ipv6: true`.
- For stricter SSH exposure, set `firewall_ssh_sources` to known CIDRs instead of leaving it open.
- The role includes a lockout guard and will fail if you set `incoming: deny` while disabling SSH rules, unless you explicitly set `firewall_allow_potential_lockout: true`.
- By default, SSH rules include both `firewall_ssh_port` and `ansible_port` to better match proxied/provider access paths.
