# Control Plane Components

## Kube API Server
The central management component in the cluster, handling requests from `kubectl`, validating and authenticating them, interfacing with the `etcd` datastore, and co-ordinating with other components.

> [!Important]
> When we execute command like `kubectl get nodes`, the utility sends a request to the API Server. The server processes this request by authenticating the user, validating the request, fetching data from the `etcd` cluster, and replying with the desired information


### API Server Request Lifecycle
When a direct API POST request is made to create a pod, the server:
- Authenticates and validates the request.
- Constructs a pod object (initially without a node assignment), and updates the `etcd` store.
- Notifies the requester that the pod has been created.

> The `scheduler` continuously monitors the API server for pods that need node assignments. Once a new pod is detected, the scheduler selects an appropriate node and informs the API server. The API Server then updates `etcd` datastore with the new assignment and passes this information to the `kubelet` on the worker node. The `kubelet` deploys the pod via the container runtime, and later updates the pod status back to the API Server for synchronization with `etcd`.