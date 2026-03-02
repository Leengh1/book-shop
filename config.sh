#!/bin/bash

set -eu

# Check if root
if [ "$EUID" -ne 0]; then
  echo"Please run as root (use: sudo $0)"
  exit 1
fi

user=ubuntu
# Install NGINX

apt update
apt install -y nginx

systemctl start nginx
systemctl enable nginx


# Install prerequistes for Docker repo

apt update
apt install -y ca-certificates curl gnupg lsb-release

# Create keyrings dir and add Docker's official GPG key
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
    -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker repository
tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF


# Install Docker Engine

apt update
 
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start & enable the Docker daemon
systemctl start docker
systemctl enable docker

usermod -aG docker $user 

# Check status 
echo "Docker status: $(systemctl is-active docker)"
echo "Nginx status: $(systemctl is-active nginx)"


#install microk8s
sudo snap install microk8s --classic
usermod -aG microk8s $user


#install aws cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip
unzip awscliv2.zip
sudo ./aws/install