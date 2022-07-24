#!/usr/bin/env bash

set -e

cd /usr/src/freepbx

# mysql configuration
: ${MYSQL_HOST:="db"}
: ${MYSQL_PORT:="3306"}
: ${MYSQL_DATABASE:="asterisk"}
: ${MYSQL_DATABASE_CDR:="asteriskcdrdb"}
: ${MYSQL_USER:="asterisk"}
: ${MYSQL_PASSWORD:="asterisk"}

echo "--> Installing FreePBX in /var/www/html"
./install -n --skip-install --no-ansi \
    --dbengine=mysql \
    --dbhost=${MYSQL_HOST} \
    --dbport=${MYSQL_PORT} \
    --dbuser=${MYSQL_USER} \
    --dbpass=${MYSQL_PASSWORD} \
    --dbname=${MYSQL_DATABASE} \
    --cdrdbname=${MYSQL_DATABASE_CDR}

su - asterisk -s /bin/bash -c "fwconsole ma install pm2"

echo "--> enabling EXTENDED FreePBX repo..."
su - asterisk -s /bin/bash -c "fwconsole ma enablerepo extended"
su - asterisk -s /bin/bash -c "fwconsole ma enablerepo unsupported"

echo "---> reloading FreePBX..."
su - asterisk -s /bin/bash -c "fwconsole reload"