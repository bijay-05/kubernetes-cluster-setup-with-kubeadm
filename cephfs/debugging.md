# Debugging Commands

```bash
ceph -s

## check MDS and POOL status
ceph fs status
ceph mgr services

## check for blocked PGs or down OSDs.
ceph health detail

## ensure all storage daemons are up and in
ceph osd status

## verify that both the metadata and data pools are listed and active.
ceph df

## see which pools are mapped to your filesystem
ceph fs ls

## check the volume created by pvc in ceph subvolume
ceph fs subvolume ls cephfs --group_name=csi

```

> [!Warning]
> The secrets created by helm (while bootstrapping the ceph-csi installation on the kubernetes cluster) uses different `userID` and `userKey` than those provided at runtime. So be sure to check those, when PVC status does not turn to `Bound`.
