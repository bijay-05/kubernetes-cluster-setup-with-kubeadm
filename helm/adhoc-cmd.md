# AdHoc Commands for Helm

```bash
## SEARCH ARTIFACT HUB FROM COMMAND LINE
helm search hub podinfo

## search the repositories added to your local client
helm search repo <REPO_NAME>

## LIST RELEASES
helm list -n <NAMESPACE

## ADD REPO
helm repo add <NAME> <URL>

## update repositories
helm repo update

## remove repositories
helm repo remove

## STATUS OF A RELEASE
helm status <RELASE_NAME> -n <NAMESPACE>


## INSTALLING A PACKAGE
helm install <RELEASE_NAME> <NAME_OF_CHART>
helm install happy-panda bitnami/wordpress

helm uninstall <RELEASE_NAME>


## SEE WHAT VALUES ARE CONFIGURABLE
helm show values <CHART_NAME>

## KEEP TRACK OF A RELEASE'S STATE
helm status <RELEASE_NAME>
helm status happy-panda

## UPGRADE THE RELEASE
helm upgrade -f updated-values.yaml happy-panda bitnami/wordpress

## CHECK WHETHER THE NEW SETTING TOOK EFFECT OR NOT
helm get values happy-panda

## ROLLBACK TO PREVIOUS REVISION
helm rollback happy-panda 1

## VIEW REVISION NUMBERS FOR CERTAIN RELEASE
helm history <RELEASE_NAME>
```
