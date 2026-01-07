---
tags:
  - linux
  - IT
aliases:
---
# Device nodes
Kernel offers a lot of I/O interfaces for user-space represented by files. In Linux, a **device node** (device file, special file) is a file under `/dev` that acts as the user‑space interface to a device driver, identified internally by a major/minor number pair. Key idea:
- A device node looks like a regular file but read/write on it actually talk to the kernel driver, not the filesystem data.[](https://opensource.com/article/16/11/managing-devices-linux)​
- The **major number** selects the driver; the **minor number** selects which device instance that driver controls (for example `/dev/sda`, `/dev/tty0`).

Everything is stored in `/dev`. We can define device type by file mode:
```shell
$ ls -l
brw-rw----  1 root disk      8,   0 Sep 12  2022 sda
crw-rw----  1 root disk     21,   0 Sep 12  2022 sg0
srw-rw-rw-  1 root root           0 Sep 12  2022 log
```
- `b` - block device. `sda` is a disk device with block type. Disk is broke down into blocks of data, has fixed size, is indexed - so processes have fast arbitrary access to any block.
- `c` - char device. Example: `/dev/null`. We can read from them or write into. 
- `p` - named pipe is same as char, but on the end of i/o stream it has another process instead of kernel driver.
- `s` - socket, a special interface for [[IPC]]. Often placed outside `/dev`. 
The numbers before date are major/minor device numbers used for identification by kernel. 

## Block and character devices
Hardware devices fall into **2 main categories**: special character devices and block devices.

Driver interacts with char device by sending separate characters as data, such as bytes. In addition to this, character devices do not need buffering.  Examples: sound cards and sequential ports.

When it comes to block devices, driver receives data from cache. Driver sends to block device a whole block of data. Examples: hard drives and USB.

## sysfs
Kernel has [[sysfs]] interface to uniformly represent connected devices by it's hardware attributes. 
`/sys/devices` has information about devices. 

`ls -l /sys/block` shows all paths to block devices in system. 

To see full path to the device catalogue and other info, we can use [[udevadm]]:
```shell
udevadm info --query=all --name=/dev/sda
```

# udevd
**udevd** manages device nodes - it accepts signals from kernel about new devices, looks for device features, creates nodes, performs init.

**devtmpfs** solves problem of device accessibility during boot to startup **udevd**. 
# Disks
## Common actions
### Get size of partitions
We can see list of mounted partitions on disks with help of command [[df]]:
```bash
$ df -h /
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda3        29G   13G   15G  48% /
```
### Get size of block device
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
### Get lists of block devices
How to see list of block devices? We can use [[lsblk]]:
```bash
$ lsblk
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
...
sda      8:0    0    30G  0 disk 
├─sda1   8:1    0     1M  0 part 
├─sda2   8:2    0   513M  0 part /boot/efi
└─sda3   8:3    0  29,5G  0 part /var/snap/firefox/common/host-hunspell
                                 /
sdb      8:16   0     3G  0 disk 
sr0     11:0    1   4,7G  0 rom  /media/sanchpet/Ubuntu 22.04.4 LTS amd64
```
### Get UUID for block device or filesystem
```bash
$ sudo blkid /dev/sdb1
/dev/sdb1: UUID="c85461a9-9b5c-49a8-8b74-626d24655dc1" BLOCK_SIZE="4096" TYPE="ext4" PARTLABEL="Linux filesystem" PARTUUID="2e2daffe-1b1e-4d81-adb3-2edf80ebcb15"
```
And, for an example, write it to [[fstab]]:
```bash
echo "UUID=c85461a9-9b5c-49a8-8b74-626d24655dc1 /mnt/disk1       ext4    errors=remount-ro 0       1" | sudo tee -a /etc/fstab
```

# Partition tables
On the physical level disk can have up to 4 primary partitions. Structure of data on those disks is called [[MBR]] - Master Boot Record.

## Primary partitions
They act like autonomous, individual disks and can contain systems of operational files. Boot partition, for example. If we need more partitions, we need to create an extended partition.
## Extended partitions.
Inside the extended partition we can create multiple logic partitions. Extended partition does not store data, it is a container with links to logic partitions where data is stored. This helps to overcome MBR's limit of 4 partitions.

This is actual in any filesystem, but actual [[2 Knowledge/IT/Linux]] versions can use [[GPT]] (GUID Partition Table) which does not have limit of 4 partitions, so does not need to use Extended Partition. 

# Attaching new disk to the system
## Creating partition 
First, we have to create a partition if disk is unparted. We can use [[gdisk]] and other options.

After filesystem creation we can check it with [[lsblk]] or [[fdisk]]. The thing is, Linux maintains a partition table cache that needs to be updated whenever changes are made.
If we can not see partitions besides devices, we can refresh partitions with [[partprobe]]:
```bash
sudo partprobe
```
Or force [[kernel]] to rescan the device:
```bash
echo 1 > /sys/block/sdX/device/rescan
```
## Creating a filesystem
To create a filesystem we have to use a [[mkfs]] command. For example, to create [[ext4]] filesystem we will use command `mkfs.ext4`
## Mounting
With [[mount]] tool we can mount filesystem:
```bash
$ sudo mkdir /mnt/disk1
$ sudo mount /dev/sdb1 /mnt/disk1
$ df -h /mnt/disk1
Filesystem      Size  Used Avail Use% Mounted on
/dev/sdb1       974M   24K  907M   1% /mnt/disk1
```
If we added filesystem to [[fstab]], then we can mount and [[umount]] without pointing the device:
```bash
sudo umount /mnt/disk1
sudo mount /mnt/disk1
```

# Network devices
To print out all network devices we can use command:
```shell
sudo lshw -class network
```
or
```shell
lscpi | grep -i network
```
# Useful commands
## dd
[[dd]] tool can access data in block devices directly and ignore files. It is powerful but also dangerous, as can lead to filesystem corruption. 

#TODO write a dd note with examples of usage
## lsscsi
[[lsscsi]] shows all SCSI devices in system