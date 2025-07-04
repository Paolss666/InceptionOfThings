#!/bin/sh

export DEBIAN_FRONTEND=noninteractive

sudo apt-get update && sudo apt-get upgrade

# SSH
echo "*************SSH************"
# Create and manage owner and rights on .ssh directory
mkdir -p /home/$(whoami)/.ssh
chown -R $(whoami):$(whoami) /home/$(whoami)/.ssh
chmod 700 /home/$(whoami)/.ssh
# Generate ssh key
ssh-keygen -t rsa -b 4096 -C $4 -f /home/$(whoami)/.ssh/id_rsa -N ""
# Manage owner and rights on id_rsa files
chown -R $(whoami):$(whoami) /home/$(whoami)/.ssh/id_rsa
chown -R $(whoami):$(whoami) /home/$(whoami)/.ssh/id_rsa.pub
chmod 600 /home/$(whoami)/.ssh/id_rsa
chmod 644 /home/$(whoami)/.ssh/id_rsa.pub
# ssh-add /home/$(whoami)/.ssh/id_rsa

# Git"
echo "GIT"
apt-get install git -y
# GIT CLI INSTALLATION
apt-get install gh
# Authentificate to github account through classic token
echo $3 > token.txt
gh auth login --with-token < token.txt
# Adding ssh_key to github account
gh ssh-key add /home/$(whoami)/.ssh/id_rsa.pub --title "IOT"
# To be able to add, commit, push
# echo "$(whoami)"
# echo "********************TEST0**************************"
# sudo su - $1 << $2
# echo "$(whoami)"
# echo "********************TEST1**************************"
# git config --global user.email "$4"
# echo "********************TEST2**************************"
# git config --global user.name "$5"
# echo "********************TEST3**************************"
# exit
# echo "$(whoami)"

# Make
echo "MAKE"
apt-get install make -y

# Install wget and gpg
echo "WGET GPG"
apt-get install wget gpg -y

# Vscode
echo "VSCODE"
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
rm -f packages.microsoft.gpg
apt-get install apt-transport-https
apt-get update
apt-get install code

# Docker
# Unistall all potential conflicting packages
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
# Install last version of docker
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin