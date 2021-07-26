# Changelog

## 20.4.0

### New

* Upgrade to the latest core-base LTS 20.4 image and switch to Python 3.8. [Thomas Merkel]
* Support IPv6 localhost. [Thomas Merkel]

### Fix

* Add missing migrate command. [Thomas Merkel]

## 18.4.0

### New

* Django-netmgt version bump to 0.0.13 with API and caching support. [Thomas Merkel]
* Add Lets Encrypt support to nginx configuration file. [Thomas Merkel]

### Fix

* Fix missing NETMGT_DEFAULT_NAMESERVERS_TTL. [Thomas Merkel]
* Remove dns from the socket name in gunicorn. [Thomas Merkel]

### Other

* Use tooling from core-base to setup netmgt. [Thomas Merkel]
* Using manifest.json by default. [Thomas Merkel]
  Implement some tools provided in the core-base 18.4.x, additional cleanup and license updates

## 14.2.4

### Other

* bump image version. [Sebastian Wiedenroth]
      new netmgt version reverts to the classic django theme
* version bump for netmgt. [Sebastian Wiedenroth]

## 14.2.3

### Other

* version update. [Thomas Merkel]
* version update which supports export prefix. [Thomas Merkel]
* support NETMGT_EXPORT_PREFIX as mdata. [Thomas Merkel]
* add template path. [Thomas Merkel]

## 14.2.2

### New

* version update for netmgt. [Thomas Merkel]

### Other

* version bump. [Thomas Merkel]
* version update of netmgt, fix typo for mdata-get nameservers. [Thomas Merkel]

## 14.2.1

### Fix

* variable name for password. [Thomas Merkel]
* settings for database because /var/db already used. [Thomas Merkel]
* typo for db file. [Thomas Merkel]
* url for downloading. [Thomas Merkel]

### Other

* Version update to first stable edition. [Thomas Merkel]
* Add lazy temporary redirect. [Thomas Merkel]
* version update of netmgt. [Thomas Merkel]
* fix typo. [Thomas Merkel]
* version update. [Thomas Merkel]
* fix user creation if exists. [Thomas Merkel]
* static file collection. [Thomas Merkel]
* add static url for nginx. [Thomas Merkel]
* we also need py27-expat. [Thomas Merkel]
* add nginx ssl setup. [Thomas Merkel]
* enable service later. [Thomas Merkel]
* use latest version for base. [Thomas Merkel]
* we need sqlite3. [Thomas Merkel]
* Modify to use unix socket. [Thomas Merkel]
* Add nginx setup. [Thomas Merkel]
* Add script to configure netmgt basic setup. [Thomas Merkel]
* Copy basic settings and overwrite project settings. [Thomas Merkel]
* Add production netmgt settings file. [Thomas Merkel]
* Add gunicorn for netmgt. [Thomas Merkel]
* Create delegate dataset for /var/db database files. [Thomas Merkel]
* Add version and install netmgt. [Thomas Merkel]
* First commit with template content or content from other repository. [Thomas Merkel]
