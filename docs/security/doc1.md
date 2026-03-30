# Security in Kubernetes

[Source: KodeKloud Notes](https://notes.kodekloud.com)

This document provides comprehensive guide on kubernetes security, covering access control, authentication mechanisms, TLS certificates, and authorization methods. We will learn how access is granted to a kubernetes cluster, how various actions are controlled, and review the different authentication mechanisms available. We will also examine the default conifgurations of a cluster and demonstrate how to view the configurations of an existing cluster.


## Kubernetes Security Primitives

Core security features essential for protecting production-grade kubernetes clusters, including securing hosts, API server access control, and network policies.

### Securing cluser hosts

The security of your kubernetes cluster begins with the hosts themselves. Protect your underlying infrastructure by following these best practices:

- Disable root access
- Turn off password-based authentication
- Enfore SSH Key-based authentication
- Implement additional measures to secure your physical or virtual systems

### API Server Access Control

The Kube API server is at the heart of Kubernetes operations because all cluster interactions - whether via the kubectl command-line tool or directly through API calls - pass through it. Effective access control is essential, focusing on two key operations:

1. Who can access the cluster ?
2. What actions are they permitted to perform ?

### Authentication

Authentication verifies the identity of a user or service before granting access to the API server. Kubernetes offers various authenticaiton mechanisms to suit different security needs:

- Static User IDs and passwords
- Tokens
- Client certificates
- Integration with external authentication providers (e.g., LDAP)

> Additionally, service accounts support non-human processes.

### Authorization

After authentication, authorization determines what actions a user or service is allowed to perform. The default mechanism, Role-Based Access Control (RBAC), associates identities with specific permissions. Kubernetes also supports:

- Attribute-Based Access Control (ABAC)
- Node Authorization
- Webhook-based authorization

These mechanisms enforce granular access control policies, ensuring that authenticated entities can perform only the operations they are permitted to execute.

### Securing Component Communications

Secure communications between kubernetes components are enabled via TLS encryption. This ensures that data transmitted between key components remains confidential and tamper-proof. Encryption protects:

- Communication within the etcd cluster
- Interactions between the kube controller manager and kube scheduler
- Links between worker node components such as the kubelet and kube proxy

### Network Policies

By default, pods in a kubernetes cluster communicate freely with one another. To restrict unwanted interactions and enhance security, kubernetes provides network policies. These policies allow you to:
- Control traffic flow between specific pods
- Enfore security rules at the network level