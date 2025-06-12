#!/bin/sh

echo "Hello server"
sudo apt update && sudo apt upgrade -y
sudo apt install curl -y
sudo apt install ufw -y
sudo apt install net-tools -y

# Disable FireWall
sudo ufw disable

curl -sfL https://get.k3s.io | sh -y