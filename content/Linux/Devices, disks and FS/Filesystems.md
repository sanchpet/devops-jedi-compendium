---
tags:
  - linux
  - IT
---
**Filesystem** (FS) is a database that presents block device as a structure of files and directories. FS are stored in partitions. When we want to access a file, firstly we have to use corresponding partition from partition table, then perform a search in FS database.

A filesystem can be presented as last link between kernel and user space for disk operations.

Back in the days FS were stored on physical devices and were designed to store data. But tree-like structure and I/O interface are so handy that now FS can perform multiple tasks. For example, be a system interface like `/proc` and `/sys`. Usually FS are created in [[kernel]], but [[FUSE]] (File System in User Space) allows to create them in user space.

VFS (Virtual File System) finishes up FS implementation ensuring that any FS supports standard interface, to that user space applications can access files and directories. VFS helps Linux support multiple filesystems.

## Filesystem types

There are many filesystems in [[Linux]], all they offer a unified interface to organize and store data:

- [[Ext4]] - main and most common FS. Offers a good balance between performance and features, such as transaction journaling, big file sizes support, persistence to data loss. *ext3* added transaction journaling for data integrity and boot acceleration. *ext4* supports bigger file sizes and higher count of subdirectories.
- [[XFS]] - FS with high performance, designed to work with big data volumes on a high loads. XFS supports big file sizes, has inbuilt backups, provides impressive i/o speed.
- [[Btrfs]] (B-tree FS) - modern FS offering set of advanced features, including FS snapshots, providing extremely high data capacity and smart Copy-on-Write.
- [[ZFS]] (Zettabyte FS) - another modern FS, developed on Sun Microsystems and supported by Oracle. ZFS provides strict control over data, auto-recovery from errors, snapshots and copying on-the-fly. ZFS needs more RAM for stable work.
- [[FAT32]] and [[NTFS]] - FS written for [[Windows]], yet supported in Linux for compatibility.

## Filesystem creation

Like disk partitioning, the FS is created in user space, as process can directly access block device and manage it.

To create a filesystem we have to use a [[mkfs]] command. *mkfs* is an interface to create new FS of the `mkfs.fs` type, where `fs` stands for FS type. For example, to create [[ext4]] filesystem we will use command `mkfs.ext4`:

```shell
mkfs -t ext4 /dev/sdf2
```

It automatically defines block count in device and sets default values.
>[!Superblock]-
>In work process the tool outputs debug data, including the *superblock* information. The *superblock* is a key top-level component of the FS database. `mkfs` even creates several backups in case of problems with the original.

One partition can contain only one FS. Creating an FS on top of an existing one destroys the data.

## Mounting

Mounting is the process that connects FS to the working system. To mount an FS we should know:

- Device, location or FS UUID. Some special FS like proc or sys do not have location.
- Filesystem type
- *Mountpoint* - location in directory tree of current system where the new FS will be attached. It is ordinary directory in any location.
Filesystem mounting is done through [[mount]] tool - `mount -t type device mountpoint`. Example:

```bash
$ sudo mkdir /mnt/disk1
$ sudo mount /dev/sdb1 /mnt/disk1
$ df -h /mnt/disk1
Filesystem      Size  Used Avail Use% Mounted on
/dev/sdb1       974M   24K  907M   1% /mnt/disk1
```

We can also just call `mount` to see all FS that are currently mounted. To unmount FS we can call `umount`. We can `umount` an FS both through device or *mountpoint*:

```shell
umount /dev/sdb1 # this is device node
umount /mnt/disk1 # this is mountpoint
```

If we added filesystem to [[fstab]], then we can mount without pointing the device:

```bash
sudo mount /mnt/disk1
```

### Mount parameters

`mount` has ton of parameters. The divide into:

- Common, that work on any FS. For example, `-t` to set FS type.
- Specific, that work only with suitable FS.
Specific parameters can be activated after `-o` option. For example, `-o remount,rw` will remount read-only FS into read-write mode.

#### Most common short parameters

These common parameters have short syntax:

- `-r` - mounts FS in read-only mode.
- `-n` - guarantees, that `mount` won't try to renew executable system mount database `/etc/mtab`. If the file is unwritable, by default `mount` will fail. This parameter is crucial during boot or when debugging the system in single mode.
- `-t` - sets the FS type.

