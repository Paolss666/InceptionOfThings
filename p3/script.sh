# install Docker
#
# Add Docker's official GPG key:
sudo apt-get update -y
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update


sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y


# install k3d
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash


# install kubectl
curl -LO https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x kubectl
mv kubectl /usr/local/bin

# create cluter
k3d cluster create p3 -p "80:30080@server:0"

# create namespace
kubectl create namespace dev
kubectl create namespace argocd

#

# install argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml


# waiting for service argocd-server to be ready
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server -n argocd --timeout=300s

# port forwarding
kubectl port-forward svc/argocd-server -n argocd 8080:443 &

# install argocd cli
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64

# get admin argocd password
export ARGOCD_PASSWORD=$(argocd admin initial-password -n argocd | sed -n '1p')

# login to argocd
argocd login localhost:8080 \
    --username admin \
    --password $ARGOCD_PASSWORD \
    --insecure

# create application
argocd app create  wil-playground --repo  https://github.com/hckforpeace/Argocd_CI \
	--path ./ \
	--dest-server https://kubernetes.default.svc \
	--dest-namespace dev \
	--sync-policy automated \
	--auto-prune \
	--self-heal


