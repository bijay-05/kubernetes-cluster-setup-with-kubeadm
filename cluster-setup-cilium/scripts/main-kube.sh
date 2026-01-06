KUBERNETES_VERSION="v1.34"

echo "Download the GPG Key for the kubernetes APT repository"

curl -fsSL https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/Release.key |
    sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/ /" |
    sudo tee /etc/apt/sources.list.d/kubernetes.list

echo "Adding GPG keys completed"
sudo apt update -y

sleep 3

echo "Installing kubernetes components"

KUBERNETES_INSTALL_VERSION="1.34.0-1.1"

sudo apt-get install -y kubelet="$KUBERNETES_INSTALL_VERSION" kubectl="$KUBERNETES_INSTALL_VERSION" kubeadm="$KUBERNETES_INSTALL_VERSION"

sudo apt-mark hold kubelet kubectl kubeadm
