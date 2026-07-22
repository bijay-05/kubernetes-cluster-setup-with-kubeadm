# Secrets in Kubernetes

- set the name of the data item to .dockerconfigjson
- base64 encode the Docker configuration file and then paste that string, unbroken as the value for field data[".dockerconfigjson"]
- set type to kubernetes.io/dockerconfigjson

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: myregistrykey
  namespace: development
data:
  .dockerconfigjson: <base64-encoded-value of config.json file>
type: kubernetes.io/dockerconfigjson
```

## Commands to create and view secrets

```bash
## CREATE SECRET TO ACCESS PRIVATE REGISTRY
kubectl create secret docker-registry regcred \
> --docker-server=<your-registry-server> \
> --docker-username=<your-name> \
> --docker-password=<your-pword> \
> --docker-email=<your-email>


kubectl get secret registrysecret --output="jsonpath={.data.\.dockerconfigjson}" | base64 --decode

kubectl get secret registrysecret --output=yaml
```
