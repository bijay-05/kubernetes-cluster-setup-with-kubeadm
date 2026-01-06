#!/bin/bash
#
sudo apt update && sudo apt install cron -y

sleep 2

echo "Configuration starts here"

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

sleep 2
echo "Kernel modules: overlay and br_netfilter loaded"

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sleep 2
echo "IP Tables configuration loaded"

sudo sysctl --system

echo "Turning off swap"

sudo swapoff -a
(crontab -l 2>/dev/null; echo "@reboot /sbin/swapoff -a") | crontab - || true
