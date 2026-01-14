# Architecture and Components of Kubernetes Cluster

Kubernetes is all about simplifying the deployment, scaling and management of containerized applications through automation. The cluster consists of nodes - whether physical or virtual, that host your containerized applications.

## Master Node
The master node hosts control plane, which comprises of several components that manage the entire cluster. The control plane keeps track of all nodes, decides where applications should run, and continuously monitors the cluster.

> [!Important]
> The control plane keeps detailed information about each container, its corresponding node and cluster state in a highly available key-value store called etcd. Etcd uses a simple key-value format along with a quorum mechanism, ensuring reliable and consistent data storage across the cluster.

### Control plane components

### Scheduler
When a new pod is ready, the kubernetes scheduler determines which worker node should host it. The scheduler takes into account current load, resource requirements, and specific constraints like taints, tolerations, or node affinity rules. This scheduling process is vital for efficient cluster operation.

### ETCD cluster
Stores cluster-wide configuration and state data

### Controllers
Manage node lifecycle, container replication, and system stability

### Kube API server
Acts as the central hub for cluster communication and management

## Worker Node
The worker node(s) are responsible for running the containerized applications. Each node is managed by the kubelet, the node's agent, which ensures that containers are running as instructed.

### Kubelet
Manages container lifecycle on an individual node, receives instructions from API server to create, update, or delete containers, and regularly report the node's status.

### Kube Proxy
Configures networking rules on worker nodes, thus enabling smooth inter-container communication across nodes. For instance; it allow backend server (container) running on node-A to interact with with a database container on node-B.