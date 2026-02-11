Server Role
===========

Baseline Debian/Ubuntu server configuration for hosts in this infrastructure.

What this role configures
-------------------------

- Verifies the host is in the Debian OS family.
- Refreshes apt cache.
- Sets hostname from inventory (with optional overrides).
- Installs baseline packages: `ca-certificates`, `curl`, `gnupg`.
- Installs and enables OpenSSH server.
- Disables SSH password/challenge authentication via `/etc/ssh/sshd_config.d/10-disable-passwords.conf`.
- Ensures `systemd-timesyncd` is enabled.
- Enables unattended security upgrades.
- Manages local users, SSH authorized keys, and optional passwordless sudo.

Requirements
------------

- Target OS: Debian/Ubuntu.
- Privilege escalation: playbook should run with `become: true`.
- Collections:
  - `ansible.posix` (used for `authorized_key`)

Role Variables
--------------

Defaults from `defaults/main.yml`:

| Variable | Default | Description |
| --- | --- | --- |
| `server_default_shell` | `/bin/bash` | Default shell for managed users if `item.shell` is not set. |
| `server_sudo_group` | `sudo` | Group used when a user has `sudo: true`. |
| `server_users` | `[]` | List of users to manage. |

Optional host/group vars used by hostname tasks:

| Variable | Default | Description |
| --- | --- | --- |
| `hostname_short` | `inventory_hostname_short` | Short system hostname. |
| `hostname_fqdn` | `inventory_hostname` | FQDN written with short hostname to `/etc/hosts`. |

`server_users` schema
---------------------

Each item in `server_users` supports:

| Key | Required | Default | Description |
| --- | --- | --- | --- |
| `name` | yes | n/a | Username. |
| `state` | no | `present` | User state (`present`/`absent`). |
| `shell` | no | `server_default_shell` | User shell path. |
| `sudo` | no | `false` | Adds user to `server_sudo_group`. |
| `sudo_nopasswd` | no | `false` | Creates `/etc/sudoers.d/90-<name>` with NOPASSWD sudo. |
| `extra_groups` | no | `[]` | Additional groups for the user. |
| `pubkeys` | no | `[]` | SSH public keys to authorize for that user. |
| `password` | no | unset | Password value that is hashed by the role before applying. |

Example Variables
-----------------

```yaml
# group_vars/all/main.yaml or host_vars/<host>.yaml
hostname_short: pi
hostname_fqdn: pi.example.internal

server_users:
  - name: paul
    sudo: true
    sudo_nopasswd: true
    extra_groups: ["docker"]
    pubkeys:
      - "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAA..."
```

Example Playbook
----------------

```yaml
- hosts: pi
  become: true
  roles:
    - { role: server, tags: [server] }
```

Notes
-----

- This role does not manage firewall rules.
- SSH password login is disabled by default by this role, so ensure users have valid SSH keys in `server_users[*].pubkeys` before applying to remote hosts.
- On very fresh hosts, `ansible-playbook --check` can fail before package tasks if `python3-apt` is missing. Run a normal bootstrap once, or install `python3-apt` in `pre_tasks` before role execution.

Check Mode Bootstrap Example
----------------------------

```yaml
- hosts: pi
  become: true
  pre_tasks:
    - name: Ensure python3-apt exists for apt check mode on fresh hosts
      ansible.builtin.raw: |
        test -e /usr/lib/python3/dist-packages/apt || (apt-get update && apt-get install -y python3-apt)
      changed_when: false
  roles:
    - { role: server, tags: [server] }
```
