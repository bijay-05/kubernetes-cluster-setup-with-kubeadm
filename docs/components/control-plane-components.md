# Control Plane Components

## Kube API Server
The central management component in the cluster, handling requests from `kubectl`, validating and authenticating them, interfacing with the `etcd` datastore, and co-ordinating with other components.

> [!Important]
> When we execute command like `kubectl get nodes`, the utility sends a request to the API Server. The server processes this request by authenticating the user, validating the request, fetching data from the `etcd` cluster, and replying with the desired information


### API Server Request Lifecycle
When a direct API POST request is made to create a pod, the server:
- Authenticates and validates the request.
- Constructs a pod object (initially without a node assignment), and updates the `etcd` store.
- Notifies the requester that the pod has been created.

> The `scheduler` continuously monitors the API server for pods that need node assignments. Once a new pod is detected, the scheduler selects an appropriate node and informs the API server. The API Server then updates `etcd` datastore with the new assignment and passes this information to the `kubelet` on the worker node. The `kubelet` deploys the pod via the container runtime, and later updates the pod status back to the API Server for synchronization with `etcd`.

## Kube Controller Manager
A vital component in kubernetes responsible for managing a variety of controllers within your cluster. Understanding its role and configuration is crucial for ensuring a resilient and well-orchestrated kubernetes environment.

In kubernetes, a controller acts like a department in an organization -  each controller is tasked with handling a specific responsibility. For instance, one controller might monitor the health of nodes, while another ensures that the desired number of pods is always running. These controllers constantly observe system changes to drive the cluster towards its intended state.

> The Node Controller, for example, checks node statuses every five seconds through the Kube API Server. If a node stops sending heartbeats, it is not immediately marked as unreachable; instead, there is a grace period of 40 seconds followed by an additional five minutes for potential recovery before its pods are rescheduled onto a healthy node.

> [!Important]
> Another essential controller is the Replication Controller, which ensures that the specified number of pods is maintained by creating new pods when needed. This mechanism reinforces the resilience and reliability of your kubernetes cluster.

All core Kubernetes constructs - such as Deployments, Services, Namespaces, and Persistent Volumes - rely on these constrollers. Essentially, controllers serve as the "brains" behind many operations in a cluster.

### How Controllers are packaged
All individual controllers are bundled into a single process known as the **Kubernetes Controller Manager**. When you deploy the **Controller Manager**, every associated controller is started together. This unified deployment simplifies management and configuration.

### Installing and Configuring the Kube Controller Manager

1. Download the **Kube Controller Manager** from the Kubernetes release page.
2. Extract the binary and run it as a service
3. Review the configurable options provided, which allow you to tailor its behaviour.

```bash
wget https://storage.googleapis.com/kubernetes-release/release/v1.13.0/bin/linux/amd64/kube-controller-manager

## sample config file

ExecStart=/usr/local/bin/kube-controller-manager \
    --address=0.0.0.0 \
    --cluster-cidr=10.200.0.0/16 \
    --cluster-name=kubernetes \
    --cluster-signing-cert-file=/var/lib/kubernetes/ca.pem \
    --cluster-signing-key-file=/var/lib/kubernetes/ca-key.pem \
    --kubeconfig=/var/lib/kubernetes/kube-controller-manager.kubeconfig \
    --leader-elect=true \
    --root-ca-file=/var/lib/kubernetes/ca.pem \
    --service-account-private-key-file=/var/lib/kubernetes/service-account-key.pem \
    --service-cluster-ip-range=10.32.0.0/24 \
    --use-service-account-credentials=true \
    --v=2

```

> This configuration includes additional options for the **Node Controller**, such as node monitor period, grace period, and eviction timeout. Additionally, you can control which controllers are enabled through the `--controller` flag.

> [!Important]
> By default, all controllers are enabled. You can selectively enable or disable controllers by using the syntax `foo` to enable and `-foo` to disable. For example, `--controllers=*, -tokencleaner`, will disable the `tokencleaner` controller.


```bash
## Example of Specifying Controllers
--controllers stringSlice       Default: [*]
A list of controllers to enable. '*' enables all on-by-default controllers, 'foo' enables the 
controller named 'foo', '-foo' disables the controller named 'foo'.
All controllers: attachdetach, bootstrapsigner, clusterrole-aggregation, cronjob, csrapproving,
csrcleaner, csrsigning, daemonset, deployment, disruption, endpoint, garbagecollector,
horizontalpodautoscaling, job, namespace, nodeipam, nodelifecycle, persistentvolume-binder,
persistentvolume-expander, podgc, pv-protection, pvc-protection, replicaset, 
replicationcontroller,
resourcequota, root-ca-cert-publisher, route, service, serviceaccount, serviceaccount-token, 
statefulset,
tokencleaner, ttl, ttl-after-finished
Disabled-by-default controllers: bootstrapsigner, tokencleaner
```

| Controllers |
|-------------|
| Node Controller |
| Replication Controller |
| Deployment Controller |
| Namespace Controller |
| Endpoint Controller |
| PV Protection Controller |
| CronJob |
| Job Controller |
| Service Account Controller |
| Stateful Set |
| Replica Set |
| PV Binder Controller |


## Kube Scheduler
A core component, whose role is determining on which node a pod should be placed. It is important to note that while the scheduler makes the placement decision, the actual creation of the pod on the selected node is carried out by the kubelet.

### Scheduler Process Overview
The primary responsibility of the **kubernetes scheduler** is to assign pods to nodes based on a series of criteria. This ensures
that the selected node has sufficient resources and meets any specific requirements. For instance, different nodes may be 
designated for certain applications or come with varied resource capacities. When multiple pods and nodes are involved, the 
scheduler assessses each pod against the available nodes through a two-phase process: *filtering* and *ranking*.

1. **Filtering Phase**
In the filtering phase, the scheduler eliminates nodes that do not meet the pod's resource requirements. For example, nodes that 
lack sufficient CPU or memory are immediately excluded.

2. **Ranking Phase**
After filtering, the scheduler enters the ranking phase. Here, it uses a priority function to score and compare the remaining 
nodes on a scale from 0 to 10, ultimately selecting the best match. For instance, if placing a pod on one node would leave six 
free CPUs (four more than alternative node), that node is assigned a higher score and is chosen.

For more advanced scheduling configurations - such as resource limits, taints and tolerations, node selectors, and affinity rules
 - refer to the [Kubernetes Documentation](https://kubernetes.io/docs/)

 ### Installing and Running the Kube Scheduler

 ```bash

wget https://storage.googleapis.com/kubernetes-release/release/v1.13.0/bin/linux/amd64/kube-scheduler

## service file
ExecStart=/usr/local/bin/kube-scheduler \
  --config=/etc/kubernetes/config/kube-scheduler.yaml \
  --v=2
 ```