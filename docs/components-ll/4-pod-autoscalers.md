# Pod Autoscaler

[Source: KodeKloud Notes](https://notes.kodekloud.com)

## Horizontal Pod Autoscaler

Let's review Horizontal Pod Autoscaler in Kubernetes and how it automates workload scaling, improving efficiency over manual scaling methods.

### Manual Horizontal Scaling

As a Kubernetes administrator, you might manually scale your application to ensure it has enough resources during traffic spikes. Consider the following deployment configuration:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
        - name: my-app
          image: nginx
          resources:
            requests:
              cpu: "250m"
            limits:
              cpu: "500m"
```

In this configuration, each pod requests 250 millicores (mCPU) and is limited to 500 mCPU. To monitor the resource usage of a pod, you might run:

```bash
kubectl top pod my-app-pod
```

Once you observe the pod’s CPU usage nearing the threshold (for example, at 450 mCPU), you would manually execute a scale command to add more pods:

```bash
kubectl scale deployment my-app --replicas=3
```

> [!Important]
> Manual scaling requires continuous monitoring and timely intervention, which may not be ideal during unexpected surges in traffic.

## Introduction to Horizontal Pod Autoscaler (HPA)

To address the shortcomings of manual scaling, Kubernetes offers the Horizontal Pod Autoscaler (HPA). HPA continuously monitors pod metrics—such as CPU, memory, or custom metrics—using the metrics-server. Based on these metrics, HPA automatically adjusts the number of pod replicas in a deployment, stateful set, or replica set. When resource usage exceeds a preset threshold, HPA increases the pod count; when usage declines, it scales down to conserve resources.

For example, with the nginx deployment above, you can create an HPA by running the command below. This command configures the “my-app” deployment to maintain 50% CPU utilization, scaling the number of pods between 1 and 10:

```bash
kubectl autoscale deployment my-app --cpu-percent=50 --min=1 --max=10
```

Kubernetes will then create an HPA that monitors the CPU metrics (using the pod’s 500 mCPU limit) via the metrics-server. If the average CPU utilization exceeds 50%, HPA adjusts the replica count to meet demand without manual input.

To review the status of your HPA, use:

```bash
kubectl get hpa
```

This command shows the current CPU usage, threshold set, and the number of replicas- ensuring that pod counts remain within the defined limits. When the HPA is no longer needed, you can remove it with:

```bash
kubectl delete hpa my-app
```

### Declarative Configuration for HPA

Beyond the imperative approach, you can declare the HPA configuration with a YAML file. Here’s an example using the `autoscaling/v2` API:

```bash
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: my-app-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: my-app
  minReplicas: 1
  maxReplicas: 10
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 50
```

This configuration ensures that the HPA monitors the CPU utilization of the “my-app” deployment, automatically adjusting the replica count as needed. Note that HPA, integrated into Kubernetes since version 1.23, relies on the metrics-server to obtain resource utilization data.
