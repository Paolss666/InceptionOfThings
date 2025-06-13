#!/bin/sh

echo "Hello worker"
sudo apt update && sudo apt upgrade -y
sudo apt install curl -y
sudo apt install ufw -y

# Disable FireWall
ufw disable

# Recover the token fron the shared folder
# TOKEN=$(cat /vagrant/token)
TOKEN=$(cat /src/token)
# K3S_URL => Indicates the ip of the server node and the gate to connect
# K3S_TOKEN => Allow the worker to authentificate
curl -sfL https://get.k3s.io | K3S_URL=https://192.168.56.110:6443 K3S_TOKEN=${TOKEN} sh -