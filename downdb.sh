#!/bin/bash
#day=$(date +%y%m%d-%H%M)
#dump_file="$day-db.dump"
#dump_path=""
dump_file="latest.dump"
pg_user=postgres
pg_db=postgres
#app="--app "

heroku pg:backups capture "$app"
url=$(heroku pg:backups public-url "$app")

if [ -f "$dump_file" ]; then
  rm -v "$dump_file"
fi
curl -o "$dump_file" "$url"

read -p "Do you want to restore? [y/n]" restore
if [ "$restore" == 'y' ]; then
  pg_restore --verbose --clean --no-acl --no-owner -h localhost -U "$pg_user" -d "$pg_db" "$dump_file"
fi
