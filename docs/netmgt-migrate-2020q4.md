# Upgrade from core-netmgt 18.4.0 to 20.4.0

Because some django structure has been changed it is required to follow an
upgrade process out of the regular re-provision phase. Please follow the steps
below to convert your data.

1. Stop gunicorn and nginx on the current running netmgt zone:

```
	svc:/network/gunicorn:netmgt
	svc:/pkgsrc/nginx:default
```

2. Install required tooling to change some exported data:

```
	pkgin update
	pkgin install jq gsed
```

3. Export data via `dumpdata` command. Please notice we will skip some
   permission data and cached data. The dump is stored on the delegate dataset,
   but anyway **perform a backup** of this data by copying to your machine.

```
	cd /opt/netmgt
	./manage.py dumpdata -n -e netmgt.CachedZone -e sessions.session \
	                        -e contenttypes.contenttype -e auth.permission \
	            > /var/db/netmgt/fullexport.json
```


4. Run a regular re-provision of the zone with the image of the 20.4 version.

5. Modify the data as required to run an `loaddata` at the end:

```
	cd /var/db/netmgt/
	jq '.' fullexport.json | gsed -i 's/"ttl": ""/"ttl": null/g' \
	                       > fullexport-cleaned.json
```

6. Remove all existing data from the database and run the import:

```
	> /var/db/netmgt/netmgt.sqlite3
	/opt/netmgt/manage.py loaddata /var/db/netmgt/fullexport-cleaned.json
```
