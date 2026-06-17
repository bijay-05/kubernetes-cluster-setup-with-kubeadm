# Kubernetes in Docker ( KinD )

```bash

## create cluster
kind create cluster --name=test-cluster --config=kind-config.yaml

## Setup Helm Repository
helm repo add cilium https://helm.cilium.io/

## pull cilium image and load into worker nodes
docker pull quay.io/cilium/cilium:v1.19.5

docker pull quay.io/cilium/cilium:v1.18.5
kind load docker-image quay.io/cilium/cilium:v1.18.5
```
