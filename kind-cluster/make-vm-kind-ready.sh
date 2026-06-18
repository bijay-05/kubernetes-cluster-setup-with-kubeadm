#!/bin/bash
echo "Installing Tmux and Git...."

apt update && apt install tmux git -y

sleep 3

cd /home/adminuser && git clone https://github.com/bijaypachhai/dotfiles.git && cp /home/adminuser/dotfiles/ghostty/.tmux.conf /home/adminuser/.tmux.conf && cp /home/adminuser/dotfiles/ghostty/ghostty-info /home/adminuser/ghostty-info && rm -r /home/adminuser/dotfiles

sleep 3
## ===============================
## UBUNTU DISTRIBUTION  ++++++++++
## ===============================
# Add Docker's official GPG key:
apt-get update
apt-get install ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update

sleep 2

echo "Now Installing Docker"

apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

sleep 2
echo "Adding user to docker group"
usermod -aG docker adminuser
sleep 2

## ===============================
## DEBIAN DISTRIBUTION  ++++++++++
## ===============================
# Add Docker's official GPG key:
# apt-get update
# apt-get install ca-certificates curl
# install -m 0755 -d /etc/apt/keyrings
# curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
# chmod a+r /etc/apt/keyrings/docker.asc

# # Add the repository to Apt sources:
# echo \
#   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
#   $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
#   tee /etc/apt/sources.list.d/docker.list > /dev/null
# apt-get update

# sleep 2
# echo "Now Installing Docker"
# apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
# sleep 2
# echo "Adding user to docker group"
# usermod -aG docker adminuser

## ===============================
## INSTALL KIND KUBERNETES in DOCKER  ++++++++++
## ===============================
echo "Installing KinD"

curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.31.0/kind-linux-amd64
chmod +x ./kind
mv ./kind /usr/bin/kind
chown adminuser:adminuser /usr/bin/kind

echo "KinD Installation Successful"

echo "Installing Kubectl"

KUBERNETES_VERSION="v1.34"

echo "Download the GPG Key for the kubernetes APT repository"

apt-get install gpg -y

curl -fsSL https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/Release.key |
    gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/ /" |
    tee /etc/apt/sources.list.d/kubernetes.list

echo "Adding GPG keys completed"
sudo apt update -y

sleep 3

echo "Installing kubectl now"

KUBERNETES_INSTALL_VERSION="1.34.0-1.1"

apt-get install -y kubectl="$KUBERNETES_INSTALL_VERSION"

sleep 2

echo "Download Helm for Installing Cilium"

cd /home/adminuser && curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-4