# DaemonSets
[Source: KodeKloud Notes](https://notes.kodekloud.com)

DaemonSets ensure that exactly one copy of a pod runs on every node in your Kubernetes cluster. When you add a new node, the DaemonSet automatically deploys the pod on the new node. Likewise, when a node is removed, the corresponding pod is also removed. This guarantees that a single instance of the pod is consistently available on each node.

## Use Cases for DaemonSets
DaemonSets are particularly useful in scenarios where you need to run background services or agents on every node. Some common use cases include:

- **Monitoring agents and log collectors**: Deploy monitoring tools or log collectors across every node to ensure comprehensive cluster-wide visibility without manual intervention.
- **Essential Kubernetes Components**: Deploy critical components, such as kube-proxy. which Kubernetes requries on all worker nodes.
- **Networking Solutions**: Ensure consistent deployment of networking agents like those used in VNet or weave-net across all nodes.

## Creating a DaemonSet

Creating a DaemonSet is analogous to creating a ReplicaSet. The DaemonSet YAML configuration consists of a pod template under the `template` section and a selector that binds the DaemonSet to its pods. A typical DaemonSet definition includes the API version, kind, metadata and specifications. Note that the API version is `apps/v1` and the kind is set to `DaemonSet`

```yaml
# daemon-set-definition.yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: monitoring-daemon
spec:
  selector:
    matchLabels:
      app: monitoring-agent
  template:
    metadata:
      labels:
        app: monitoring-agent
    spec:
      containers:
        - name: monitoring-agent
          image: monitoring-agent

```

> [!Important]
> Make sure that that the labels in the selector match those in the pod template. Consistent labelling is crucial for the proper functioning of your DaemonSet.

```bash

kubectl create -f daemon-set-definition.yaml

# verify the DaemonSet's runnint
kubectl get daemonsets

# detailed description of the DaemonSet
kubectl describe daemonset monitoring-daemon
```

## How DaemonSets Schedule Pods

Prior to Kubernetes version 1.12, scheduling a pod on a specific node was often achieved by manually setting the `nodeNam` property within the pod specification. However, since version 1.12, DaemonSets leverage the default scheduler in conjuction with node affinity rules. This improvement ensures that a pod is automatically scheduled on every node without manual intervention.

> [!Important]
> DaemonSets are an ideal solution for deploying services that must run on every node, such as monitoring agents, and essential networking components. Leveraging node affinity simplifies management as your cluster scales.

### Conclusion

DaemonSets provide an efficient mechanism to ensure that key services are uniformly deployed across your Kubernetes cluster. Whether you are running log collectors, monitoring agents, or essential network components like kube-proxy and weave-net, DaemonSets help maintain consistency and reliability in dynamic environments.