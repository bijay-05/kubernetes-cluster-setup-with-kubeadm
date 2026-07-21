# Utilities for Debugging Cilium Issues

### Get PID for pod (container) with `crictl`

```bash
crictl inspect --output go-template --template '{{.info.pid}}' <CONTAINER_ID>

## GET CONTAINER ID
sudo crictl ps
```

### Add following lines in `.bashrc` to run commands inside pod with `nsenter`

```bash
function nsenter-ctn () {
    CTN=$1  # container ID or name
    # PID=$(sudo docker inspect --format "{{.State.Pid}}" $CTN)
    PID=$(sudo crictl inspect --output go-template --template '{{.info.pid}}' $CTN)
    shift 1 # remove the first argument, shift others to the left
    sudo nsenter -t $PID $@
}

## =========================================== ##
## =========================================== ##

nsenter-ctn b43dfd3232 -n ping google.com
```

> [!Important]
> While running above function in terminal, remember to pass `-n` flag after container ID in order to run the commands in the container's network namespace.

### Checking BPF programs at different network devices in Linux Host

```bash
tc filter show dev lxc00aa ingress

tc filter show dev eth0 ingress

```
