# Helm

![Source: Official Helm Documentation](https://helm.sh/docs)

Helm helps you manage Kubernetes applications — Helm Charts help you define, install, and upgrade even the most complex Kubernetes application.

Helm is the package manager for Kubernetes. It helps you define, install, and upgrade applications on a Kubernetes cluster, from a single container to an application with many interdependent parts.

Deploying an application to Kubernetes means writing and maintaining many manifests: Deployments, Services, ConfigMaps, and more. Managing those files by hand across environments and versions is repetitive and error prone. Helm packages these related manifests into a single unit called a chart, which you can version, share, install, and roll back as one release. This lets you treat an application the way a system package manager such as Homebrew, apt, or yum treats software on an operating system.

## Key Components

### Charts

A chart is a Helm package. It contains all of the resource definitions needed to run an application, tool, or service inside a Kubernetes cluster. Think of it as the Kubernetes equivalent of a Homebrew formula, an apt `dpkg`, or a yum `RPM` file.

### Repository

A Repository is the place where charts are collected and shared.

### Release

A release is an instance of a chart running in a Kubernetes cluster. You can install one chart many times into the same cluster, and each installation creates a new release with its own release name. For example, if you want two databases running in your cluster, you can install a MySQL chart twice, and each installation is tracked as a separate release.

To create a release, Helm merges a packaged chart with configuration information. The configuration is a set of values, typically from a `values.yaml` file.

### Upgrade

When a new version of a chart is released, or when you want to change the configuration of your release, you can use the `helm upgrade` command.

An upgrade takes an existing release and upgrades it according to the information you provide. Because Kubernetes charts can be large and complex, Helm tries to perform the least invasive upgrade. It will only update things that have changed since the last release.

> We can use `helm get values <RELEASE_NAME> to see whether that setting took effect or not.

The `helm get` command is a useful tool for looking at a release in the cluster.

> [!Tip]
> Now if something does not go as planned during a release, it is easy to roll back to a previous release using `helm rollback <RELEASE_NAME> <REVISION>`

A release revision is an incremental revision. Every time an install, update, or rollback happens, the revision is incremented by 1.

If a release was created by a rollback, pass `--show-rollback-revision` to `helm history` to add a `ROLLBACK` column to the output. This column shows which revision each rollback targeted.
