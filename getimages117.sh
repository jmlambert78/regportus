#!/bin/bash

export HUU="registry.suse.com/caasp/v4/cilium-init:1.6.6
registry.suse.com/caasp/v4/cilium:1.6.6
registry.suse.com/caasp/v4/caasp-dex:2.16.0
registry.suse.com/caasp/v4/hyperkube:v1.17.4
registry.suse.com/caasp/v4/coredns:1.6.5
registry.suse.com/caasp/v4/pause:3.1
registry.suse.com/caasp/v4/skuba-tooling:0.1.0
registry.suse.com/caasp/v4/cilium-operator:1.6.6
registry.suse.com/caasp/v4/gangway:3.1.0-rev4
registry.suse.com/caasp/v4/kured:1.3.0
registry.suse.com/caasp/v4/metrics-server:0.3.6
registry.suse.com/caasp/v4/etcd:3.4.3"

echo "$HUU" | while read i; do podman pull $i; done
