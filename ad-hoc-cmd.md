# Quick Reference Command Cheatsheet
Please add `alias k="kubectl"` to your `.bashrc` file and reload the shell configuration `source ~/.bashrc".

```bash
$k get po -n kube-system # pods in kube-system namespace
$k get pods -A           # pods in all namespaces
$k get po -o wide        # get pods with more info
$k get nodes             # get nodes in cluster
$k get deployment	 # get deployments in default namespace
$k get svc | services    # get services
$k delete po <podname>   # delete specific pod
$k exec -it <podname> -- sh | bash
```
