# Deployment

Credits: [KodeKloud Notes](https://notes.kodekloud.com)

Deployment is an abstraction that simplifies managing your applications in a production environment. Rather than interacting directly with **Pods** and **ReplicaSets**, deployments offer advanced features that enable you to:

- Deploy multiple instances of your application (like a web server) to ensure high availability and load balancing.
- Seamlessly perform rolling updates for container images so that instances update gradually, reducing downtime.
- Quickly roll back to a previous version if an upgrade fails unexpectedly.
- Pause and resume deployments, allowing you to implement co-ordinated changes such as scaling, version updates, or resource modifications.

Previously, we discussed how individual pods encapsulate containers and how **ReplicaSets** maintain multiple pod copies. A deployment, however, sits at a higher level, automatically managing **ReplicaSets** and **pods** while providing enhanced features like rolling updates and rollbacks.


## Creating a Deployment

To create a deployment, start by writing a deployment definition file. This file is similar to a **ReplicaSet** definition, with the key difference being that the kind is set to `Deployment` instead of `ReplicaSet`. Below is an example of a correct deployment definition file:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: reactapp-deployment
  labels:
    tier: frontend
    app: reactapp
spec:
  replicas: 3
  selector:
    matchLabels:
      tier: frontend
  template:
    metadata:
      labels:
        app: reactapp
        tier: frontend
    spec:
      containers:
        - name: nginx-container
          image: nginx

```

```bash
## create deployment
kubectl create -f deployment-def.yaml

## verify deployment
kubectl get deployments

```

### Behind the Scenes: How Deployments Work

When you create a deployment, Kubernetes automatically creates an associated **ReplicaSet**. To see this in action, run :

```bash
kubectl get replicasets
kubectl get rs
```

> You will notice a new **ReplicaSet** with a name derived from your deployment. This **ReplicaSet** oversees the creation and management of pods. To view the pods managed by the **ReplicaSet**, run:

```bash
kubectl get pods
```

While **Deployments** and **ReplicaSets** work together seamlessly, deployments provide 
additional functionalities such as rolling updates, rollbacks and the ability to pause/resume
changes.

> By leveraging deployments, you gain powerful capabilities like rolling updates and rollbacks 
that make managing application updates and maintenance in production more efficient. Whether you 
are scaling your application or rolling out new features, Kubernetes deployments provide a 
robust solution for modern application management.