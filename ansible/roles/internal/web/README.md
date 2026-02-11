Web Role
========

Prepares a deploy user and directory structure for static site deployments under `web_sites_root`.

What this role configures
-------------------------

- Installs `rsync`.
- Ensures deploy group and deploy user exist.
- Ensures `~/.ssh` exists for the deploy user and installs authorized keys.
- For each site in `web_sites`, prepares deploy-helper layout under:
  - `<site_root>/releases`
  - `<site_root>/shared`
  - `<site_root>/current` (symlink target)
- If `<site_root>/current` does not exist, creates an initial timestamped release with a placeholder `index.html` and finalizes the symlink.
- Keeps `web_keep_releases` releases when finalizing initial bootstrap.

Requirements
------------

- Apt-based target hosts (role uses `ansible.builtin.apt`).
- Privilege escalation: playbook should run with `become: true`.
- Collections:
  - `community.general` (uses `community.general.deploy_helper`)

Role Variables
--------------

Defaults from `defaults/main.yml`:

| Variable | Default | Description |
| --- | --- | --- |
| `web_group` | `web` | Group used for deploy user and site directories. |
| `web_deploy_user` | `deploy` | Deploy user account name. |

Required variables (no defaults in this role):

| Variable | Type | Description |
| --- | --- | --- |
| `web_deploy_home` | string | Home directory path for deploy user. |
| `web_deploy_ssh_keys` | list(string) | SSH public keys authorized for deploy user. |
| `web_sites_root` | string | Base directory for all site deploy paths (for example `/srv/www`). |
| `web_sites` | list(string) | Site names; each site path is `<web_sites_root>/<site>`. |
| `web_keep_releases` | int | Number of releases to retain when finalizing a release. |

Example Variables
-----------------

```yaml
# group_vars/all/main.yaml
web_sites_root: "/srv/www"
web_sites:
  - "paultibbetts.uk"
  - "dev.paultibbetts.uk"

web_deploy_user: "deploy"
web_deploy_home: "/home/deploy"
web_deploy_ssh_keys:
  - "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAA..."
web_group: "deploy"
web_keep_releases: 3
```

Example Playbook
----------------

```yaml
- hosts: pi
  become: true
  roles:
    - { role: web, tags: [web] }
```

Notes
-----

- This role bootstraps deploy structure and an initial placeholder release only when `current` is missing.
- It does not publish new releases on subsequent runs when `current` already exists.
