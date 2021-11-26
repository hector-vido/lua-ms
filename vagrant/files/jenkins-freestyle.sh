#!/bin/sh
#
# KEYFILE e USERNAME são criados pelo Jenkins
# devido ao uso de "secrets"

rm -rf .git* kubernetes docker vagrant
sed -i 's/172.17.0.1/localhost/' config.lua
ssh -i $KEYFILE -o stricthostkeychecking=no $USERNAME@172.27.11.20 mkdir -p /opt/app
scp -i $KEYFILE -r $WORKSPACE/* $USERNAME@172.27.11.20:/opt/app
ssh -i $KEYFILE $USERNAME@172.27.11.20 'cd /opt/app/ && lapis migrate'
