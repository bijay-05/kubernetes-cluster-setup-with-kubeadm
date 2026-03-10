# Commands and Arguments in Kubernetes

[Source: KodeKloud Notes](https://notes.kodekloud.com)

This document explains configuring commands and arguments in kubernetes pods. In this session, we'll learn how to adjust container behaviours by overriding default settings defined in the Dockerfile via the pod definition.

## Overriding Default Behaviour with Arguments

When you append an argument to the Docker run command, it overrides the default parameters defined by the CMD instruction in the Dockerfile.

```bash
docker run --name sleeper-container sleeper-image
docker run --name sleeper-container sleeper-image 10
```

Pod definition YAML:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: sleeper-container-pod
spec:
  containers:
  - name: sleeper-container
    image: sleeper-container
    args: ["10"]
```

## Overriding the ENTRYPOINT

```bash
docker run --name sleeper-container \
 --entrypoint sleeper2.0 \
 sleeper-image 10
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: sleeper-container-pod
spec:
  containers:
    - name: sleeper-container
      image: sleeper-image
      command: ["sleeper2.0"]
      args: ["10"]
```

> [!Important]
> Remember that specifying the `command` in a pod definition replaces the Dockerfile's ENTRYPOINT entirely, while the `args` field only overrides the default parameters defined by the CMD.
