# Nginx-Ingress Controller

This ingress controller is different from the one, that the Kubernetes community is migrating from, i.e., **ingress-nginx**.

Follow this official document to deploy and run **nginx-ingress** controller, [Nginx Docs](https://docs.nginx.com/nginx-ingress-controller/install/manifests/)

```bash
## deploy sample pods, services and ingress object
kubectl apply -f ingress-demo.yaml

## deploy custom nginx-ingress controller pod deployment
kubectl apply -f nginx-ingress-deploy.yaml
```

> [!Caution]
> Keep in mind to pass the `Host: myapp.demo.local` as present in the Ingress manifest file while accessing the NodePort service of nginx-ingress controller deployment

```bash
curl -H "Host:myapp.demo.local" http://<NODEPORT_IP>:<PORT>/foo
```

## Additional References

[Nginx Docs: Install nginx-ingress with Manifests](https://docs.nginx.com/nginx-ingress-controller/install/manifests/)

[Nginx Docs: Ingress Path Regex Annotation](https://docs.nginx.com/nginx-ingress-controller/tutorials/ingress-path-regex-annotation/)
