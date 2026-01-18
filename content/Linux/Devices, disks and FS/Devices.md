---
tags:
  - linux
  - IT
aliases:
---
# Device nodes

Kernel offers a lot of I/O interfaces for user-space represented by files. In Linux, a **device node** (device file, special file) is a file under `/dev` that acts as the user‑space interface to a device driver, identified internally by a major/minor number pair. Key idea:

- A device node looks like a regular file but read/write on it actually talk to the kernel driver, not the filesystem data.​
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

## lsscsi

[[lsscsi]] shows all SCSI devices in system
