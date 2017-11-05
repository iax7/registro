#!/bin/bash
dump_file="latest.dump"
pg_user=postgres
pg_db=postgres

heroku pg:backups capture
url=$(heroku pg:backups public-url)

if [ -f "$dump_file" ]; then
  rm -v "$dump_file"
fi
curl -o "$dump_file" "$url"

# sudo -E dnf install -y postgresql
read -p "Do you want to restore? [y/n]" restore
if [ "$restore"=='y' ]; then
  pg_restore --verbose --clean --no-acl --no-owner -h localhost -U "$pg_user" -d "$pg_db" "$dump_file"
fi
