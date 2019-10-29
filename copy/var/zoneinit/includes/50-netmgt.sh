#!/bin/bash
# Setup netmgt configuration

ALLOWED_HOST=$(hostname)
SECRET_KEY=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-100})

NETMGT_ADMIN_INITIAL_PW=$(/opt/core/bin/mdata-create-password.sh -m netmgt_admin_initial_pw)
NETMGT_DNS_TOKEN=$(/opt/core/bin/mdata-create-password.sh -m netmgt_dns_token)
NETMGT_DEFAULT_NAMESERVERS=$(
	echo 'NETMGT_DEFAULT_NAMESERVERS = [';
	for nameserver in $(mdata-get netmgt_default_nameservers 2>/dev/null); do
		echo "'${nameserver}', "
	done
	echo ']'
)

NETMGT_HOSTMASTER='NETMGT_HOSTMASTER = "hostmaster@'${ALLOWED_HOST}'"'
if mdata-get netmgt_hostmaster 1>/dev/null 2>&1; then
	NETMGT_HOSTMASTER='NETMGT_HOSTMASTER = "'$(mdata-get netmgt_hostmaster)'"'
fi

NETMGT_EXPORT_PREFIX=${NETMGT_EXPORT_PREFIX:-$(mdata-get netmgt_export_prefix 2>/dev/null)} || \
NETMGT_EXPORT_PREFIX=$(mdata-get sdc:uuid);
mdata-put netmgt_export_prefix ${NETMGT_EXPORT_PREFIX}

cat >> /opt/netmgt/netmgt_web/settings.py <<EOF
# Static files location
STATIC_ROOT = '/opt/netmgt/static'

# Make this unique, and don't share it with anybody.
SECRET_KEY = "${SECRET_KEY}"

# Allow only the hostname and localhost to access
ALLOWED_HOSTS = ['127.0.0.1', 'localhost', '${ALLOWED_HOST}']

# NETMGT
NETMGT_DEFAULT_TTL = 3600
NETMGT_DEFAULT_NAMESERVERS_TTL = 86400
NETMGT_SOA = {
	'refresh': '2d',
	'retry':   '15M',
	'expiry':  '2w',
	'minimum': '1h',
}
${NETMGT_DEFAULT_NAMESERVERS}
${NETMGT_HOSTMASTER}
NETMGT_DNS_TOKEN = '${NETMGT_DNS_TOKEN}'
NETMGT_EXPORT_PREFIX = '${NETMGT_EXPORT_PREFIX}'
EOF

# Init django data and create admin user
/opt/netmgt/manage.py migrate --noinput --fake-initial

# Create superadmin user
cat <<eof | /opt/netmgt/manage.py shell
from django.contrib.auth import get_user_model
user = get_user_model()
user.objects.filter(username="admin").exists() or \
    user.objects.create_superuser("admin", "", "${NETMGT_ADMIN_INITIAL_PW}")
eof

# Copy all static files to /opt/netmgt/static
/opt/netmgt/manage.py collectstatic --noinput

# Fix all permissions
chown -R www:www /opt/netmgt
chown -R www:www /var/db/netmgt

# Enable gunicorn netmgt service
svcadm enable svc:/network/gunicorn:netmgt
