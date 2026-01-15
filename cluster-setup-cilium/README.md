# Cluter Setup with Cilium 

Run the scripts inside `scripts/` directory in the following order on both master and worker nodes.

>[!Important]
> Don't forget to add master node's private IP address to `kubeadm.config` file. `controlPlaneEndpoint` and `advertiseAddress`

```bash

bash init-i.sh
bash init-ii.sh

bash crictl.sh
bash main-kube.sh

## add node's private IP address to /etc/default/kubelet
sudo cat "KUBELET_EXTRA_ARGS=--node-ip=<PRIVATE_IP_ADDRESS>" > /etc/default/kubelet

## initialize control-plane with kubeadm (skip kube-proxy add-on)
sudo kubeadm init --config=kubeadm.config --skip-phases=addon/kube-proxy

## install helm on master node
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-4
chmod 700 get_helm.sh
./get_helm.sh

## setup helm repository
helm repo add cilium https://helm.cilium.io/

## deploy cilium
helm install cilium cilium/cilium --version 1.18.5 --namespace kube-system \
> --set kubeProxyReplacement=true \
> --set k8sServiceHost=API_SERVER_IP \
> --set k8sServicePort=6443

## uninstall cilium as a whole
helm uninstall cilium -n kube-system

## verify
kubectl get po -n kube-system
```