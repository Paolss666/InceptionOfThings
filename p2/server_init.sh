#!/bin/sh

export DEBIAN_FRONTEND=noninteractive
apt-get update && apt-get upgrade -y
# GRAPHIC INTALLATION
# apt-get install task-gnome-desktop -y
# # Create a user + sudo rights 
# password=IOT
# # Crypte le password
# pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
# useradd -m -p $pass IOT
# # To force user to change his passwd at first connexion
# passwd -e IOT
# # To give sudo rigths
# usermod -aG sudo IOT

apt-get install curl -y
apt-get install ufw -y

# Disable FireWall
ufw disable

# Get installation's script of k3s | Exec the script with sh in order to install k3s in controller mode
# -s : silent
# -f : If http error -> fail
# -L : follow redirections
# INSTALL_K3S_EXEC="--node-ip=${NODE_IP}" => Prefix environment variable that tell K3S to use Node_IP instead of default one as Internal_IP  
NODE_IP=192.168.56.110
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--node-ip=${NODE_IP}" sh -

sudo mkdir -p /home/vagrant/.kube
sudo cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config
sudo chown -R vagrant:vagrant /home/vagrant/.kube/config

# To put the token in the shared vagrant folder in order to allow the worker to use it and connect to the cluster
TOKEN=$(sudo cat /var/lib/rancher/k3s/server/node-token)
echo ${TOKEN} > /src/token
# To create k alias
echo 'alias k="sudo kubectl"' > /home/vagrant/.bashrc
# Create deployment, services and ingress for app-one app-two and app-three  
sudo kubectl apply -f /src/appX.com/app-one.yml
sudo kubectl apply -f /src/appX.com/app-two.yml
sudo kubectl apply -f /src/appX.com/app-three.yml
sudo kubectl apply -f /src/appX.com/ingress-conf.yml
sudo reboot