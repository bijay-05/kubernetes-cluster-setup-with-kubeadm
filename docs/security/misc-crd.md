# Custom Resource Definition

[Source: KodeKloud Notes](https://notes.kodekloud.com)

In this document, we dive into Custom Resource Definitions (CRDs) in Kubernetes, beginning with an overview of standard Kubernetes resources and controllers before extending these principles to custom resources like our FlightTicket example.

## Understanding Standard Kubernetes Resources and Controllers

Kubernetes relies on built-in controllers to manage standard resources. For instance, when you create a Deployment, Kubernetes stores the desired state in its etcd data store and automatically manages related ReplicaSets and Pods. The deployment controller continuously monitors the Deployment and ensures that the cluster state matches the desired configuration. Creating a Deployment with three replicas will result in three Pods being deployed.

Below is an example YAML file defining a Deployment:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      type: front-end
  template:
    metadata:
      name: myapp-pod
      labels:
        type: front-end
    spec:
      containers:
        - image: nginx
```

After saving the above content as `deployment.yaml`, run the following commands to create, view, and delete te Deployment:

```bash
kubectl create -f deployment.yaml

kubectl get deployments

kubectl delete -f deployment.yaml
```

The deployment controller (implemented in Go within the Kubernetes source code) handles the creation of a ReplicaSet when a new Deployment is detected. The ReplicaSet then creates the required Pods based on the Deployment’s specification. This dynamic process ensures that the actual state of the cluster continuously converges with the desired state.

## Custom Resources and Controllers: The Flight Ticket Example

Building on the standard resource management, you can extend Kubernetes by defining custom resources. Imagine a scenario where you want to manage flight ticket bookings directly in Kubernetes. With a custom resource called FlightTicket, you can create objects representing flight ticket bookings, list them, and delete them as needed.

### FlightTicket Object Definition

Below is an example YAML file that defines a FlightTicket object:

```yaml
apiVersion: flights.com/v1
kind: FlightTicket
metadata:
  name: my-flight-ticket
spec:
  from: Mumbai
  to: London
  number: 2
```

To create and manage this custom resource, execute the following commands:

```bash
kubectl create -f flightticket.yml

kubectl get flightticket

kubectl delete -f flightticket.yml

```

At this stage, the FlightTicket object is stored in etcd; however, it does not trigger any actions. To automate operations - such as interfacing with an external API (e.g., bookflight.com/api) to book or cancel a ticket - you need a custom controller.

## Custom Controller for FlightTicket

A custom controller, typically written in Go, monitors the FlightTicket objects. When a FlightTicket is created, updated or deleted, the controller calls an external API to perform actions such as booking or cancelling a flight. Below is a streamlined Go snippet to illustrate the controller's logic:

```go
package flightticket

import (
	// Imports omitted for brevity
)

var controllerKind = apps.SchemeGroupVersion.WithKind("FlightTicket")

// Run begins watching and syncing FlightTicket resources.
func (dc *FlightTicketController) Run(workers int, stopCh <-chan struct{}) {
	// Controller loop implementation here
}

// callBookFlightAPI books a flight ticket when a FlightTicket resource is created.
func (dc *FlightTicketController) callBookFlightAPI(obj interface{}) {
	// API calling logic here
}
```

> [!Important]
> Without this custom controller, FlightTicket objects remain static data in etcd, and no automated flight booking actions are performed.

## Handling Resource Creation Errors

If you create a FlightTicket object before kubernetes is aware of its type, you will encounter an error similar to:

```bash
kubectl create -f flightticket.yml
# Output:
# no matches for kind "FlightTicket" in version "flights.com/v1"
```

This error appears because Kubernetes does not recognize the FlightTicket resource type. To resolve this, you must first establish a Custom Resource Definition (CRD) for FlightTicket.

## Defining a Custom Resource with a CRD

A Custom Resource Definition (CRD) inform Kubernets about a new resource type, detailing its metadata scope (namespaced or cluster-scoped), API group, naming conventions (singular, plural, and short names), supported version, and a validation schema using OpenAPI v3.

Below is a sample CRD for the FlightTicket resource:

```yaml
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: flighttickets.flights.com
spec:
  group: flights.com
  scope: Namespaced
  names:
    plural: flighttickets
    singular: flightticket
    kind: FlightTicket
    shortNames:
      - ft
  versions:
    - name: v1
      served: true
      storage: true
      schema:
        openAPIV3Schema:
          type: object
          properties:
            spec:
              type: object
              properties:
                from:
                  type: string
                to:
                  type: string
                number:
                  type: integer
                  minimum: 1
```

```bash
kubectl create -f flightticket-custom-definition.yaml
```

Once the CRD is successfully created, Kubernetes can recognize and store FlightTicket objects. However, remember that without the corresponding custom controller, FlightTicket objects will remain as passive data entries.
