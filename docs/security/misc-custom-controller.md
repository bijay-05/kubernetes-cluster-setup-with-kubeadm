# Custom Controllers

[Source: KodeKloud Notes](https://notes.kodekloud.com)

In this document, we delve into developing custom controllers for Kubernetes, focusing on monitoring FlightTicket objects, and integrating with a flight booking API. Building on our previous work, we have already defined a custom resource and created FlightTicket objects with data stored in etcd. The next step is to continuously monitor these objects and perform corresponding actions—such as calling a flight booking API to book, modify, or cancel flight tickets. This process is the core function of a custom controller.

A controller is a process running in a loop that monitors the Kubernetes cluster and reacts to changes in specific objects (in this case, FlightTicket resources). Consider the following FlightTicket definition as a starting point:

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

You can create the resource using:

```bash
kubectl create -f flightticket.yaml

kubectl get flighticket
```

> [!Important]
> While it is possible to write a controller in a language like Python, challenges such as managing expensive API calls, and building your own queuing and caching mechanisms might arise.

Developing the controller in Go using the Kubernetes Go client offers a more efficient approach. It provides libraries like shared informers that include built-in queuing and caching support.

## Getting started with the Custom Controller

To begin, clone the SampleController repository from GitHub. Ensure that the Go programming language is installed on your machine, then execute the following command in your terminal:

```bash
git clone https://github.com/kubernetes/sample-controller.git

cd sample-controller
```

Customize the file `controller.go` with your specific business logic. One important function within your controller might involve making a call to the flight booking API after detecting changes in FlightTicket objects.

Once you have incorporated your custom logic, build the controller with the command:

```bash
go build -o sample-controller .
```

During the build process, you may encounter messages such as:

```bash
go: downloading k8s.io/client-go v0.0.0-20211001003700-dbfa30b9d908
go: downloading golang.org/x/text v0.3.6
```

Run the controller by specifying the path to your kubeconfig file:

```bash
./sample-controller -kubeconfig=$HOME/.kube/config
```

You should see log messages that confirm the event handlers are being set up and that the FlightTicket controller is starting:

```bash
I1013 02:11:07.489479  40117 controller.go:115] Setting up event handlers
I1013 02:11:07.489701  40117 controller.go:156] Starting FlightTicket controller
```

## Inside the Controller Code

Your controller code might include sections like the following:

```go
package flightticket

var controllerKind = apps.SchemeGroupVersion.WithKind("Flightticket")

// Code hidden for brevity

// Run begins watching and syncing.
func (dc *FlightTicketController) Run(workers int, stopCh <-chan struct{}) {}

// Code hidden for brevity

// callBookFlightAPI triggers the flight booking process.
func (dc *FlightTicketController) callBookFlightAPI(obj interface{}) {}
```

The controller leverages the specified kubeconfig file to authenticate with the Kubernetes API server. It watches for changes to FlightTicket objects and, upon detecting a creation or modification, it executes your custom logic — such as interfacing with the flight booking API — to reconcile the desired state.

> [!Caution]
> Ensure your API calls are handled efficiently to avoid timeouts and performance issues in production environments.

## Deploying Your Controller

Once your custom controller is fully verified and functional, you may want to package it as a Docker image and deploy it within your Kubernetes cluster as a pod or Deployment. This approach streamlines updates by avoiding the need for manual rebuilding and restarting of the controller with every change.
