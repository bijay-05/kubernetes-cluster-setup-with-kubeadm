# Worker Node Components

Credits: [KodeKloud Notes](https://notes.kodekloud.com)

## Kubelet

The kubelet oversees node activities by managing container operations such as starting and stopping containers based on instructions from the master scheduler. Additionally, the Kubelet registers the node with the **Kubernetes Cluster** and continuously monitors the state of pods and their containers. It regularly reports the status of the node and its workloads to the Kubernetes API Server.

When the **Kubelet** receives instructions to run a container or pod, it communicates with the container runtime (e.g., Container-D) to download the required image and initiate the container. It then maintains the health of these containers and ensures they operate as expected.

> [!Important]
> The kubelet is essential for node management in Kubernetes, acting as the intermediary between the cluster's control plane and the container runtime.

### Installing the Kubelet

```bash
wget https://storage.googleapis.com/kubernetes-release/release/v1.13.0/bin/linux/amd64/kubelet

## service file
ExecStart=/usr/local/bin/kubelet \
  --config=/var/lib/kubelet/kubelet-config.yaml \
  --container-runtime=remote \
  --container-runtime-endpoint=unix:///var/run/containerd/containerd.sock \
  --image-pull-progress-deadline=2m \
  --kubeconfig=/var/lib/kubelet/kubeconfig \
  --network-plugin=cni \
  --register-node=true \
  --v=2

## verify the kubelet process
ps aux | grep kubelet
```

## Kube Proxy

**Kube Proxy** ensures reliable communication between pods and how it enables **Services** to function seamlessly across your cluster.

### Pod Networking in Kubernetes

Kubernetes enables every pod within a cluster to communicate with one another by deploying a robust pod networking solution. This creates an internal virtual network that spans all nodes, connecting every pod.

Image your web application is running on one node while your database application is on another. Though the web application could connect to the database via its pod IP, these IPs are transient and may change. The recommended solution is to create a **Service**. By exposing the database through a **Service** (e.g., using the name "DB"), the web application can maintain a consistent connection without relying on fluctuating pod IPs. Each **Service** is assigned a stable IP address, and traffic routed to the **Service** is automatically forwarded to the appropriate backend pod.

> [Important]
> A Service in Kubernetes is a virutal entity that doesn't correspond to a container or network interface. Instead, it provides a persistent endpoint in the cluster's memory. allowing stable access to the underlying pods.

### How Kube Proxy works

**Kube Proxy** is a lightweight process that runs on every node in the Kubernetes cluster. Its key function is to monitor for **Service** creations and configure network rules that redirect traffic to the corresponding pods. One common method it uses is by setting up IP Tables rules.

> For example, if a Service is assigned the IP `10.96.0.12`, Kube Proxy configures the IP tables 
on each node so that any traffic directed to that IP is forwarded to the actual pod IP, (such as  `10.2.1.13`). This redirection mechanism ensures that Services work transparently across the cluster, regardless of which node initiates the request.

### Installing Kube Proxy

- Download the **Kube Proxy** binary from the release page.
- Extract the binary and run it as a service on nodes.

> [!Important]
> Using kubeadm, Kube Proxy is automatically managed as a DaemonSet. streamlining the process of ensuring that every node runs a Kube Proxy instance.

### Verify Kube Proxy Deployment

```bash
kubectl get daemonset -n kube-system
```