#!/bin/bash
# Setup netmgt configuration

ALLOWED_HOST=$(hostname)
SECRET_KEY=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-100})

NETMGT_ADMIN=${ADMIN_NETMGT:-$(mdata-get netmgt_admin 2>/dev/null)} || \
NETMGT_ADMIN=$(od -An -N8 -x /dev/random | head -1 | tr -d ' ');
mdata-put netmgt_admin ${NETMGT_ADMIN}

NETMGT_DEFAULT_NAMESERVERS=$(
	echo 'NETMGT_DEFAULT_NAMESERVERS = [';
	for nameserver in $(mdata-get netmgt_default_nameservers 1>/dev/null 2>&1); do
		echo "'${nameserver}', "
	done
	echo ']'
)

if mdata-get netmgt_hostmaster 1>/dev/null 2>&1; then
	NETMGT_HOSTMASTER='NETMGT_HOSTMASTER = "'$(mdata-get netmgt_hostmaster)'"'
else
	NETMGT_HOSTMASTER='NETMGT_HOSTMASTER = "hostmaster@'${ALLOWED_HOST}'"'
fi

NETMGT_DNS_TOKEN=${NETMGT_DNS_TOKEN:-$(mdata-get netmgt_dns_token 2>/dev/null)} || \
NETMGT_DNS_TOKEN=$(od -An -N8 -x /dev/random | head -1 | tr -d ' ');
mdata-put netmgt_dns_token ${NETMGT_DNS_TOKEN}

cat >> /opt/netmgt/netmgt_web/settings.py <<EOF
# Static files location
STATIC_ROOT = '/opt/netmgt/static'

# Make this unique, and don't share it with anybody.
SECRET_KEY = "${SECRET_KEY}"

# Allow only the hostname and localhost to access
ALLOWED_HOSTS = ['127.0.0.1', 'localhost', '${ALLOWED_HOST}']

# NETMGT
NETMGT_DEFAULT_TTL = 3600
NETMGT_SOA = {
	'refresh': '2d',
	'retry':   '15M',
	'expiry':  '2w',
	'minimum': '1h',
}
${NETMGT_DEFAULT_NAMESERVERS}
${NETMGT_HOSTMASTER}
NETMGT_DNS_TOKEN = '${NETMGT_DNS_TOKEN}'
EOF

# Init django data and create admin user
/opt/netmgt/manage.py migrate --noinput

# Create superadmin user
echo "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'admin@example.com', '${NETMGT_ADMIN}')" \
	| /opt/netmgt/manage.py shell || true

# Copy all static files to /opt/netmgt/static
/opt/netmgt/manage.py collectstatic --noinput

# Fix all permissions
chown -R www:www /opt/netmgt
chown -R www:www /var/db/netmgt
