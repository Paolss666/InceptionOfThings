#!/bin/bash

# Update the system
sudo apt-get update -y
sudo apt-get upgrade -y

# Install required packages
sudo apt-get install -y curl openssh-server

# Setup SSH for password-less authentication
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo systemctl restart ssh

# Generate SSH key pair for vagrant user (no passphrase)
sudo -u vagrant mkdir -p /home/vagrant/.ssh
sudo -u vagrant ssh-keygen -t rsa -b 4096 -f /home/vagrant/.ssh/id_rsa -N ""

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Get K3s token from server node
TOKEN=$(vagrant ssh npaolettS -c "sudo cat /var/lib/rancher/k3s/server/node-token" | tr -d '\r')

# Install K3s in agent (worker) mode
curl -sfL https://get.k3s.io | K3S_URL=https://192.168.56.110:6443 K3S_TOKEN=${TOKEN} sh -s - --node-ip=192.168.56.111 --flannel-iface=eth1