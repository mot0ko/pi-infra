#!/bin/bash

# To use this script:
#   chmod +x prepare_ubuntu_rpi.sh
#   sudo ./prepare_ubuntu_rpi.sh /dev/sdX

# Check if device name is provided

DEVICE=$1
WIFI_SSID=$2
WIFI_PASSWORD=$3
FUTURE_USER_NAME=$4
CLEAR_PASSWORD=$5

if [[ -z "$DEVICE" || -z "$WIFI_SSID" || -z "$WIFI_PASSWORD" || -z "$CLEAR_PASSWORD" ]] ; then
  echo "Usage: $0 <device> <wifi-ssid> <wifi-password> <system-password>"
  echo "Example: $0 /dev/sdX mywifi mywifipassword mainpassword"
  exit 1
fi

# echo "$DEVICE"
# echo "$WIFI_SSID"
# echo "$WIFI_PASSWORD"
# echo "$CLEAR_PASSWORD"

# Ensure the device is not mounted
sudo umount ${DEVICE}1 2>/dev/null
sudo umount ${DEVICE}2 2>/dev/null

# Set variables
IMAGE_URL="https://cdimage.ubuntu.com/releases/24.04.1/release/ubuntu-24.04.1-preinstalled-server-arm64+raspi.img.xz"
IMAGE_FILE="ubuntu-24.04-preinstalled-server-arm64+raspi.img"
MOUNT_BOOT="/mnt/system-boot"
MOUNT_WRITABLE="/mnt/writable"

# Create a image cache if it does not exist
if [ ! -d "/home/motoko/.cache/rpi-motoko/images/" ]; then
  mkdir -p "/home/motoko/.cache/rpi-motoko/images/"
  chown motoko:motoko -R /home/motoko/.cache/rpi-motoko
fi

if [ ! -f "/home/motoko/.cache/rpi-motoko/images/$IMAGE_FILE.xz" ]; then
  # Download Ubuntu image
  echo "Downloading Ubuntu 24.04 server image for Raspberry Pi..."
  wget -q --show-progress $IMAGE_URL -O /home/motoko/.cache/rpi-motoko/images/${IMAGE_FILE}.xz
  chown motoko:motoko -R /home/motoko/.cache/rpi-motoko
fi

echo "Copying image..."
cp /home/motoko/.cache/rpi-motoko/images/${IMAGE_FILE}.xz ./${IMAGE_FILE}.xz
# Extract the image
echo "Extracting the image..."
xz -d ${IMAGE_FILE}.xz

# Flash the image to the SD card
echo "Flashing the image to $DEVICE..."
sudo dd if=$IMAGE_FILE of=$DEVICE bs=4M status=progress conv=fsync

# Create mount points and mount the partitions
echo "Mounting partitions..."
sudo mkdir -p $MOUNT_BOOT $MOUNT_WRITABLE
sudo mount ${DEVICE}1 $MOUNT_BOOT
sudo mount ${DEVICE}2 $MOUNT_WRITABLE

PASSWD=$(mkpasswd --method=SHA-512 --rounds=4096 $CLEAR_PASSWORD)
PASSWD='$5$9C2ZTZlQiU$pztS0Rvc/LbhwT6rk4ZKfA4wIZzonGUKsIENclYThl/'
# Create the cloud-init user-data file
echo "Creating cloud-init user-data file..."
cat <<EOF | sudo tee $MOUNT_BOOT/user-data
#cloud-config
users:
  - name: $FUTURE_USER_NAME
    lock_passwd: false
    passwd: "$PASSWD"
    groups: sudo
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    ssh_authorized_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDht78kgOnlqAJY8turXqKBAcuqknNnu1UJM+KvdndY4qhPn2tZJHl2b40YY/3XWTQehzuN4Jt760o7Rc9eHDGS+94/pNuR+uHXBIUUQd186RWwkLz5YTfh5QROGG6DaeUErDgJbtfip9FLMyMm9s5YmB9eYDO/qSgtWB36MTIlFUhNYpOK3lVlAOCIyS2GM/illIug9TurGcJTXhV+rKH8GWnprkNsOLOQ4P468OrGv9ypKR9tH8y7Mlyrz5OJzKfJzzbnXZJrGEWw1OLUIxXwamlsiFP5Amk/WkXVolvQQZog3g+RddeOOSZmstOuz2NhA9uJ7mpG14NPLCQ790oW/d2Emd95hjt+kuvRhFl/r/axLdHdPdwVZ73fkerl1SMdwiprKGKepp3bulqsaetMoE8uKN+ojo5588/gU/W2XxJBoUfwPvFV1pScUgRw6ZlzIbTKG6+BuftLsu3T26KfdQxeZmNSF+dD/eyqEhVX/DGLqny8YBH6gCLDDCatiFs= motoko@motoko-main

mounts:
  - [ LABEL=data, /mnt/data, "ext4", "defaults,nofail", "0", "2" ]

hostname: pi-repos

packages:
  - vim
  - curl
  - htop
  - nfs-kernel-server
  - ca-certificates
  - net-tools

runcmd:
  - echo "Welcome to Raspberry Pi" > /etc/motd
  - apt update && apt upgrade -y
  - if [ -f "/home/get-docker.sh" ] ; then chmod +x /home/get-docker.sh ; sudo /home/get-docker.sh "$FUTURE_USER_NAME" "/mnt/data"; fi
  - reboot
EOF

# Optional: Create the network-config file
echo "Creating network-config file..."
cat <<EOF | sudo tee $MOUNT_BOOT/network-config
version: 2
ethernets:
  eth0:
    dhcp4: true
    optional: true
wifis:
  wlan0:
    dhcp4: true
    optional: true
    access-points:
      "$WIFI_SSID":
        password: "$WIFI_PASSWORD"
EOF

# Ensure HDMI output is enabled
echo "Enabling HDMI output..."
cat <<EOF | sudo tee -a $MOUNT_BOOT/config.txt

# Enable HDMI output
hdmi_force_hotplug=1
hdmi_group=1
hdmi_mode=4
EOF

sudo cp "/home/motoko/Documents/dev/git/pi-infra/scripts/get-docker.sh" "$MOUNT_WRITABLE/home/get-docker.sh"

sleep 5


# Unmount the partitions
echo "Unmounting partitions..."
sudo umount $MOUNT_BOOT
sudo umount $MOUNT_WRITABLE

# Clean up
echo "Cleaning up..."
sudo rm -rf $MOUNT_BOOT $MOUNT_WRITABLE
rm -f $IMAGE_FILE

sudo udisksctl power-off -b $DEVICE

echo "Done! You can now insert the SD card into your Raspberry Pi and boot up."
