#!/bin/bash -x

# variables

RUNTIME="podman"

#####################

$RUNTIME stop mysql
$RUNTIME rm mysql
$RUNTIME run -d \
--restart=always \
--name mysql \
-p 3306:3306 \
-v /var/lib/mysql:/var/lib/mysql \
-e MYSQL_DATABASE="portus_production" \
-e MYSQL_ROOT_PASSWORD="suse1234" \
-e MYSQL_DISABLE_REMOTE_ROOT="false" \
-e MYSQLD_CONFIG="character-set-server=utf8;collation-server=utf8_unicode_ci;init-connect=\"SET NAMES UTF8\";innodb-flush-log-at-trx-commit=0" \
-v /data/registry/mysql-entrypoint.sh:/usr/local/bin/entrypoint.sh \
registry.suse.com/sles12/mariadb:10.0
exit
--restart=unless-stopped \
