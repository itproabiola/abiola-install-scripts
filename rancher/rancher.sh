#!/usr/bin/env bash
set -Eeuo pipefail
sudo docker run --privileged -d --restart=unless-stopped -p 80:80 -p 443:443 rancher/rancher

#consider launching rancher on an aws ec2 instance
