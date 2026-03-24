#!/bin/bash

echo "Installing KinD"

curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.31.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/bin/kind

echo "KinD Installation Successful"

echo "Installing Kubectl"

KUBERNETES_VERSION="v1.34"

echo "Download the GPG Key for the kubernetes APT repository"

sudo apt-get install gpg -y

curl -fsSL https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/Release.key |
    sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/ /" |
    sudo tee /etc/apt/sources.list.d/kubernetes.list

echo "Adding GPG keys completed"
sudo apt update -y

sleep 3

echo "Installing kubectl now"

KUBERNETES_INSTALL_VERSION="1.34.0-1.1"

sudo apt-get install -y kubectl="$KUBERNETES_INSTALL_VERSION"