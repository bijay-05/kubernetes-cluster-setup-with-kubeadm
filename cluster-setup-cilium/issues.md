# Issues

## Wrong `controlPlaneEndpoint` value in `kubeadm.config` file

Mistakenly initialized control plane with **kubeadm** config file containing wrong `controlPlaneEndpoint` value.
Due to this, health check for **kube-apiserver** failed, and whole cluster bootstrapping process failed.

### Steps Taken to remediate the situation

```bash
sudo kubeadm reset -f
sudo systemctl restart kubelet
sudo kubeadm init --config=kubeadm.config
```

### Alternative Remedy

```bash
### Edit /etc/kubernetes/manifests/kube-apiserver.yaml
sudo vim /etc/kubernetes/manifests/kube-apiserver.yaml

### Regenerate APIServer Certificates
sudo kubeadm init phase certs apiserver --config kubeadm.config
sudo kubeadm init phase certs apiserver-kubelet-client --config kubeadm.config

### Restart kubelet
sudo systemctl restart kubelet
```

### Remove worker nodes

```bash
kubectl delete node node-0

## to re-join the worker node
## delete kubelet.conf file in /etc/kubernetes/kubelet.conf
## delete ca.crt file in /etc/kubernetes/pki/*.crt
## stop kubelet service

kubeadm token create --print-join-command
```

### Default Cilium podCIDR

Although I have passed custom podCIDR value while installing cilium with helm, the resulting pods were not getting IP address from cilium's podCIDR.
So I uninstalled cilium, and removed worker nodes from the cluster. And after re-installing cilium, I joined the worker nodes into the cluster.
Still, there is difference between podCIDR value as viewed in `kubectl describe node <NODE_NAME>` and real pod IP address.

### checking pod IP pool CIDR value in multiple places

cluster-pool-ipv4-cidr: 10.0.0.0/8

I checked for podCIDR values in **cilium-config configMap** object, **cilium-operator** deployment and even in **ciliumnodes**, but everywhere there's no sign of custom podCIDRList that I passed as a configuration with helm.

The option `ipam.operator.clusterPoolIPv4PodCIDRList=10.244.0.0/16` takes list as value and while passing the value in terminal, it must have interpreted as a string, so cilium had resorted to default podCIDR value `10.0.0.0/8`.

> [!Important]
> Instead pass configs in file while installing cilium in the cluster with helm.
