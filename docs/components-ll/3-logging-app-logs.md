# Managing Application Logs

[Source: Kodekloud Notes](https://notes.kodekloud.com)

This document provides a guide on managing application logs in Kubernetes, covering logging mechanisms in Docker and Kubernetes for effective monitoring and troubleshooting.

## Logging in Docker

Docker containers typically log events to the standard output. Consider the “event simulator” container, which generates random events simulating a web server. When you run this container, it writes log entries such as:

```
docker run kodekloud/event-simulator
2018-10-06 15:57:15,937 - root - INFO - USER1 logged in
2018-10-06 15:57:16,943 - root - INFO - USER2 logged out
2018-10-06 15:57:17,944 - root - INFO - USER3 is viewing page3
2018-10-06 15:57:18,951 - root - INFO - USER4 is viewing page1
```

## Logging in Kubernetes

Deploying the same Docker image within a Kubernetes pod leverages Kubernetes logging capabilities. To get started, create a pod using the following YAML definition:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: event-simulator-pod
spec:
  containers:
    - name: event-simulator
      image: kodekloud/event-simulator

```

```bash
## create the pod with this command
kubectl create -f event-simulator.yaml

## view the live logs
kubectl logs -f event-simulator-pod

```

## Logging with Multiple Containers in a Pod

Kubernetes supports pods with multiple containers. If you update your pod definition to include an additional container named `image-processor`, the configuration will look like this:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: event-simulator-pod
spec:
  containers:
    - name: event-simulator
      image: kodekloud/event-simulator
    - name: image-processor
      image: some-image-processor
```

Attempting to view the logs without specifying the container when multiple containers are present will result in an error. Instead, specify the container name to view its logs:

```bash
kubectl logs -f event-simulator-pod event-simulator
```