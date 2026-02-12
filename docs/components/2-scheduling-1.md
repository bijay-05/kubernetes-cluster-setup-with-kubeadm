# Configuring Scheduler Profiles
 [Source : KodeKloud Notes](https://notes.kodekloud.com)

This document explains configuring scheduler profiles in kubernetes to customize scheduling behaviour and manage multiple profiles within a single scheduler binary.

We dive into the concept of scheduler profiles and their configuration in Kubernetes. We will start with a refresher on how the Kubernetes scheduler functions. illustrated by a simple example where a pod is scheduled to one of several available nodes.

## How Scheduling works

When a pod is defined, it enters a scheduling queue along with other pending pods. Consider a pod that requires 10 CPU; it will only be scheduled on nodes with at least 10 available CPUs. Additionally, pods with higher priorities are placed at the beginning of the queue. For instance, the following pod definition uses a high-priority class:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: simple-webapp-color
spec:
  priorityClassName: high-priority
  containers:
    - name: simple-webapp-color
      image: simple-webapp-color
      resources:
        requests:
          memory: "1Gi"
          cpu: 10
```

Before using this priority, you must create a priority class with a specific name and a priority value. Assigning a value like 1,000,000, for example, grants a very high priority. This ensures that pods with higher priorities are scheduled ahead of those with lower ones.

## Scheduling Phases

After being queued, pods progress through several phases:

1. **Filter Phase**: Nodes that cannot meet the pod's resource requirements (e.g., nodes lacking 10 CPUs) are filtered out.
2. **Scoring Phase**: Remaining nodes are scored based on resource availability after reserving the required CPU. For example, a node with 6 CPUs left scores higher than one with only 2.
3. **Binding Phase**: The pod is assigned to the node with the highest score.

## Key Scheduler Plugins
Several scheduler plugins play critical roles during these phases:
