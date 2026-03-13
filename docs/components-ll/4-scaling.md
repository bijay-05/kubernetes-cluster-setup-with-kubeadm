# Scaling

[Source: KodeKloud Notes](https://notes.kodekloud.com)

This document explores auto and manual scaling in Kubernetes, focusing on Horizontal and Vertical Pod Autoscaling.

> Vertical Scaling means enhancing a single server's resources, whereas horizontal scaling means incorporating additional servers to manage increased load.

Kubernetes is designed to dynamically scale containerized applications. Two primary scaling strategies in Kubernetes are:

1. Scaling workloads – adding or removing containers (Pods) in the cluster.
2. Scaling the underlying cluster infrastructure – adding or removing nodes (servers) in the cluster.

To clarify:

- For the cluster infrastructure: **Horizontal scaling** add more nodes to the cluster, **Vertical scaling** increase resources (CPU, memory) on existing nodes.

- For workloads: **Horizontal scaling** create more pods, **Vertical scaling** increase resource limits and requests for existing pods.

> [!Important]
> Manual scaling involves direct intervention and command execution, while automated scaling leverages Kubernetes controllers for dynamic adjustments.

## Manual Scaling

For manual scaling, use the following methods:

- Cluster Infrastructure Horizontal Scaling: Manually provision new nodes and add them to the cluster

```bash
kubeadm join ...
```

- Workload Horizontal Scaling: Adjust the number of Pods using:

```bash
kubectl scale --replicas=<NUMBER> <workload-type>/<workload-name>
```

- Workload Vertical Scaling : Edit the deployment, stateful set, or ReplicaSet to change resource limits and requests

```bash
kubectl edit <workload-type>/<workload-name>
```

Vertical scaling of cluster nodes is less common in Kubernetes because it often requires downtime. In virtualized environments, it may be easier to provision a new VM with higher resources, add it to the cluster, and then decommission the older node.

## Automated Scaling

Automated scaling in Kubernetes simplifies operations:

- **Cluster Infrastructure**: Managed by the Kubernetes Cluster Autoscaler
- **Workload Horizontal Scaling**: Managed by the Horizontal Pod Autoscaler (HPA)
- **Workload Vertical Scaling**: Managed by the Vertical Pod Autoscaler (VPA)
