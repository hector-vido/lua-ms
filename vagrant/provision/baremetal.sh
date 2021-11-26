#!/bin/bash

apt-get update
apt-get install -y mariadb-server

systemctl start mariadb
systemctl enable mariadb

cat <<EOF | mysql
CREATE USER lua IDENTIFIED BY '4linux';
CREATE DATABASE lua;
GRANT ALL ON lua.* TO lua;
EOF
