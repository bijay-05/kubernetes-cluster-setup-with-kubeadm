# Taints and Tolerations

[Source: KodeKloud Notes](https://notes.kodekloud.com)

This document explores how taints and tolerations control pod scheduling on specific nodes in Kubernetes.

In this article, we explore the relationship between pods and nodes, and demonstrate how taints and tolerations control pod scheduling on specific nodes. Think of it like using a repellent on a person to keep bugs away. In Kubernetes, a taint is applied to a node (the repellent) to repel pods unless they have a matching toleration (an immunity to the repellent). This ensures that only intended pods can run on tainted nodes

## How Taints and Tolerations Work

Two factors determine whether a pod can run on a node:

1. The taint applied on the node
2. The pod's toleration for that taint

In Kubernetes, taints and tolerations are used solely for scheduling control, not security. Consider a simple cluster with three worker nodes (node one, two, and three) and four pods (A, B, C, and D). By default, without any taints or tolerations, the scheduler distributes the pods evenly across all nodes.

Suppose you want to dedicate node one to a specific application:

- First, taint node one (using, for example, the key-value pair "app=blue") so that no pods are scheduled there by default
- Then, add an appropriate toleration to the dedicated pod (Pod D) so that it alone can run on node one

When the scheduler assigns pods:

- Pod A, lacking a toleration, will be scheduled on node two.
- Pod B, is repelled from node one and lands on node three.
- Pod C, without a matching toleration, is scheduled on node two or three.
- Pod D, having the correct toleration, is scheduled on node one.

## Tainting a Node

To taint a node, use the following command where you specify the node name along with a taint in the format of a key-value pair and taint effect:

```bash
kubectl taint nodes node-name key=value:taint-effect

## to taint node one so that it only accepts pods associated with the application blue, run:
kubectl taint nodes node1 app=blue:NoSchedule
```

There are three taint effects:

- **NoSchedule**: Pods that do not tolerate the taint will not be scheduled on the node.
- **PreferNoSchedule**: The scheduler tries to avoid placing non-tolerating pods on the node, but it is not strictly enforced.
- **NoExecute**: New pods without a matching toleration will not be scheduled, and existing pods will be evicted from the node.

## Adding Tolerations to Pods

To allow a specific pod to run on a tainted node, add a toleration to the pod’s manifest. For example, to enable Pod D to run on node one (tainted with “app=blue:NoSchedule”), modify the pod definition as follows:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: myapp-pod
spec:
  containers:
    - name: nginx-container
      image: nginx
  tolerations:
    - key: "app"
      operator: "Equal"
      value: "blue"
      effect: "NoSchedule"
```

This toleration lets the pod bypass the taint and be scheduled on node one.

## Understanding the NoExecute Effect

Using the `NoExecute` taint effect has a more immediate impact. Suppose node one is tainted with the key-value pair “app=blue” and the effect NoExecute. In an initially untainted cluster, all pods schedule normally. But once the taint is applied:

- Pods without a matching toleration (e.g., Pod C) will be evicted from node one if already running, or prevented from being scheduled.

- Pods with the correct toleration (e.g., Pod D) continue to run on node one.

## Master Node Taints

While the discussion so far has focused on worker nodes, master nodes are also capable of running pods. By default, Kubernetes applies a taint to master nodes to prevent workload pods from being scheduled there. This setup ensures that master nodes are reserved for critical system components. To check the taint on a master node, use the following command:

```bash
kubectl describe node control-plane | grep Taint
```

This configuration follows best practices by ensuring that only essential components run on the master node.

## Summary

Taints and tolerations provide a powerful mechanism for controlling pod scheduling in Kubernetes clusters:

| Feature                 | Description                                                                                      | Example Command or Manifest Snippet                        |
| ----------------------- | ------------------------------------------------------------------------------------------------ | ---------------------------------------------------------- |
| Tainting a node         | Prevents pods from being scheduled on a node unless they tolerate the taint                      | kubectl taint nodes <NODENAME> app=blue:NoSchedule         |
| Toleration in a Pod     | Allows a pod to run on a tainted node by including a toleration in its manifest                  | See the YAML snippet above                                 |
| Taint Effect: NoExecute | Evicts pods not tolerating the taint from a node and prevents new non-tolerant pods from joining | Command similar to the taint command with NoExecute effect |

> [!Important]
> Remember that taints and tolerations only influence pod scheduling. If you need to enfore pod placement on specific nodes, use node affinity rules.
