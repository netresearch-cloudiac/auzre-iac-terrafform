# Terraform sample for Azure AD login for VMs

- [*] Login to linux VM with Azure AD id
- [*] Login to Windows VM with Azure AD id
- [] Azure SQL with Azure AD id for Admin
- [] Azure SQL with Azure AD id for App connection

# Wiregaurd
```shell

                  ┌─────── WireGuard tunnel ──────┐
                  │         192.168.6.0/24        │
                  │                               │
   192.168.6.2 wgA│               xx              │wgB 192.168.6.1
                ┌─┴─┐          xxx  xxxx        ┌─┴─┐
 Home site      │   │ext     xx        xx    ext│   │  Azure site
                │   ├───    x           x    ───┤   │
192.168.1.0/24  │   │      xx           xx      │   │  172.18.2.0/24
                │   │      x             x      │   │
                └─┬─┘      x              x     └─┬─┘
       192.168.1.1│        xx             x       │172.18.2.1
...┌─────────┬────┘          xx   xxx    xx       └───┬─────────┐...
   │         │                  xx   xxxxx            │         │
   │         │                                        │         │
 ┌─┴─┐     ┌─┴─┐           public internet          ┌─┴─┐     ┌─┴─┐
 │   │     │   │                                    │   │     │   │
 └───┘     └───┘                                    └───┘     └───┘

```

- Routing on the Azure side is not working.