#### Specific parameters

Are activated after `-o` option, for example:

```shell
mount -t vfat /dev/sde1 /dos -o ri,uid=1000
```

Here `ro` stands for read-only, `uid=1000` tells kernel to handle all the files in FS like their owner is user with 1000 ID.

Often used:

- `exec`, `noexec` - enables of disables program execution in FS
- `suid`, `nosuid` - enables of disables [[setuid]] programs
- `ro` - mounts FS in read-only mode
- `rw` - mounts FS in read-write mode
- `remount` - remounts FS
The next command remounts root directory in read-write mode (after recovery):

```shell
mount -n -o remount /
```

This command supposes that your [[fstab]] has list of devices for `/`. If no, you'll have to set device as additional parameter.

## /etc/fstab

To mount the filesystems on boot OS stores permanent list of FS ant their mount options in `/etc/fstab` file.

String format:

- Device or UUID (modern OS can disallow to use devices instead of UUID)
- Mountpoint
- FS type
- Mount parameters
- Backup info for *dump* tool - obsolete field, now just left as `0`
- Order of integrity check for [[fsck]]. To always begin with root it has to have `1`, everything else can have `2`. `0` will disable boot check, you can use it for special non-disk FS (swap, proc, etc.)
All entries from fstab can be mounted by command `mount -a`.

## Capacity

To check volume usage you can use [[df]] tool.

- Filesystem - device where FS is located
- 1k-blocks - FS capacity in 1024 byte blocks
- Used - used blocks
- Available - available blocks
- Use% - percentage of used blocks
- Mounted on - mountpoint
We can also check [[inode]] usage with `-i` option.

Usually, 5% of capacity is reserved in reserved blocks and does not count in program output. This function preserves system from instant crash after disk space exhaustion.

To see which files are consuming more disk space we can use [[du]]. `du -s` enables sum mode to see consumption of all files inside a directory.

## Filesystem integrity check and recovery

The complex structure of the FS database can accumulate errors (physical disk problems, incorrect system shutdown, failures at the time of writing the FS cache to disk).
[[fsck]] checks the FS for errors. Like [[mkfs]], it has versions for different FS, which it determines itself. Launch:

```shell
fsck /dev/sdb1
```

The command cannot be used for a mounted FS, because the kernel may change the data on the disk at the time of verification. There is an exception - running for the root partition mounted read-only in single mode.

If the program detects a problem in manual mode, it asks for a fix. These error refert to internals of FS - reconnecting loose [[inode]] descriptors and clearing blocks when a file that does not have a name is detected. When reconnecting, such a file is placed in the `lost+found` directory. The name will have to be guessed based on the contents of the file.

The `-p` option fixes common problems without prompting (`-a` does the same). In fact, this is done by the distribution at boot time.
`-y` is a positive auto-answer to all questions.

`fsck -n` runs a FS check without changing anything in it.

If there is a suspicion of damage to the superblock, you can restore the FS using a backup copy of the superblock: `fsck -b num`. To find out where to find a backup superblock, you can run `mkfs -n` on your device to view a list of superblock backups without damaging the data.

## Special purpose FS

Not all FS are repositories. Some of them become system interfaces, representing system information.

- `proc` - is mounted in the `/proc` directory. Each numbered directory inside refers to the identifier of the current process in the system. The files in the directory represent aspects of the process. `/proc/self` is the current process. The FS contains a large amount of information about the kernel and hardware (`/proc/cpuinfo`).
- `sysfs` - mounted in the `sys` directory to display information about devices
- `tmpfs` - is mounted in `/run` and in other places. With it, you can use RAM and swap as temporary storage.
- `squashfs` is a type of read-only file system in which the contents are in a compressed format and extracted on demand using a feedback device. One example is the snap package management system, which mounts packages in the /snap directory
- `overlay` is a file system that combines directory layers into a composite system, often used by containers

## Common actions

### Get size of filesystems

We can see list of mounted filesystems on disks with help of command [[df]]:

```bash
$ df -h /
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda3        29G   13G   15G  48% /
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
