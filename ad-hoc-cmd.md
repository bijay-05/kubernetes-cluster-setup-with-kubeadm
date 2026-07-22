# Quick Reference Command Cheatsheet

Please add `alias k="kubectl"` to your `.bashrc` file and reload the shell configuration `source ~/.bashrc".

```bash
## POD Commands
k get po -n kube-system # pods in kube-system namespace
k get pods -A           # pods in all namespaces
k get po -o wide        # get pods with more info
k get po -o yaml        # get info on YAML format


k get nodes             # get nodes in cluster

## Higher Level Objects: Deployments and Services
k get deployment	 # get deployments in default namespace
k get svc | services    # get services


k delete po <podname>   # delete specific pod
k delete po <podname> --grace-period=0 --force  # delete pod forcefully

k exec -it <podname> -- sh | bash

## exec into second container in the pod
k exec -it <podname> -c <containername> -- /bin/sh

## there are two pods in deployment deployment/test-deployment, listening on port 3001
## to port forward to the localhost on master node
## the command creates a secure tunnel from your local machine into pod, service or deployment
k port-forward deployment/test-deployment 3002:3001
```

## Pre Apply Steps

> [!Tip]
> Wrap following into Makefile target (make precheck)

```bash
## SEE EXACTLY WHAT WILL CHANGE
kubectl diff -f manifest.yaml

## FULL SNAPSHOT OF THE CURRENT STATE
kubectl get all,cm,secret,ingress,pvc -n <NAMESPACE>

## CATCH EXISTING WARNING/ERRORS IN THE NAMESPACE BEFORE ADDING MORE
kubectl get events -n <NAMESPACE> --sort-by=.metadata.creationTimestamp

## VALIDATE AGAINST THE API WITHOUT TOUCHING LIVE RESOURCES
kubectl apply -f manifest.yaml --dry-run=server

## CATCH YAML SCHEMA MISTAKES EARLY
kubectl apply --validate=strict -f manifest.yaml

## ENSURE REQUIRED CONFIG VALUES EXIST
kubectl describe configmap <CM_NAME> -n <NAMESPACE>

## CONFIRM THE SECRET EXISTS AND WHICH KEY IT ACTUALLY HOLDS
kubectl get secret <NAME> -n <NAMESPACE> -o jsonpath='{.data}'

## CHECK RESOURCE LIMITS WON'T BLOCK APPLY
kubectl describe quota -n <NAMESPACE>
```
