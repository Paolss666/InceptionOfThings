#!/bin/bash
# Update the system
sudo apt-get update -y
sudo apt-get upgrade -y

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Wait for token file to be available (with timeout)
echo "Waiting for K3s token..."
TIMEOUT=60
ELAPSED=0
while [ ! -f /vagrant/node-token ] && [ $ELAPSED -lt $TIMEOUT ]; do
    sleep 2
    ELAPSED=$((ELAPSED + 2))
done

if [ ! -f /vagrant/node-token ]; then
    echo "ERROR: Token file not found after ${TIMEOUT} seconds"
    exit 1
fi

# Read token from shared folder
TOKEN=$(cat /vagrant/node-token | tr -d '\r\n')

# Install K3s in agent (worker) mode
curl -sfL https://get.k3s.io | K3S_URL=https://192.168.56.110:6443 \
  K3S_TOKEN="${TOKEN}" sh -s - \
  --node-ip=192.168.56.111 \
  --flannel-iface=eth1

echo "Worker node setup completed"