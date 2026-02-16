# Multiple Schedulers

This document explains how to deploy and configure multiple schedulers in a Kubernetes cluster alongside the default scheduler.

Here, we will learn how to deploy custom schedulers alongside the default scheduler, configure them correctly, and validate their operation.
Kubernetes default scheduler distributes pods across nodes evenly while considering factors such as taints, tolerations, and node affinity. However, certain use cases may require a custom scheduling algorithm. For instance, when an application needs to perform extra verification before placing its components on specific nodes, a custom scheduler becomes essential. By writing your own scheduler, packaging it, and deploying it alongside the default scheduler, you can tailor pod placement to your specific needs.

> [!Important]
> Ensure that every additional scheduler has a unique name. The default scheduler is conventionally named "default-scheduler", and any custom scheduler must be registered with its own distinct name in the configuration files.

## Configuring Schedulers with YAML

Below are examples of configuration files for both the default and a custom scheduler. Each YAML file uses a profiles list to define the scheduler's name.

```yaml
# my-scheduler-config.yaml
apiVersion: kubescheduler.config.k8s.io/v1
kind: KubeSchedulerConfiguration
profiles:
  - schedulerName: my-scheduler
```

```
# scheduler-config.yaml
apiVersion: kubescheduler.config.k8s.io/v1
kind: KubeSchedulerConfiguration
profiles:
  - schedulerName: default-scheduler
```

## Deploying an additional scheduler

You can deploy an additional scheduler using the existing kube-scheduler binary, tailoring its configuration through specific service files.

- **Step-1: Download the kube-scheduler binary**

```bash
wget https://storage.googleapis.com/kubernetes-release/release/v1.12.0/bin/linux/amd64/kube-scheduler
```

- **Step-2: Create Service files**
  Create separate service files for each scheduler. For example, consider the following definitions:

```bash
# kube-scheduler.service
ExecStart=/usr/local/bin/kube-scheduler --config=/etc/kubernetes/config/kube-scheduler.yaml

# my-scheduler-2.service
ExecStart=/usr/local/bin/kube-scheduler --config=/etc/kubernetes/config/my-scheduler-2-config.yaml
```

- **Step-3: Define Scheduler Configuration Files**
  Reference the scheduler names in the associated configuration files:

```yaml
# my-scheduler-2-config.yaml
apiVersion: kubescheduler.config.k8s.io/v1
kind: KubeSchedulerConfiguration
profiles:
  - schedulerName: my-scheduler-2
```

```yaml
# my-scheduler-config.yaml
apiVersion: kubescheduler.config.k8s.io/v1
kind: KubeSchedulerConfiguration
profiles:
  - schedulerName: my-scheduler
```

## Deploying the Custom Scheduler as Pod

In addition to running the scheduler as a service, you can deploy it as a pod inside the Kubernetes cluster. This method involves creating a pod definition that references the scheduler's configuration file:

### Pod Definition

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-custom-scheduler
  namespace: kube-system
spec:
  containers:
    - name: kube-scheduler
      image: k8s.gcr.io/kube-scheduler-amd64:v1.11.3
      command:
        - kube-scheduler
        - --address=127.0.0.1
        - --kubeconfig=/etc/kubernetes/scheduler.conf
        - --config=/etc/kubernetes/my-scheduler-config.yaml
```

The corresponding custom scheduler configuration file might look like:

```yaml
apiVersion: kubescheduler.config.k8s.io/v1
kind: KubeSchedulerConfiguration
profiles:
  - schedulerName: my-scheduler
```

> [!Important]
> Leader election is an important configuration for HA environments. It ensures that while multiple scheduler instances are running, only one actively schedules the pods.

## Deploying the Custom Scheduler as a Deployment

In many modern Kubernetes setups - especially those using Kubeadm - control plane components run as pods or deployments. Below is an example of deploying a custom scheduler as a Deployment.

1. Build and Push a Custom Scheduler Image

```
FROM busybox
ADD ./.output/local/bin/linux/amd64/kube-scheduler /usr/local/bin/kube-scheduler
```

2. Create ServiceAccount and RBAC configurations
   Prepare the following YAML to create a service account and set appropriate RBAC permissions:

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: my-scheduler
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: my-scheduler-as-kube-scheduler
subjects:
  - kind: ServiceAccount
    name: my-scheduler
    namespace: kube-system
roleRef:
  kind: ClusterRole
  name: system:kube-scheduler
  apiGroup: rbac.authorization.k8s.io
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: my-scheduler-as-volume-scheduler
subjects:
  - kind: ServiceAccount
    name: my-scheduler
    namespace: kube-system
roleRef:
  kind: ClusterRole
  name: system:volume-scheduler
  apiGroup: rbac.authorization.k8s.io
```

3. Create a ConfigMap for Scheduler Configuration
   Define a ConfigMap that includes your custom scheduler configuration:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: my-scheduler-config
  namespace: kube-system
data:
  my-scheduler-config.yaml: |
    apiVersion: kubescheduler.config.k8s.io/v1beta2
    kind: KubeSchedulerConfiguration
    profiles:
      - schedulerName: my-scheduler
        leaderElection:
          leaderElect: false
```

4. Define the Deployment
   Deploy the custom scheduler as a Deployment with the following YAML:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-scheduler
  namespace: kube-system
  labels:
    component: scheduler
    tier: control-plane
spec:
  replicas: 1
  selector:
    matchLabels:
      component: scheduler
      tier: control-plane
  template:
    metadata:
      labels:
        component: scheduler
        tier: control-plane
        version: second
    spec:
      serviceAccountName: my-scheduler
      containers:
        - name: kube-second-scheduler
          image: gcr.io/my-gcp-project/my-kube-scheduler:1.0
          command:
            - /usr/local/bin/kube-scheduler
            - --config=/etc/kubernetes/my-scheduler/my-scheduler-config.yaml
          livenessProbe:
            httpGet:
              path: /healthz
              port: 10259
              scheme: HTTPS
            initialDelaySeconds: 15
          readinessProbe:
            httpGet:
              path: /healthz
              port: 10259
              scheme: HTTPS
          volumeMounts:
            - name: config-volume
              mountPath: /etc/kubernetes/my-scheduler
      volumes:
        - name: config-volume
          configMap:
            name: my-scheduler-config
```

> [!Caution]
> Also, ensure a proper ClusterRole exists for the scheduler. For example:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: system:kube-scheduler
  annotations:
    rbac.authorization.kubernetes.io/autoupdate: "true"
  labels:
    kubernetes.io/bootstrapping: rbac-defaults
rules:
  - apiGroups:
      - coordination.k8s.io
    resources:
      - leases
    verbs:
      - create
  - apiGroups:
      - coordination.k8s.io
    resourceNames:
      - kube-scheduler
      - my-scheduler
    resources:
      - leases
    verbs:
      - get
      - list
      - watch
```

## Configuring Workloads to Use the Custom Scheduler

To have specific pods or deployments, use your custom scheduler, add the "schedulerName" field in the pod's specification. For example:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
    - name: nginx
      image: nginx
  schedulerName: my-custom-scheduler
```

If the custom scheduler configuration is incorrect, the pod may remain in the `Pending` state. Conversely, a properly scheduled pod will transition to the `Running` state.

## Verifying Scheduler Operation

To confirm which scheduler assigned a pod, review the events in your namespace:

```bash
kubectl get events -o wide

kubectl logs my-custom-scheduler --namespace=kube-system
```
