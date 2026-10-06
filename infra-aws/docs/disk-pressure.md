# Disk Issues on Nodes (ubuntu)

### Issue 1: Pod Could not be scheduled due to DiskPressure issue

- Added new EBS volumes to EC2 instances.

```bash
lsblk

#nvme0n1 -> old disk
#nvme1n1 -> New EBS disk

sudo mkfs.ex4 -j -L NewSSD /dev/nvme1n1

sudo nano /etc/fstab

sudo mkdir /mnt

sudo mount -av
```

**fstab** content

```
LABEL=NewSSD  /mnt  ext4  defaults  0  2
```
