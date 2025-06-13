#!/bin/sh

echo "Hello server"
sudo apt update && sudo apt upgrade -y
sudo apt install curl -y
sudo apt install ufw -y
# sudo apt install net-tools

# Disable FireWall
sudo ufw disable

# Get installation's script of k3s | Exec the script with sh in order to install k3s in controller mode
# -s : silent
# -f : If http error -> fail
# -L : follow redirections
curl -sfL https://get.k3s.io | sh -

sudo mkdir -p /home/vagrant/.kube
sudo cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config
sudo chown -R vagrant:vagrant /home/vagrant/.kube/config

# To put the token in the shared vagrant folder in order to allow the worker to use it and connect to the cluster
TOKEN=$(sudo cat /var/lib/rancher/k3s/server/node-token)
echo ${TOKEN} > /vagrant/token