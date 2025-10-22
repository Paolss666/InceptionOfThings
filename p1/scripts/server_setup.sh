#!/bin/bash
# Update the system
sudo apt-get update -y
sudo apt-get upgrade -y

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Create kubeconfig directory BEFORE installing K3s
sudo -u vagrant mkdir -p /home/vagrant/.kube

# Install K3s in controller mode
curl -sfL https://get.k3s.io | sh -s - \
  --node-ip=192.168.56.110 \
  --flannel-iface=eth1 \
  --write-kubeconfig-mode 644 \
  --write-kubeconfig=/home/vagrant/.kube/config

# Wait for K3s to be ready
sleep 10

# Set proper permissions for kube config
sudo chown vagrant:vagrant /home/vagrant/.kube/config

# Copy the token to shared location with proper permissions
sudo chmod 644 /var/lib/rancher/k3s/server/node-token
sudo cp /var/lib/rancher/k3s/server/node-token /vagrant/node-token
sudo chmod 644 /vagrant/node-token