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

# Install K3s in controller mode
curl -sfL https://get.k3s.io | sh -s - --node-ip=192.168.56.110 --flannel-iface=eth1 --write-kubeconfig-mode 644 --write-kubeconfig=/home/vagrant/.kube/config

# Make sure the kubeconfig directory exists
sudo -u vagrant mkdir -p /home/vagrant/.kube

# Set proper permissions for kube config
sudo chmod 644 /var/lib/rancher/k3s/server/node-token
sudo chown vagrant:vagrant /home/vagrant/.kube/config

# Get the token for worker node to join
sudo cp /var/lib/rancher/k3s/server/node-token /home/vagrant/node-token