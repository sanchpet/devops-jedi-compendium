---
tags:
  - linux
---

[[SCSI]] disks have names like `/dev/sda`, `/dev/sdb` - these files allow us to see whole disk. Disk is divided into smaller parts called *partitions*. They are marked with number after block device (`/dev/sda1`, `/dev/sdb3`) and are represented by [[kernel]] as block devices. Disk stores information about partitions in partition table.

We can work with disk directly through it's [[Devices#Device nodes|node file]] or use [[Filesystems|filesystem]].

# Partitions

## Partition tables

Modern operating systems primarily support two main partition table types: **MBR** (Master Boot Record) and **GPT** (GUID Partition Table). These remain the standard options in tools like Windows Disk Management, macOS Disk Utility, and Linux utilities such as [[parted]] or [[fdisk]].

- **MBR** is considered a legacy format for [[BIOS]] systems, limited to 4 primary partitions (or more with extended/logical) and 2TB max disk size.
- **GPT** is a modern standard for [[UEFI]], supports up to 128 partitions and massive disks.

### MBR

When using MBR, on the physical level disk can have up to 4 *primary partitions*. But we can have more - for this we create *extended partitions* which are divided into logical partitions. OS can use them as common partitions.

#### Primary partitions

They act like autonomous, individual disks and can contain systems of operational files. Boot partition, for example. If we need more partitions, we need to create an extended partition.

#### Extended partitions

Inside the extended partition we can create multiple logic partitions. Extended partition does not store data, it is a container with links to logic partitions where data is stored. This helps to overcome MBR's limit of 4 partitions.

### GPT

## Partition tables management

When working with partition tables, be aware of:

- Data recovery will be significantly hard, since redefinition of borders can delete information about existing [[Filesystems]] on these devices.
- Partitions of given disk should not be used (do not have [[Filesystems]] mounted onto system)
We can manage partitions with many [[Linux]] tools such as [[parted]] or [[fdisk]].

>[!About parted and fdisk]-
>In contrast to `parted`, `fdisk` is more interactive and allows us to see newly created partition tables before save and exit. `parted` performs all changes immediately during work.
>
>All these tools edit partitions in *user space*, as we can read and change block devices inside it. At some moment we have to send a [[System calls|system call]], so that [[kernel]] can read new table and present partitions as block devices. After changes `fdisk` sends a syscall to reload disk's partitions table and kernel outputs debug information. Unlike that, `parted` does not use one call for the whole disk, is signals immediately after changing partitions.

After partition creation we can check it with [[lsblk]] or [[fdisk]]. The thing is, Linux maintains a partition table cache that needs to be updated whenever changes are made.

If we can not see partitions besides devices, we can refresh partitions with [[partprobe]]:

```bash
sudo partprobe
```

Or force [[kernel]] to rescan the device:

```bash
echo 1 > /sys/block/sdX/device/rescan
```

### How kernel reads partition tables

On first read of **MBR** table kernel outputs debug info like this: `sda: sda1 sda2 < sda5 >`. This tells us that `sda2` is an extended partition which contains logical partition `sda5`

# Common actions with disks

Here is a list of common actions performed with disks in daily work.

## Get lists of block devices

We can use [[lsblk]] to get list of block devices along with partition tables:

```bash
$ lsblk
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
...
sda      8:0    0    30G  0 disk
├─sda1   8:1    0     1M  0 part
├─sda2   8:2    0   513M  0 part /boot/efi
└─sda3   8:3    0  29,5G  0 part /var/snap/firefox/common/host-hunspell/
sdb      8:16   0     3G  0 disk
sr0     11:0    1   4,7G  0 rom  /media/sanchpet/Ubuntu 22.04.4 LTS amd64
```

## Get size of block device

But if we want to see size of the disk, and not the partition, we can use [[gdisk]]:

```bash
$ sudo gdisk -l /dev/sda
GPT fdisk (gdisk) version 1.0.8

Partition table scan:
  MBR: protective
  BSD: not present
  APM: not present
  GPT: present

Found valid GPT with protective MBR; using GPT.
Disk /dev/sda: 62914560 sectors, 30.0 GiB
Model: QEMU HARDDISK  
Sector size (logical/physical): 512/512 bytes
Disk identifier (GUID): 88737647-D7A5-4C88-A562-95B6AD2BA310
Partition table holds up to 128 entries
Main partition table begins at sector 2 and ends at sector 33
First usable sector is 34, last usable sector is 62914526
Partitions will be aligned on 2048-sector boundaries
Total free space is 4029 sectors (2.0 MiB)

Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048            4095   1024.0 KiB  EF02  
   2            4096         1054719   513.0 MiB   EF00  EFI System Partition
   3         1054720        62912511   29.5 GiB    8300
```

We can see, which partition system uses our disk - [[GPT]] or [[MBR]].

## Get UUID for partition or filesystem

The plain `UUID=` field displays the filesystem UUID embedded in the superblock (e.g., ext4 UUID), while `PARTUUID=` shows the partition's unique GUID from the partition table (GPT-specific).

```bash
$ sudo blkid /dev/sdb1
/dev/sdb1: UUID="c85461a9-9b5c-49a8-8b74-626d24655dc1" BLOCK_SIZE="4096" TYPE="ext4" PARTLABEL="Linux filesystem" PARTUUID="2e2daffe-1b1e-4d81-adb3-2edf80ebcb15"
```

## How to attach a disk to a new system

1. Create partitions on the disk
2. Refresh partitions cache if needed, check that devices appear in `/dev`
3. Create a [[Filesystems|filesystem]] on a partition
4. Mount filesystem to the running system

---
Sources:

1. Brian Ward — *How Linux Works: What Every Superuser Should Know*
2. [RedHat Documentation](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/8/html/managing_storage_devices/disk-partitions_managing-storage-devices)
3. [ArchLinux WIki](https://wiki.archlinux.org/title/Partitioning)
