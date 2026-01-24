# Service

Credits: [KodeKloud Notes](https://notes.kodekloud.com)

**Kubernetes Services** enable seamless communication between various application components - both within the cluster and from the outside world. 

**Kubernetes Services** allow different sets of pods to interact with each other. Whether
connecting the frontend to backend processes or integrating external data source, **services** 
help to decouple microservices while maintaining reliable communication. For instance, you 
can expose your frontend to end users and enable backend components to interact efficiently.

## Use Case: From Internal Networking to Extenal Access

So far, we have seen how **Pods** communicate internally using the Kubernetes Network. Consider 
a scenario where you deploy a **Pod** running a web application and want an external user to 
access it. Here's a quick overview of the setup:

- **Kubernetes Node IP** : `192.168.1.2`
- **Laptop IP (same network)**: `192.168.1.10`
- **Internal Pod Network**: `10.244.0.0`
- **Pod IP**: `10.244.0.2`

Since the Pod is on an isolated internal network, direct access to `10.244.0.2` from laptop 
isn't possible. One workaround is to SSH into the Kubernetes node (`192.168.1.2`) and use `curl` 
to reach the Pod:

```bash
curl http://10.244.0.2
```

While this method works from the node, the goal is to have external access directly from the laptop using the node's IP. This is where a **Kubernetes Service**, specifically a **NodePort** service, becomes essential. A **NodePort** service maps requests arriving at a designated node 
port (like `32000`) to the Pod's target port.

```bash
curl http://192.168.1.2:32000

```

> This configuration externally exposes the web server running inside the Pod.

## Types of Kubernetes Services

Kubernetes supports several service types, each serving a unique purpose:

- **NodePort**: Maps a port on the node to a port on the pod
- **ClusterIP**: Creates a virtual IP for internal communication between services (e.g., connecting frontend to backend servers)
- **LoadBalancer**: Provisions an external load balancer (supported in cloud environments) to distribute traffic across multiple Pods.

> [!Important]
> The NodePort service type maps a specific node port (e.g., 32000) to the target port on your Pod (e.g., 80). This provides external access while keeping internal port targeting intact.

### NodePort Service Breakdown
With a **NodePort** service, there are three key ports to consider.

1. **Target Port**: The port on the Pod where the application listens (e.g., `80`)
2. **Port**: The virtual port on the service within the cluster
3. **NodePort**: The external port on the Kubernetes node (by default in the range `30000-32767`)

### Creating a NodePort Service
The process of creating a **NodePort** service begins with defining the service in a YAML file.
The definition file follows a similar structure to those used for **Deployments** or **ReplicaSets**, 
including API version, kind, metadata, and spec.

Below is an example YAML file that defines a NodePort Service:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: reactapp-service
spec:
  type: NodePort
  ports:
    - targetPort: 80
      port: 80
      nodePort: 32000
```

In this YAML:
- `targetPort` specifies the Pod's application port
- `port` is the port on the service that acts as a virtual server port within the cluster
- `nodePort` maps the external request to the specific port on the node (ensure its between 30000 and 32767)

> [!Important]
> Note that if you omit `targetPort`, it defaults to the same value as `port`. Similarly, if `nodePort` isn't provided, Kubernetes automatically assigns one.

However, this YAML definition does not link the service to any Pods. To connect the service to specific Pods, a `selector` is used,
just as in **ReplicaSets** or **Deployments**. Consider the following Pod definition:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: reactapp-pod
  labels:
    app: react
    type: frontend
spec:
  containers:
    - name: nginx-container
      image: nginx
```

Now, update the service definition to include a selector that matches these labels:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: reactapp-service
spec:
  type: NodePort
  selector:
    app: react
    type: frontend
  ports:
    - targetPort: 80
      port: 80
      nodePort: 32000
```

Run the following command to create the service:

```bash
kubectl create -f service-definition.yaml

kubectl get services

kubectl get svc
```

## Kubernetes Services in Production

In a production environment, your application is likely spread across multiple Pods for high availability and load balancing. When Pods share matching labels, the service automatically detects and routes traffic to all endpoints. Kubernetes employs a round-robin (or random) algorithm to distribute incoming requests, serving as an integrated load balancer.

Furthermore, even if your Pods are spread across multiple nodes, Kubernetes ensures that the target port is mapped on all nodes. This means you can access your web application using the IP of any node along with the designated **NodePort**, providing reliable external connectivity.

> Regardless of whether your application runs on a single Pod on one node, multiple Pods on a single node, or Pods spread across several nodes, the service creation process remains consistent. Kubernetes automatically updates the service endpoints when Pods are added, or removed, ensuring a flexible and scalable infrastructure.

