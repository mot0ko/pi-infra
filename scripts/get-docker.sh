#!/bin/bash

TARGET_USER=$1
SERVER_DATADIR=$2

if [[ -z "$TARGET_USER" || -z "$SERVER_DATADIR" ]] ; then
  echo "Usage: $0 <target_user> <target_datadir>"
  echo "Example: $0 motoko /mnt/data/"
  exit 1
fi

for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do apt-get remove $pkg; done

# Add Docker's official GPG key:
apt-get update
apt-get install ca-certificates curl -y
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update

apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

usermod -aG docker $TARGET_USER

service docker stop

# In case the dir doesn't exist yet, should be created
if [ ! -d "$SERVER_DATADIR" ]; then
    mkdir -p "$SERVER_DATADIR"
    echo "Directory created: $SERVER_DATADIR"
else
    echo "Directory already exists: $SERVER_DATADIR"
fi

chown -R $TARGET_USER:$TARGET_USER "$SERVER_DATADIR/"

cp -r /var/lib/docker "$SERVER_DATADIR/docker-data"
chown -R root:root "$SERVER_DATADIR/docker-data"
rm -rf /var/lib/docker

touch /etc/docker/daemon.json
chown $USER:$USER /etc/docker/daemon.json
echo "{  \"data-root\": \"$SERVER_DATADIR/docker-data\"  }" > /etc/docker/daemon.json
chown root:root /etc/docker/daemon.json

service docker restart

