#!/bin/sh

export DEBIAN_FRONTEND=noninteractive
apt-get update && apt-get upgrade -y
apt-get install curl -y
apt-get install ufw -y

# Disable FireWall
ufw disable

# Get installation's script of k3s | Exec the script with sh in order to install k3s in controller mode
# -s : silent
# -f : If http error -> fail
# -L : follow redirections
NODE_IP=192.168.56.110
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--node-ip=${NODE_IP}" sh -

mkdir -p /home/vagrant/.kube
cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube/config

# To put the token in the shared vagrant folder in order to allow the worker to use it and connect to the cluster
TOKEN=$(sudo cat /var/lib/rancher/k3s/server/node-token)
echo "TEST 9"
echo ${TOKEN} > /vagrant/token