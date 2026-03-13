# Rolling Updates And Rollbacks

[Source: KodeKloud Notes](https://notes.kodekloud.com)

This document covers managing updates and rollbacks in Kubernetes deployments, including rollouts, versioning, deployment strategies, and practical commands for minimal downtime.

In this article, we explore key concepts such as rollouts, versioning, and various deployment strategies. We also provide practical commands to update your deployments with minimal downtime and to revert changes when necessary.

> This document covers the process of monitoring deployment rollouts, updating container images, and performing rollbacks using kubernetes commands.

## Understanding Rollouts and Versioning

When you create a deployment, Kubernetes initiates a rollout that establishes the first deployment revision (revision one). Later, when you update your application—say by changing the container image version—Kubernetes triggers another rollout, creating a new revision (revision two). These revisions help you track changes and enable rollbacks to previous versions if issues arise.

### To monitor and review these rollouts, you can use the following commands:

```bash
# check the rollout status
kubectl rollout status deployment/myapp-deployment

# view the history of rollouts
kubectl rollout history deployment/myapp-deployment
```

## Deployment Strategies

There are different strategies to update your applications. For example, consider a scenario where your web application is running five replicas.
One approach is the **recreate** strategy, which involves shutting down all existing instances before deploying new ones. However, this method results in temporary downtime as the application becomes inaccessible during the update.

A more seamless approach is the **rolling update** strategy. Here, instances are updated one at a time, ensuring continuous application availability throughout the process.

If no strategy is specified when creating a deployment, kubernetes uses the rolling update strategy by default.

## Updating a Deployment

There are several methods to update your deployment, such as adjusting the container image version, modifying labels, or changing the replica count. A common practice is to update your deployment definition file and then apply the changes.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp-deployment
  labels:
    app: myapp
    type: front-end
spec:
  replicas: 3
  selector:
    matchLabels:
      type: front-end
  template:
    metadata:
      name: myapp-pod
      labels:
        app: myapp
        type: front-end
    spec:
      containers:
        - name: nginx-container
          image: nginx:1.7.1
```

After updating the file, apply the changes:

```bash
kubectl apply -f app-deployment.yml
```

This action triggers a new rollout and creates a new deployment revision. Alternatively, you can update the container image directly using the following command:

```bash
kubectl set image deployment/myapp-deployment nginx-container=nginx:1.9.1
```

> [!Caution]
> Remember, using `kubectl set image` updates the running deployment but does not modify your deployment definition file. Ensure you update the file as well for future references.

## Viewing Deployment Details

To retrieve detailed information about your deployment—including rollout strategy, scaling events, and more—use:

```bash
kubectl describe deployment myapp-deployment
```

This output shows different details depending on the strategy used:

- **Recreate Strategy**: Events indicate that the old ReplicaSet is scaled down to zero before scaling up the new ReplicaSet.

- **Rolling Update Strategy**: The old ReplicaSet is gradually scaled down while the new ReplicaSet scales up.

## Upgrading and Rolling Back

During an upgrade, Kubernetes creates a new ReplicaSet for the updated containers while the original ReplicaSet continues to run the old version. This rolling update process ensures that new pods replace the old ones gradually without causing downtime.

If an issue is detected after an upgrade, you can revert to the previous version using the rollback feature. To perform a rollback, run:

```bash
kubectl rollout undo deployment/myapp-deployment
```

This command scales down the new ReplicaSet, restoring pods from the older ReplicaSet. Verify the state of ReplicaSets before and after a rollback with:

```bash
kubectl get replicasets
```
