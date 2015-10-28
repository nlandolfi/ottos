#!/bin/bash
set -e

# Install cURL if we have to
apt-get update -y
apt-get install -y curl

# Install Docker
curl -sSL https://get.docker.com/ | sh

# Create the container
docker create -p 27017:27017 --name="mongodb" mongo:3.0

# Write the service
cat >/etc/init/mongodb.conf <<EOF
description "Docker container: mongodb"

start on filesystem and started docker
stop on runlevel [!2345]

respawn

post-stop exec sleep 5

script
  /usr/bin/docker start mongodb
end script
EOF

# Start the service
start mongodb
