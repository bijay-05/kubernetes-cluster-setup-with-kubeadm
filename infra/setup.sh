#!/bin/bash

echo "Installing Tmux and Git...."

apt update && apt install tmux git -y

sleep 3

cd /home/masteruser && git clone https://github.com/bijaypachhai/dotfiles.git && cp /home/masteruser/dotfiles/ghostty/.tmux.conf /home/masteruser/.tmux.conf && rm -r /home/masteruser/dotfiles

sleep 3

##==============================
#------------PREPARATION STARTED
#===============================
apt update && apt install cron -y

sleep 2

echo "Configuration starts here"

cat <<EOF | tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

sleep 2
echo "Kernel modules: overlay and br_netfilter loaded"

cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sleep 2
echo "IP Tables configuration loaded"

sysctl --system

echo "Turning off swap"

swapoff -a
(crontab -l 2>/dev/null; echo "@reboot /sbin/swapoff -a") | crontab - || true

#===================================
#-----TIME FOR CONTAINER-D----------
#===================================

sleep 2
echo "Now installing container-d"


# Kubernetes Variable Declaration
CONTAINERD_VERSION="2.2.0"
RUNC_VERSION="1.3.3"

# Apply sysctl params without reboot
sysctl --system

apt-get update -y
apt-get install -y apt-transport-https ca-certificates curl gpg

# Install containerd Runtime
apt-get update -y
apt-get install -y software-properties-common curl apt-transport-https ca-certificates

# Download and install containerd
curl -LO https://github.com/containerd/containerd/releases/download/v${CONTAINERD_VERSION}/containerd-${CONTAINERD_VERSION}-linux-amd64.tar.gz
tar Cxzvf /usr/local containerd-${CONTAINERD_VERSION}-linux-amd64.tar.gz
rm containerd-${CONTAINERD_VERSION}-linux-amd64.tar.gz

# Download and install runc
curl -LO https://github.com/opencontainers/runc/releases/download/v${RUNC_VERSION}/runc.amd64
install -m 755 runc.amd64 /usr/local/sbin/runc
rm runc.amd64

# Configure containerd
mkdir -p /etc/containerd
containerd config default | tee /etc/containerd/config.toml

# Enable SystemdCgroup in containerd config
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

# Create containerd systemd service
cat <<EOF | tee /etc/systemd/system/containerd.service
[Unit]
Description=containerd container runtime
Documentation=https://containerd.io
After=network.target local-fs.target

[Service]
ExecStartPre=-/sbin/modprobe overlay
ExecStart=/usr/local/bin/containerd
Type=notify
Delegate=yes
KillMode=process
Restart=always
RestartSec=5
LimitNPROC=infinity
LimitCORE=infinity
LimitNOFILE=infinity
TasksMax=infinity
OOMScoreAdjust=-999

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable containerd --now
systemctl start containerd.service

echo "Containerd runtime installed successfully"

#===================================
#-----TIME FOR CRICTL----------
#===================================

sleep 2
echo "Now installing crictl"

CRICTL_VERSION="v1.34.0"

curl -LO https://github.com/kubernetes-sigs/cri-tools/releases/download/${CRICTL_VERSION}/crictl-${CRICTL_VERSION}-linux-amd64.tar.gz
tar zxvf crictl-${CRICTL_VERSION}-linux-amd64.tar.gz -C /usr/local/bin
rm -f crictl-${CRICTL_VERSION}-linux-amd64.tar.gz

# Configure crictl to use containerd
cat <<EOF | tee /etc/crictl.yaml
runtime-endpoint: unix:///run/containerd/containerd.sock
image-endpoint: unix:///run/containerd/containerd.sock
timeout: 10
debug: false
EOF

echo "crictl installed and configured successfully"

#===================================
#-----TIME FOR KUBELET KUBEADM KUBECTL----------
#===================================

sleep 2
echo "Now installing kubelet, kubectl, and kubeadm"

KUBERNETES_VERSION="v1.34"

echo "Download the GPG Key for the kubernetes APT repository"

curl -fsSL https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/Release.key |
    gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/ /" |
    tee /etc/apt/sources.list.d/kubernetes.list

echo "Adding GPG keys completed"
apt update -y

sleep 3

echo "Installing kubernetes components"

KUBERNETES_INSTALL_VERSION="1.34.0-1.1"

apt-get install -y kubelet="$KUBERNETES_INSTALL_VERSION" kubectl="$KUBERNETES_INSTALL_VERSION" kubeadm="$KUBERNETES_INSTALL_VERSION"

apt-mark hold kubelet kubectl kubeadm

echo "Locked and Loaded"

