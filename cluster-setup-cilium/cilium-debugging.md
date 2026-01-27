# Debugging commands Collection

```bash
## check podCIDR value in cilium-config configMap object
kubectl -n kube-system describe cm cilium-config

## check if helm really applied your config values
helm -n kube-system get values cilium

## see effective helm rendering
## (this shows default pod cidr pool, not the custom one passed at terminal)
helm -n kube-system get manifest cilium > helm.yaml 




## check cilium operators's args
kubectl -n kube-system get deploy cilium-operator -o yaml

## check cilium node CRDs

## gives cilium nodes (master, worker1, worker2)
kubectl -n kube-system get ciliumnodes

## Kind: CiliumNode, name: node-0
## spec: ipam: podCIDRs: - 10.0.2.0/24
kubectl -n kube-system get ciliumnode <worker-node> -o yaml

```
