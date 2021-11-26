#!/bin/bash

# MariaDB/MySQL
apt-get update
apt-get install -y mariadb-server

systemctl start mariadb
systemctl enable mariadb

cat <<EOF | mysql
CREATE USER lua IDENTIFIED BY '4linux';
CREATE DATABASE lua;
GRANT ALL ON lua.* TO lua;
EOF

# Openresty
apt-get -y install --no-install-recommends wget gnupg ca-certificates
wget -O - https://openresty.org/package/pubkey.gpg | sudo apt-key add -
echo "deb http://openresty.org/package/debian buster openresty" > /etc/apt/sources.list.d/openresty.list

apt-get update
apt-get -y install openresty luarocks lua-inspect lua-sql-mysql gcc libssl-dev liblua5.1-dev
luarocks install lapis

cp /vagrant/files/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf

systemctl restart openresty
systemctl enable openresty
