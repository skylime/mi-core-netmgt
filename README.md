# mi-core-netmgt

This repository is based on [Joyent mibe](https://github.com/joyent/mibe). Please note this repository should be build with the [mi-core-base](https://github.com/skylime/mi-core-base) mibe image.

## mdata variables

- `nginx_ssl`: ssl certificate for the web interface
- `netmgt_initial_admin`: password for django admin user
- `netmgt_default_nameservers`: list of default nameservers separated by space
- `netmgt_hostmaster`: email address of hostmaster
- `netmgt_dns_token`: dns export token
- `netmgt_export_prefix`: export prefix for zones folder

## services

- `80/tcp`: http webserver
- `443/tcp`: https webserver
