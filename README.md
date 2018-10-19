# ansible-role-nfs_server_openbsd

Configure NFS services.

# Requirements

None

# Role Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `nfs_server_openbsd_exports` | Content of [`export(5)`](https://man.openbsd.org/exports) | `""` |
| `nfs_server_openbsd_portmap_flags` | Optional flags for [`portmap(8)`](https://man.openbsd.org/portmap) | `""` |
| `nfs_server_openbsd_mountd_flags` | Optional flags for [`mountd`](https://man.openbsd.org/mountd) | `""` |
| `nfs_server_openbsd_nfsd_flags` | Optional flags for [`nfsd`](https://man.openbsd.org/nfsd) | `""` |

# Dependencies

None

# Example Playbook

```yaml
- hosts: localhost
  roles:
    - ansible-role-nfs_server_openbsd
  vars:
    nfs_server_openbsd_nfsd_flags: -tun 7
    nfs_server_openbsd_exports: |
      /docs -alldirs -ro -network=10.0.0 -mask=255.255.255.0
```

# License

```
Copyright (c) 2018 Tomoyuki Sakurai <y@trombik.org>

Permission to use, copy, modify, and distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
```

# Author Information

Tomoyuki Sakurai <y@trombik.org>

This README was created by [qansible](https://github.com/trombik/qansible)
