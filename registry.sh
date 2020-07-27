#!/bin/bash -x
# variables
CA_CERTIFICATE="rootCA.suse.site.crt"
CERTIFICATE="wildcard.suse.site.crt"
KEY="wildcard.suse.site.key"
FQDN="regminint.suse.site"
RUNTIME="docker"

########
$RUNTIME stop registry
$RUNTIME rm registry
echo "version: 0.1" > /data/registry/config.yml
$RUNTIME run -d \
--restart=always \
--name registry \
--add-host regminint:10.228.204.132 \
--add-host regminint.suse.site:10.228.204.132 \
-v /data/certificates:/certificates:ro \
-v /data/certificates/$CA_CERTIFICATE:/etc/ssl/ca-bundle.pem:ro \
-v /data/registry/config.yml:/etc/docker/registry/config.yml \
-v /var/lib/docker-registry:/var/lib/docker-registry \
-p 80:5000 \
-p 5001:5001 \
-e REGISTRY_VERSION="0.1" \
-e REGISTRY_LOG_LEVEL="info" \
-e REGISTRY_LOG_ACCESSLOG_DISABLED="true" \
-e REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY="/var/lib/docker-registry" \
-e REGISTRY_STORAGE_DELETE_ENABLED=true \
-e REGISTRY_HTTP_ADDR=":5000" \
-e REGISTRY_HTTP_DEBUG_ADDR=":5001" \
-e REGISTRY_HTTP_SECRET="registry1234!" \
-e REGISTRY_HTTP_TLS_CERTIFICATE=/certificates/$CERTIFICATE \
-e REGISTRY_HTTP_TLS_KEY=/certificates/$KEY \
-e REGISTRY_AUTH_TOKEN_REALM=https://$FQDN:443/v2/token \
-e REGISTRY_AUTH_TOKEN_SERVICE=$FQDN:80 \
-e REGISTRY_AUTH_TOKEN_ISSUER=$FQDN \
-e REGISTRY_AUTH_TOKEN_ROOTCERTBUNDLE=/certificates/$CERTIFICATE \
-e REGISTRY_NOTIFICATIONS_ENDPOINTS="
- name: portus 
  url: https://$FQDN:443/v2/webhooks/events
  timeout: 2000ms
  threshold: 5
  backoff: 1s
" \
registry.suse.com/sles12/registry:2.6.2
exit
# podman does not support "unless-stopped"
--restart=unless-stopped \
