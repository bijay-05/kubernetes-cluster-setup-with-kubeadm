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

## Authentication Methods for Kube-ApiServer

Kubernetes clusters run on multiple nodes (physical or virtual) and include components that co-ordinate access to the control plane and workloads. Several types of principals interact with the cluster:

- Administrators who perform cluster-level operations.
- Developers who deploy and iterate on applications.
- End users who access applications (application-level auth is handled by the apps themselves and is out of scope here).
- Robots (processes, controllers, CI systems, and third-party services) that call the Kubernetes API programmatically.

Here we focus on securing administrative access to the kube-apiserver — the central API endpoint that authenticates and authorizes all requests to the control plane. That includes access performed by humans (admins, developers) and machines (controllers, CI systems, operators).

Kubernetes does not manage regular user accounts natively: you cannot create or list standard user objects with kubectl. User identities are typically introduced to the cluster through external mechanisms, such as:

- static files (legacy),
- TLS client certificates,
- or an external identity provider (OIDC, LDAP, Kerberos, SAML, etc).

> Service accounts, on the other hand, are a Kubernetes resource and are created/managed via the API. Example:

```bash
# create a service account
kubectl create serviceaccount sa1

# list service accounts in the current namespace
kubectl get serviceaccounts
```

> [!Important]
> All incoming API requests (from kubectl, dashboard, controllers, or direct API calls) are received by kube-apiserver, which authenticates each request before applying authorization rules.

| **Mechanism**                            | **Use Case**                                   | **Example / Notes**                                                                |
| ---------------------------------------- | ---------------------------------------------- | ---------------------------------------------------------------------------------- |
| Static basic-auth file                   | Small experiments, local demos                 | CSV of username/password (plaintext); configured via —basic-auth-file (deprecated) |
| Static token file                        | Simple automation, throwaway clusters          | CSV mapping bearer tokens to users; configured via —token-auth-file (deprecated)   |
| TLS client certificates                  | Secure machine access, admin/user certificates | Use CA-signed client certs; verified by kube-apiserver                             |
| External identity providers (OIDC, LDAP) | Enterprise SSO, centralized user management    | Integrate kube-apiserver with OIDC/LDAP for federated auth                         |

**Static basic-auth file**

- A basic-auth file is a CSV containing password, username, uid, and groups.
- kube-apiserver reads it when started with the —basic-auth-file flag.
- Credentials are stored in clear text — insecure and deprecated.

Enable this mechanism on kube-apiserver (not recommended):

```yaml
--basic-auth-file=/path/to/basic-auth.csv
```

Authenticate with HTTP Basic (example using cURL)

```bash
curl -k -u user10:KpjCVbI7rCFAHYPkByTIzRb7gu1cUc4B https://master-node-ip:6443/api
```

Static token file

- A token file is a CSV mapping bearer tokens to user identities and groups.
- kube-apiserver reads it via the —token-auth-file flag.
- Like the basic file, it stores tokens in plaintext — insecure and deprecated.
