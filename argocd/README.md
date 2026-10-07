# ArgoCD

ArgoCD as GitOps tool.

```bash
kubectl create namespace argocd

kubectl apply -n argocd --server-side --force-conflicts -f \
  https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl wait --for=condition=ready pod \
  -l app.kubernetes.io/name=argocd-server -n argocd --timeout=180s

kubectl apply -f argocd/argocd-cmd-params.yaml

kubectl apply -f argocd/argocd-ingress.yaml

kubectl rollout restart deployment/argocd-server -n argocd

kubectl rollout status deployment/argocd-server -n argocd --timeout=180s
```

## Ingress Controller: nginx-ingress

We will be using **nginx-ingress** as our self hosted cluster's ingress controller. Following the below steps.

```bash
git clone https://github.com/nginx/kubernetes-ingress.git --branch v5.6.3

kubectl apply -f deployments/common/ns-and-sa.yaml

kubectl apply -f deployments/rbac/rbac.yaml

kubectl apply -f deployments/common/nginx-config.yaml

kubectl apply -f deployments/common/ingress-class.yaml

kubectl apply -f https://raw.githubusercontent.com/nginx/kubernetes-ingress/v5.6.3/deploy/crds.yaml

```

### Deploy Nginx Ingress Controller

```bash
kubectl apply -f deployments/deployment/nginx-ingress.yaml

kubectl create -f deployments/service/nodeport.yaml
```

## Nginx (Web Server) : Forwarding Browser UI requests to NodePort Service of Ingress Controller

```
server {
	listen 80 default_server;
	listen [::]:80 default_server;

	server_name _;

	location / {
		proxy_pass http://10.2.2.183:31814;  ## NodeIP and Port
		proxy_set_header Host 'argocd.local'; ## header value as mentioned in argocd-ingress.yaml
	}
}

```
