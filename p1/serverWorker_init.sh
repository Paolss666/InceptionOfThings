#!/bin/sh

export DEBIAN_FRONTEND=noninteractive
apt-get update && apt-get upgrade -y
apt-get install curl -y
apt-get install ufw -y

# Disable FireWall
ufw disable

# Recover the token fron the shared folder
TOKEN=$(cat /vagrant/token)
NODE_IP=192.168.56.111
# Prefix environment variable:
# K3S_URL => Indicates the ip of the server node and the gate to connect
# K3S_TOKEN => Allow the worker to authentificate
# INSTALL_K3S_EXEC="--node-ip=${NODE_IP}" => Tell K3S to use Node_IP instead of default one as Internal_IP  
curl -sfL https://get.k3s.io | K3S_URL=https://192.168.56.110:6443 K3S_TOKEN=${TOKEN} INSTALL_K3S_EXEC="--node-ip=${NODE_IP}" sh -