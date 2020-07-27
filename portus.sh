#!/bin/bash -x
# openssl rand -hex 64 -> keybase

# variables
CA_CERTIFICATE="rootCA.suse.site.crt"
CERTIFICATE="wildcard.suse.site.crt"
KEY="wildcard.suse.site.key"
FQDN="regminint.suse.site"
RUNTIME="docker"

##############################
$RUNTIME stop portus
$RUNTIME rm portus
$RUNTIME run -d \
--restart=always \
--name portus \
--add-host regminint:10.228.204.132 \
--add-host regminint.suse.site:10.228.204.132 \
-v /data/certificates/:/certificates:ro \
-v /data/certificates/$CA_CERTIFICATE:/etc/pki/trust/anchors/rootCA.crt:ro \
-p 443:3000 \
-e PORTUS_DB_HOST=$FQDN \
-e PORTUS_DB_PORT=3306 \
-e PORTUS_DB_DATABASE=portus_production \
-e PORTUS_DB_USERNAME=portus \
-e PORTUS_DB_PASSWORD=suse1234 \
-e PORTUS_DB_POOL=5 \
-e PORTUS_MACHINE_FQDN_VALUE=$FQDN \
-e PORTUS_PASSWORD="supercomplexpassword!" \
-e PORTUS_CHECK_SSL_USAGE_ENABLED=false \
-e PORTUS_SECRET_KEY_BASE=fe4ead79e6c48fa8cf2234ff31964a9997459ced70effd28fa5b71c0c3a18e46f4bc013d9657ea09ad07397f65a626c48d5f16804022d351724cf463b6da144f \
-e PORTUS_KEY_PATH=/certificates/$KEY \
-e PORTUS_PUMA_TLS_KEY=/certificates/$KEY \
-e PORTUS_PUMA_TLS_CERT=/certificates/$CERTIFICATE \
-e RAILS_SERVE_STATIC_FILES=true \
-e PORTUS_DELETE_ENABLED=true \
-e PORTUS_SIGNUP_ENABLED=false \
registry.suse.com/sles12/portus:2.4.3
exit
# just required with CLAIR
-e PORTUS_SECURITY_CLAIR_SERVER="http://$FQDN:6060" \
# podman does not support "unless-stopped"
--restart=unless-stopped \
