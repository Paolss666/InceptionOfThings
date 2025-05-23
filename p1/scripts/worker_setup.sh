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

# vagrant ssh npaolettS -c "sudo cat /var/lib/rancher/k3s/server/node-token":
# Uses the vagrant ssh command to access the virtual machine npaolettS (the server node) 
# and execute the command sudo cat /var/lib/rancher/k3s/server/node-token. 
# This command reads the authentication token generated by K3s on the server node, 
# which is necessary to add worker nodes to the cluster.

# Install K3s in agent (worker) mode
curl -sfL https://get.k3s.io | K3S_URL=https://192.168.56.110:6443 K3S_TOKEN=${TOKEN} sh -s - --node-ip=192.168.56.111 --flannel-iface=eth1

# -flannel-iface=eth1:
# Configures the eth1 network interface for Flannel 
# networking, the network plugin used by K3s for communication between nodes. 
# This is necessary to ensure that the node uses the correct interface for cluster network traffic.