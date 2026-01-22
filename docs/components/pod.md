# Kubernetes Objects: Pods, Deployments, Services and More

## Pod

A pod is the smallest deployable unit in kubernetes cluster. It can include single (or multiple containers).

> [!Important]
> Every Kubernetes definition file must include the following four fields: `apiVersion:`, `kind:`, `metadata:` and `spec:`

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  labels:
    app: nginx
spec:
  containers:
    - name: nginx-container
      image: nginx
```

1. **apiVersion** : This field indicates the version of the kubernetes API you are using. For a 
Pod, set `apiVersion: v1`. Depending on the object you define, you might need different versions 
such as `apps/v1`, `extensions/v1beta1`, etc.

2. **kind** : This specifies the type of object being created. In this lesson, since we are creating a Pod, define it as `kind: Pod`. Other objects might include *ReplicaSet*, *Deployment*, or *Service*.

3. **metadata** : The metadata section provides details about the object, including its name and labels. It is represented as a dictionary. It is essential to maintain consistent indentation for sibling keys to ensure proper YAML nesting. 

4. **spec** : Provides specific configuration details for the object. For a Pod, this is where you define its containers. Since a Pod can run multiple containers, the `containers` field is an array. In our example, with a single container, the array has just one item. The dash (`-`) indicates a list item, and each container must be defined with at least `name` and `image` keys.