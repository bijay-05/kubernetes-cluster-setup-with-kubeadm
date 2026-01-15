# ETCD, Cluter Memory
A distributed, reliable key-value store that is both simple and fast. It plays a critical role in storing cluster state, detail different deployment approaches, and explain high availability considerations.

In contrast to relational databases (MySQL, PostgreSQL), where in order to add additional data the expansion of table is needed (adding colums), a key-value store organizes data as independent documents or files. Each document contains all relevant information for an individual, allowing flexible and dynamic data structures.

> [!Important]
> By default, etcd listens on port 2379. It is a KV store that maintains configuration data, state information, and metadata for your kubernetes cluster. Every object - nodes, pods, configurations, secrets, accounts, roles, and role bindings - is stored within etcd. The data we get from `kubectl get`, is retrieved from this data store. Any changes made to the cluster - whether adding nodes, deploying pods, or configuring ReplicaSets - are first recorded in etcd. Only after etcd is updated are these changes considered to be complete.


```bash

### install etcd
curl -L https://github.com/etcd-io/etcd/releases/download/v3.3.11/etcd-v3.3.11-linux-amd64.tar.gz -o etcd-v3.3.11-linux-amd64.tar.gz

## interact with etcdctl
etcdctl set keyA valueA

etcdctl get keyA

etcdctl put keyB valueB
```

## High Availability Considerations
In production environment, HA is paramount. By running multiple master nodes with corresponding **etcd** instances, you ensure that your cluster remains resilient even if one node fails.

To enable HA, each **etcd** instance must know about its peers. This is achieved by configuring `--initial-cluster` parameter with the details of each member in the cluster.
