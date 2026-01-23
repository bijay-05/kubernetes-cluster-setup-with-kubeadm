# ReplicaSets

Credits: [KodeKloud Notes](https://notes.kodekloud.com)

Kubernetes Controllers continuously monitor objects and take necessary actions, and 
in this doc, we focus on the replication controller - an essential building block
for maintaining high availability in your cluster.

Imagine a scenario where a single pod runs your application. If that pod crashes or 
fails, users lose access. To prevent this risk, running multiple pod instances is 
key. A Replication Controller ensures high availability by creating and maintaining 
the desired number of pod replicas. Even if you intend to run a single pod, a replication 
controller adds redundancy by automatically creating a replacement if the pod fails.

> If one pod serving your application crashes, the Replication Controller immediately 
deploys a new one to keep the service available.

> Beyond availability, Replication Controllers also help distribute load. When user 
demand increases, additional pods can better balance that load. If resources on a 
particular node become scarce, new pods can be scheduled across other nodes in the 
cluster.

> [!Important]
> While both Replication Controllers and ReplicaSets serve similar purposes, the 
Replication Controller is the older technology being gradually replaced by the ReplicaSet.
Here we will focus on Replica Sets.

### Creating a Replication Controller

**spec** : It not only defines the desired number of replicas with the **replicas** key
but also includes a **template** section which serves as the blueprint for creating the pods.
Ensure that all pod-related entries in the template are indented correctly and aligned
with **replicas** as siblings.

```yaml
apiVersion: v1
kind: ReplicationController
metadata:
  name: myapp-rc
  labels:
    app: frontend
    tier: first
spec:
  replicas: 3
  template:
    metadata:
      name: myapp-pod
      labels:
        app: frontend
        tier: first
    spec:
      containers:
        - name: nginx-controller
          image: nginx
```

When you run the following command, Kubernetes creates three pods according to the 
provided template.

```bash
kubectl create -f rc-definition.yaml

kubectl get ReplicationController

kubectl get pods
```

### Introducing ReplicaSet
ReplicaSet is a modern alternative to the replication controller, using an updated API 
version and some improvements. Here are the key differences:

1. **API Version** : Use `apps/v1` for a **ReplicaSet**

2. **Selector** : In addition to metadata and specification, a **ReplicaSet** requires a
`selector` to explicitly determine which pods to manage. This is defined using `matchLabels`, 
which can also capture pods created before the **ReplicaSet** if they match the criteria.

```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: reactapp-replicaset
  labels:
    app: reactapp
    tier: frontend
spec:
  replicas: 3
  selector:
    matchLabels:
      tier: frontend
  template:
    metadata:
      name: reactapp-pod
      labels:
        app: reactapp
        tier: frontend
    spec:
      containers:
        - name: nginx-container
          image: nginx
```

Create the **ReplicaSet** with:

```bash
kubectl create -f replicaset-def.yaml

## verify creation
kubectl get replicaset

## view the associated pods
kubectl get pods
```

### Labels and Selectors
Labels in Kubernetes are critical because they enable controllers, such as ReplicaSets, to 
identify and manage the appropriate pods within a large cluster. For example, if you deploy 
multiple instances of a frontend web application, assign a label (e.g., `tier: frontend`) to 
each pod. Then, use a selector to target those pods.

```yaml
selector:
  matchLabels:
    tier: frontend
```

> [!Important]
> The pod definition should similarly include the label:

```yaml
metadata:
  name: reactapp-pod
  labels:
    tier: frontend
```

This label-selector mechanism ensures that the **ReplicaSet** precisely targets the intended 
pods and maintains the set number of replicas by replacing any failed pods.

> [!Important]
> Is the Template Section Required ?
> Even if three pods with matching labels already exist in the cluster, the template section 
in the ReplicaSet specification remains essential. It serves as the blueprint for creating new 
pods if any fail, ensuring the desired state is consistently maintained.


### Scaling the ReplicaSet
Scaling a **ReplicaSet** involves adjusting the number of pod replicas. There are two 
methods to achieve this:

1. **Update the Definition File**
Modify the `replicas` value in your **YAML** file (e.g., change from 3 to 6) and update the 
**ReplicaSet** with:

```bash
kubectl replace -f replicaset-def.yaml
```

2. **Use the kubectl scale command**
Scale directly from the command line:

```bash
kubectl scale --replicas=6 -f replicaset-def.yaml
```

> [!Important]
> Keep in mind that if you scale using `kubectl scale` command, the YAML file still reflects 
the original number of replicas. To maintain consistency, it may be necessary to update the 
YAML file after scaling.

### Common Commands Overview

| Resource Type | Use Case | Example Command |
|---------------|----------|-----------------|
| Create Object | Create from a definition file | `kubectl create -f <filename> |
| View ReplicaSets/RC | List Replication Controllers | `kubectl get replicaset` or `kubectl get replicationcontroller` |
| Delete ReplicaSet/RC | Remove a Replication Controller | `kubectl delete replicaset <replicaset-name> |
| update definition | Replace object using YAML file | `kubectl replace -f <filename>` |
| scale ReplicaSet/RC | Change number of replicas | `kubectl scale --replicas=<number> -f <filename> |

