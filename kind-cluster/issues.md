# Issues

## Error loading Cilium images into KinD worker nodes

```bash
ERROR: failed to load image: command "docker exec --privileged -i testa-cluster-worker ctr --namespace=k8s.io images import --all-platforms --digests --snapshotter=overlayfs -" failed with error: exit status 1Command Output: ctr: content digest sha256:0b913f7ca45c7de25228096cbe6b297de3ee9c8e35268c5eb24a4b2802fcc472: not found
```

> It seems to refer to a different digest when loading into the cluster.

### Solution

Disabling Use containerd for pulling and storing images. Add the following config file to `/etc/docker/daemon.json` and restart the docker service.

```json
{
  "features": {
    "containerd-snapshotter": false
  }
}
```
