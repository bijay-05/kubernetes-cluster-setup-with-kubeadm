# Role Based Access Controls

[Source: KodeKloud Notes](https://notes.kodekloud.com)

This document explains how to implement Role-Based Access Controls in Kubernetes, inlcuding creating roles, role bindings, and verify permissions. We will see how to create roles, bind them to users, and veirfy permissions within a namespace.

## Creating a Role

To define a role, create a YAML file that sets the API version to `rbac.authorization.k8s.io/v1` and the kind to `Role`. In this example, we create a role named **developer** to grant developers specific permissions. The role includes a list of rules where each rule specifies the API groups, resources, and allowed verbs. For resources in the core API group, provide an empty string (`""`) for the `apiGroups` field.

For instance, the following YAML definition grants developers permissions on pods (with various actions) and allows them to create ConfigMaps:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: developer
rules:
  - apiGroups: [""]
    resources: ["pods"]
    verbs: ["list", "get", "create", "update", "delete"]
  - apiGroups: [""]
    resources: ["ConfigMap"]
    verbs: ["create"]
```

Create the role by running:

```bash
kubectl create -f developer-role.yaml
```

> [!Important]
> Both roles and role bindings are namespace-scoped. This example assumes usage within the default namespace. To manage access in a different namespace, update the YAML metadata accordingly.

## Creating a Role Binding

After defining a role, you need to bind it to a user. A role binding links a user to a role within a specific namespace. In this example, we create a role binding named `devuser-developer-binding` that grants the user `dev-user` the **developer** role.

Below is the combined YAML definition for both creating the role and its corresponding binding:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: developer
rules:
  - apiGroups: [""]
    resources: ["pods"]
    verbs: ["list", "get", "create", "update", "delete"]
  - apiGroups: [""]
    resources: ["ConfigMap"]
    verbs: ["create"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: devuser-developer-binding
subjects:
  - kind: User
    name: dev-user
    apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: developer
  apiGroup: rbac.authorization.k8s.io
```

Create the role binding using the command:

```bash
kubectl create -f devuser-developer-binding.yaml
```

## Verifying Roles and Role Bindings

After applying your configurations, it’s important to verify that the roles and role bindings have been created correctly.

To list all roles in the current namespace, execute:

```bash
kubectl get roles
```

Next, list all role bindings:

```bash
kubectl get rolebindings
```

For detailed information about the **developer** role, run:

```bash
kubectl describe role developer

kubectl describe rolebinding devuser-developer-binding
```

## Testing Permissions with kubectl auth

You can test whether you have the necessary permissions to perform specific actions by using the `kubectl auth can-i` command. For example, to check if you can create deployments, run:

```bash
kubectl auth can-i create deployments

kubectl auth can-i delete nodes

kubectl auth can-i create deployments --as dev-user
```
