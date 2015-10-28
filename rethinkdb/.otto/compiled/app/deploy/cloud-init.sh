#!/bin/bash
set -e

# Install cURL if we have to
apt-get update -y
apt-get install -y curl

# Install Docker
curl -sSL https://get.docker.com/ | sh

# Create the container
docker create -p 8080:8080 -p 28015:28015 -p 29015:29015 --name="rethinkdb" rethinkdb

# Write the service
cat >/etc/init/rethinkdb.conf <<EOF
description "Docker container: rethinkdb"

start on filesystem and started docker
stop on runlevel [!2345]

respawn

post-stop exec sleep 5

script
  /usr/bin/docker start rethinkdb
end script
EOF

# Start the service
start rethinkdb
