# Issues

## Wrong `controlPlaneEndpoint` value in `kubeadm.config` file

Mistakenly initialized control plane with **kubeadm** config file containing wrong `controlPlaneEndpoint` value.
Due to this, health check for **kube-apiserver** failed, and whole cluster bootstrapping process failed.

### Steps Taken to remediate the situation

```bash
$sudo kubeadm reset -f
$sudo systemctl restart kubelet
$sudo kubeadm init --config=kubeadm.config
```

### Alternative Remedy

```bash
### Edit /etc/kubernetes/manifests/kube-apiserver.yaml
$sudo vim /etc/kubernetes/manifests/kube-apiserver.yaml

### Regenerate APIServer Certificates
$sudo kubeadm init phase certs apiserver --config kubeadm.config
$sudo kubeadm init phase certs apiserver-kubelet-client --config kubeadm.config

### Restart kubelet
$sudo systemctl restart kubelet
```
