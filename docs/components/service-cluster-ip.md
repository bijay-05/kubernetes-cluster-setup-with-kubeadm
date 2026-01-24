# Services Cluster IP

Cluster IP streamlines connectivity within a full-stack web application by providing a stable interface for pod-to-pod communication.

A typical microservices-based application consists of several pods. Some pods host frontend web 
server, while others run a backend server; additional pods manage services like a key-value store
using Redis or persistent databases like MySQL. The frontend pods need to communicate with the backend 
services, and the backend servers must interact with databases and caching mechanisms.

Because pods receive dynamic IP addresses that can change when they are recreated, relying on these 
IPs for internal communication is impractical. Moreover, when a frontend pod (for example, with IP `10.244.0.3`) 
needs to connect to a backend service, there arises the issue of determining which pod should handle the request. 
Kubernetes solves this challenge by grouping related pods under a single service. This service provides a fixed 
**Cluster IP** or a service name, allowing other pods to access them without worrying about individual IPs. The 
service automatically load-balances incoming requests among the available pods.

For instance, by creating a service for the backend pods, you can group them together under one interface. Similarly, 
services can be set up for Redis or other application tiers, ensuring that each layer can scale independently without 
disrupting internal connectivity.

> [!Important]
> Each service in Kubernetes is automatically assigned an IP and DNS name within the cluster. This Cluster IP should be used by other pods when accessing the service, ensuring consistent and reliable connectivity.

### Example: backend service

Below is a sample YAML configuration for creating a service named **backend**. This service exposes port 80 on the Cluster IP, 
forwarding requests to the backend pods that match the specified labels (`app: expressapp` and `type: backend`). The **targetPort** is set to 80, matching the port where the backend container listens:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: backend
spec:
  type: ClusterIP
  ports:
    - port: 80
      targetPort: 80
  selector:
    app: testapp
    type: backend
```