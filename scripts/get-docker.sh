#!/bin/bash

TARGET_USER=$1
SERVER_DATADIR=$2

if [[ -z "$TARGET_USER" || -z "$SERVER_DATADIR" ]] ; then
  echo "Usage: $0 <target_user> <target_datadir>"
  echo "Example: $0 motoko /mnt/data/"
  exit 1
fi

for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

sudo usermod -aG docker $TARGET_USER

sudo service docker stop

# In case the dir doesn't exist yet, should be created
if [ ! -d "$SERVER_DATADIR" ]; then
    sudo mkdir -p "$SERVER_DATADIR"
    echo "Directory created: $SERVER_DATADIR"
else
    echo "Directory already exists: $SERVER_DATADIR"
fi

sudo chown -R $TARGET_USER:$TARGET_USER "$SERVER_DATADIR/"

sudo cp -r /var/lib/docker "$SERVER_DATADIR/docker-data"
sudo chown -R root:root "$SERVER_DATADIR/docker-data"
sudo rm -rf /var/lib/docker

sudo touch /etc/docker/daemon.json
sudo chown $USER:$USER /etc/docker/daemon.json
echo "{  \"data-root\": \"$SERVER_DATADIR/docker-data\"  }" > /etc/docker/daemon.json
sudo chown root:root /etc/docker/daemon.json

sudo service docker restart
