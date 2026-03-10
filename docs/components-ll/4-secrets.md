# Secrets

This document explains how to securely manage sensitive data in kubernetes using secrets while avoiding common security pitfalls. We will see how to securely handle sensitive data (such as passwords and keys) in your kubernetes deployments while avoiding common pitfalls like hardcoding credentials in your application.

## Problem with Hardcoding Sensitive Data

Consider a simple Python web application connecting to a MySQL database. When the connection succeeds, the application displays a success message. However, the code includes hardcoded values for hostname, username, and password, which poses a serious security risk.

Previously, configuration data like these values might have been stored in a ConfigMap. 

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  # Configuration data goes here
```

While storing non-sensitive details like hostnames or usernames in a ConfigMap is acceptable, placing a password in such a resource is not secure. Kubernetes Secrets provide a mechanism to safely store sensitive information by encoding the data.

> [!Caution]
> This is not encryption by default. Secrets encode data using Base64. Although it provides obfuscation, it is not a substitute for encryption.

## Understanding Kubernetes Secrets
Working with secrets in Kubernetes involves two main steps:

1. Create the Secret
2. Inject it into a pod.

There are two primary approaches to creating a secret:
- Imperative Creation: Using the command line to create secrets on the fly.
- Declarative Creation: Defining Secrets in YAML files.

## Imperative Creation of a Secret
With the imperative method, you can supply key-value pairs directly via the command line. For example, to create a Secret named "app-secret" with the key-value pair `DB_HOST=mysql`.

```bash
kubectl create secret generic app-secret --from-literal=DB_Host=mysql
```

To include multiple key-value pairs, use the `--from-literal` option repeatedly:

```bash
kubectl create secret generic app-secret \
  --from-literal=DB_HOST=mysql \
  --from-literal=DB_USER=root \
  --from-literal=DB_PASSWORD=passd
```

Alternatively, create a secret from a file with the `--from-file` option:

```bash
kubectl create secret generic app-secret --from-file=app_secret.properties
```

## Declarative Creation of a Secret
For a more manageable approach, define a Secret in a YAML file. This file should include the API version, kind, metadata and encoded data. Below is a sample YAML definition for a secret:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: app-secret
data:
  DB_Host: bXlzcWw=
  DB_User: cm9vdA==
  DB_Password: cGFzd3Jk
```

Apply the definition with the following command:

```bash
kubectl create -f secret-data.yaml
```

## Converting Plaintext to Base64
On linux hosts, you can cover plaintext values to Base64-encoded strings using the `echo -n` command piped to `base64`. For example:

```bash
echo -n 'mysql' | base64
echo -n 'root' | base64
echo -n 'passwd' | base64
```

## Viewing and Decoding Secrets
After creating a secret, you can list and inspect it with the following commands:

```bash
## List secrets
kubectl get secrets

## describe a secret (without showing sensitive data)
kubectl describe secret app-secret

## view the encoded data in YAML format
kubectl get secret app-secret -o yaml

## to decode an encoded value
echo -n 'bassdffd==' | base64 --decode
```

## Injecting Secrets into a Pod
Once the secret is created, you can inject it into a Pod using environment variables or by mouting them as files in a volume.

### Injecting as Environment Variables
Below is an example Pod definition that injects the Secret as environment variables:

```yaml
# pod-definition.yaml
apiVersion: v1
kind: Pod
metadata:
  name: simple-webapp-color
  labels:
    name: simple-webapp-color
spec:
  containers:
  - name: simple-webapp-color
    image: simple-webapp-color
    ports:
    - containerPort: 8080
    envFrom:
    - secretRef:
        name: app-secret
```

### Mouting Secrets as Files
Alternatively, mount the Secret as files within a volume. Each key in the Secret becomes a separate file:

```yaml
volumes:
- name: app-secret-volume
  secret:
    secretName: app-secret
```

To view the content of a specific file, such as the Database password:

```bash
cat /opt/app-secret-volumes/DB_Password
```