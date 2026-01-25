# Services Loadbalancer

Imagine that pods are distributed across a cluster - say, a three-node cluster. To allow external users to access these applications, services of type **NodePort** were created. The **NodePort** service routes incoming traffic from designated ports on the worker nodes to the corresponding pods. With **NodePort**, you can reach the applications using any node's IP address along with its high port number. For example, if the voting app and the result app are bound to different IP-port combinations, users could access the application using any node's IP address and its specified port, even if the pods are running on only two of the nodes.

> [!Important]
> While NodePort