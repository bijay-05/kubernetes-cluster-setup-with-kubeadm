# Demo Microservice

The demo-microservice represents a simple microservice application deployment in the kubernetes cluster. The microservice consists of two services: `api-gateway` and `user-service`, developed with **NestJS** and communicate with eachother over **gRPC**.

The `api-gateway` service is available as a **NodePort** service, while `user-service` is available as a **ClusterIP** service. Both services are deployed as part of **Kubernetes Deployment** object with 2 replicas for each service.

```bash
kubectl apply -f apig-deployment.yaml
kubectl apply -f apig-service.yaml

kubectl apply -f user-deployment.yaml
kubectl apply -f user-service.yaml

```
