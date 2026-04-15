# TLS in Kubernetes

[Source: KodeKloud Notes](https://notes.kodekloud.com)

This document provides a guide on securing kubernetes clusters using TLS certificates, covering key concepts, components and management practices.

> [!Important]
> Certificate files follow specific naming conventions. Public key certificates typically have a .crt or .pem extension (e.g., server.crt, server.pem, client.crt, client.pem). In contrast, private keys usually include the word "key" in their file name or extension (e.g., server.key or server-key.pem). If a file name lacks "key", it is almost certainly a public key certificate.

## TLS certificates in the Kubernetes Cluster

A Kubernetes cluster consists of master and worker nodes that require secure, encrypted communication. Whether the connection is being made by an administrator using the kubectl utility or directly interacting with the Kubernetes API, a secure TLS connection is essential. Additionally, services within the cluster use server certificates to secure their communications, while client certificates authenticate users or other cluster components.

## Kubernetes Components and Their Certificates

Below is an overview of the main Kubernetes components and the associated certificate configurations:

1. **Kube API server**: The API server exposes an HTTPS service for managing the cluster. It acts as a server and requires its own certificate and key pair (e.g., `api-server.crt` and `api-server.key`).

2. **ETCD Server**: Serving as the datastore for all cluster information, ETCD requires a unique pair of certificates and keys (e.g., `etcd-server.crt` and `etcd-server.key`).

3. **Kubelet on Worker Nodes**: On each worker node, the kubelet service exposes an HTTPS endpoint that communicates with the API server for monitoring and management. This service uses its own certificate and key pair (typically named `kubelet.crt` and `kubelet.key`).

## Client Components and Their Certificates

Several components operate as clients and require authentication when connecting to the Kube API Server:

1. **Administrator (kubectl/REST API)**: The admin user employs a client certificate and key pair (e.g., `admin.crt` and `admin.key`) to establish a secure connection to the API server.

2. **Scheduler**: Managing pod scheduling, the scheduler requires its own client certificate (e.g., `scheduler.crt` and `scheduler.key`) to interact with the API server.

3. **Kube Controller Manager**: This component also utilizes a dedicated certificate pair for authenticating its requests to the API server.

4. **Kube Proxy**: Handling network routing within the cluster, the kube proxy uses a client certificate (generally named `kube-proxy.crt` and `kube-proxy.key`) for secure communications with the API server.
