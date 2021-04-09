#!/bin/sh

CONFIG=/opt/app/config.lua

test -n "$SECRET"      && sed -Ei "s/secret = '[a-z0-9]+'/secret = '$SECRET'/i" $CONFIG
test -n "$DB_HOST"     && sed -Ei "s/host = '172.17.0.1'/host = '$DB_HOST'/" $CONFIG
test -n "$DB_PORT"     && sed -Ei "s/port = '3306'/port = '$DB_PORT'/" $CONFIG
test -n "$DB_USER"     && sed -Ei "s/user = 'lua'/user = '$DB_USER'/" $CONFIG
test -n "$DB_PASSWORD" && sed -Ei "s/password = '4linux'/password = '$DB_PASSWORD'/" $CONFIG
test -n "$DB_DATABASE" && sed -Ei "s/database = 'lua'/database = '$DB_DATABASE'/" $CONFIG

exec /usr/local/openresty/nginx/sbin/nginx -g 'daemon off; master_process on;'
